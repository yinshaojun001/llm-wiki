---
title: Agent Session（外部上下文存储）
tags: [concept, agent, session, context, memory, managed-agents]
date: 2026-04-09
sources: [sources/managed-agents.md]
---

# Agent Session（外部上下文存储）

Managed Agents 中 Session 的设计模式：将上下文存储从 Claude 的 context window 中分离，作为**持久化事件日志**存在于所有 agent 组件之外。

---

## 核心思想

传统的 context 管理（压缩摘要、裁剪 token）都是**不可逆决策**——你无法预知未来的 turn 需要哪些 token，一旦丢弃就找不回来。

Session 的解法：**不做不可逆决策**。所有事件 append-only 写入 session log，harness 通过 `getEvents()` 按需检索所需切片，然后再决定怎么传给 Claude 的 context window。

---

## 接口设计

```python
# 按位置检索事件切片
events = getEvents(session_id, start=0, end=100)

# 从上次停下来的位置继续
events = getEvents(session_id, start=last_read)

# 重读某个动作前的上下文（倒回几个事件）
events = getEvents(session_id, before=action_event_id, window=5)
```

---

## 与 context window 的关系

```
Session Log（外部，持久）
    ↓ getEvents()（按需检索）
Harness（可做任意变换：压缩、重排、cache 优化）
    ↓ 传入
Claude Context Window（当前推理用）
```

关键：**可恢复性**由 session 保证，**具体用什么上下文策略**由 harness 决定，两个关切被分开。

---

## Session 还解决的问题

**Harness 无状态化**：harness 崩溃后，新实例通过 `wake(sessionId)` + `getSession(id)` 即可恢复到最后一个事件，无需任何 in-memory 状态。

---

## 与记忆机制的关系

Session 是一种特定的**情景记忆**实现——每个 agent 执行的完整事件轨迹。与通用记忆机制的对比：

| 维度 | Session | 通用记忆（向量 DB 等） |
|---|---|---|
| 粒度 | 单次 agent 执行的完整事件流 | 跨 session 的长期知识 |
| 检索方式 | 位置索引、时间切片 | 语义相似度 |
| 可逆性 | 完全可逆（append-only） | 取决于实现 |

关联：[[concepts/managed-agents]] · [[concepts/agent-memory]] · [[sources/managed-agents]]
