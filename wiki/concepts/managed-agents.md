---
title: Managed Agents 架构
tags: [concept, agent, architecture, anthropic, infrastructure, decoupling, product, pricing]
date: 2026-04-09
updated: 2026-04-10
sources: [sources/managed-agents.md, sources/managed-agents-launch-2026-04.md]
---

# Managed Agents 架构

Anthropic 推出的托管 Agent 服务，核心思想是将 Agent 的三个组件解耦为独立接口，使每个组件可以独立失败或替换，且接口设计能"活过"任何具体实现。

---

## 三组件模型

```
┌─────────────────────────────────────────┐
│              Session（事件日志）           │
│  append-only，存在所有组件之外，永久持久化   │
└────────────────┬────────────────────────┘
                 │ getEvents() / emitEvent()
    ┌────────────▼────────────┐
    │   Harness（Brain）       │
    │   调用 Claude 的循环      │
    │   无状态，可热重启         │
    └────────────┬────────────┘
                 │ execute(name, input) → string
    ┌────────────▼────────────┐
    │   Sandbox（Hands）       │
    │   执行环境：容器/工具/MCP  │
    │   按需 provision，可替换  │
    └─────────────────────────┘
```

---

## 核心接口

| 接口 | 用途 |
|---|---|
| `execute(name, input) → string` | Brain 调用任意 Hand（容器、MCP、自定义工具均用此接口） |
| `provision({resources})` | 按需创建新 sandbox |
| `wake(sessionId)` | 新 harness 从 session log 恢复执行 |
| `getSession(id)` | 获取完整 session 事件日志 |
| `emitEvent(id, event)` | Harness 向 session 写入事件 |
| `getEvents()` | 按需检索事件切片（支持位置索引、倒回、范围查询） |

---

## Pets vs Cattle

旧设计是"宠物"基础设施——容器挂了需要人工抢救，调试困难，扩展受限。
解耦后所有组件变成"牛"——可随时 provision 新的，失败直接替换。

---

## 安全模型

凭证永远不进入 sandbox（Claude 生成代码运行的地方）：

- **Git**：用 access token 在初始化时 clone，token wire 进 git remote，之后 push/pull 不需要 agent 接触 token
- **OAuth 工具（MCP）**：token 存在 vault，Claude 通过 proxy 调用 MCP，proxy 持有 session token 去 vault 取凭证

---

## 性能提升

解耦前：每个 brain 需要一个预先启动的容器，session 还没开始就要付启动成本。
解耦后：容器只在 Claude 真正需要执行时通过 `execute()` 按需创建。

| 指标 | 变化 |
|---|---|
| p50 TTFT | 降低约 60% |
| p95 TTFT | 降低超过 90% |

---

## Many Brains, Many Hands

- 多个无状态 harness 可并发运行，互不干扰
- 每个 hand 都是 `execute(name, input) → string`，harness 不关心 hand 是容器、手机还是 Pokémon 模拟器
- Brain 可以把 hand 传给另一个 brain

---

## 设计哲学

**Meta-harness**：不规定用哪个具体 harness，只规定接口形状。Claude Code 是一个优秀的 harness，任务特定 harness 在窄领域也很强，Managed Agents 都能容纳。

关联：[[concepts/agent-session]] · [[concepts/mcp]] · [[sources/managed-agents]] · [[sources/managed-agents-launch-2026-04]]

---

## 产品状态（2026-04-08 公开测试）

**定位**：Anthropic 正式入局"Agent 即服务"赛道，开发者用自然语言或 YAML 定义任务/工具/规则，基础设施全由云端托管。

### Sessions API

```
POST /v1/sessions               → 创建 Agent 会话
GET  /v1/sessions/{id}/stream   → 流式结果（SSE）
```

事件历史服务端持久化，断线可从 checkpoint 续跑。

### 定价

| 费用项 | 价格 |
|---|---|
| Token 消耗 | 按 Claude 标准 API 定价 |
| 会话运行时间 | **$0.08 / 活跃会话小时**（精确到毫秒） |
| 内置网页搜索 | **$10 / 1000 次** |

### 企业用例

| 公司 | 用法 |
|---|---|
| Notion | 工作区内并行跑几十个任务 |
| Rakuten | 各条线专用 Agent，一周内上线 |
| Sentry | bug 根因→补丁→PR 一条龙 |
| Asana | 加速 AI Teammates 开发 |

### 竞争定位

vs OpenAI Codex：两家都在做"卖模型"→"卖开发平台"。区别在多 Agent 模式：Codex 各 Agent 独立并行，Managed Agents 的主 Agent 会分配任务给子 Agent 并追踪进度（更像团队协作）。
