---
title: Session Memory 与 Auto-dream——会话内记忆与记忆整合
tags: [claude-code, memory, agent, context-engineering, session, compaction]
date: 2026-05-05
sources: [entities/claude-code]
---

# Session Memory 与 Auto-dream

> 源码：`src/services/SessionMemory/`、`src/services/autoDream/autoDream.ts`、`src/memdir/memdir.ts:327-370`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## Session Memory：会话内的压缩缓冲

### 解决什么问题？

长对话会撞上 context window 上限。当 context 太长时，Claude Code 会执行 **compaction**（压缩）——把旧消息总结为更短的形式。

但压缩有风险：关键信息可能丢失。比如：
- 第 3 轮：用户说"用 Kryo 做深拷贝"
- 第 50 轮：context 太长，压缩
- 压缩后："用户要实现深拷贝"（丢失了"用 Kryo"这个关键细节）

Session Memory 就是压缩时的**安全网**。

### 存储

路径：`~/.claude/session-memory/<session-id>.md`

结构化模板（`SessionMemory/prompts.ts`）：

```markdown
## Session Title
## Current State
## Task Specification
## Files and Functions
## Workflow
## Errors & Corrections
## Codebase Documentation
## Learnings
## Key Results
## Worklog
```

每个 section 有明确的职责，让 LLM 知道什么信息该放哪里。

### 触发条件

`SessionMemory/sessionMemoryUtils.ts` 定义的阈值：

```typescript
minimumMessageTokensToInit: 10000,    // 首次提取：上下文 ≥ 10K tokens
minimumTokensBetweenUpdate: 5000,     // 后续更新：增长 ≥ 5K tokens
toolCallsBetweenUpdates: 3,           // 或工具调用 ≥ 3 次
```

不是一开始就写 Session Memory——短对话不需要。只在对话变长、信息变多时才开始。

### 在压缩时的作用

当 compaction 触发时：
1. 读取 Session Memory 内容
2. 注入到压缩后的 context 中
3. 每个 section 限 2,000 tokens，总计限 12,000 tokens

这样即使对话被压缩，关键信息（当前状态、文件列表、已犯的错误、学到的东西）仍然在 context 中。

### 可定制

用户可以在 `~/.claude/session-memory/config/` 放：
- `template.md`：自定义模板结构
- `prompt.md`：自定义提取指令

---

## Auto-dream：记忆的"睡眠整合"

### 解决什么问题？

Assistant 模式下的会话可能持续数天。如果每次都实时维护 MEMORY.md：
- 频繁写入 → I/O 开销
- 日志式记忆 → MEMORY.md 膨胀
- 没有整合 → 噪音积累

Auto-dream 的思路：**先记日志，后整合**。

### 类比人类记忆

```
白天：经历 → 短期记忆（海马体，日志文件）
晚上：睡眠 → 整合到长期记忆（大脑皮层，主题文件 + MEMORY.md）
```

Auto-dream 就是 Claude Code 的"睡眠"。

### 日志模式

`memdir.ts:327-370` 的 `buildAssistantDailyLogPrompt()`：

```typescript
'Write each entry as a short timestamped bullet. Create the file on first write if it does not exist. 
 Do not rewrite or reorganize the log — it is append-only. 
 A separate nightly process distills these logs into MEMORY.md and topic files.'
```

日志路径模式：`memory/logs/YYYY/MM/YYYY-MM-DD.md`

关键约束：
- **append-only**：只追加，不修改已有内容
- **不整理**：日志是原始记录，整理是 nightly 进程的事
- **按日期分文件**：天然的时间分界

### 整合进程

`autoDream.ts` 实现的整合逻辑：
- 触发条件：距上次 24h + 累计 5 个会话
- 功能：读取日志 → 提炼要点 → 写入主题文件 → 更新 MEMORY.md
- 使用文件锁防止并发整合

整合后的日志不会被删除（保留原始记录），但 MEMORY.md 只包含提炼后的索引。

---

## 两种模式的对比

| 维度 | 标准模式 | Assistant 日志模式 |
|------|----------|-------------------|
| 写入目标 | 直接写主题文件 + MEMORY.md | append-only 日志文件 |
| MEMORY.md 维护 | 实时 | nightly 整合 |
| 适用场景 | CLI 短会话 | 长期运行的 Assistant |
| 整合频率 | 每轮（后台提取 Agent） | 每 24h（auto-dream） |
| 噪音控制 | 提取 Agent 自行判断 | 整合时统一过滤 |

---

## 做 Agent 时如何借鉴

1. **长对话需要 Session Memory**：作为压缩时的安全网
2. **结构化模板比自由格式好**：让 LLM 知道什么信息放哪里
3. **阈值触发而非实时**：短对话不需要 Session Memory
4. **长期运行用日志+定期整合**：比实时维护更可靠
5. **日志要 append-only**：不修改已有内容，整合是另一个进程的事
6. **整合要有锁**：防止并发写入

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-write-paths|三条写入路径]]
- [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
- [[concepts/agent-session|Session 作为外部上下文存储]]
