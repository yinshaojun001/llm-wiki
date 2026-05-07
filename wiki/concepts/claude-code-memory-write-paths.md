---
title: 三条写入路径——前台写入、后台提取、Auto-dream
tags: [claude-code, memory, agent, context-engineering, concurrency]
date: 2026-05-05
sources: [entities/claude-code]
---

# 三条写入路径

> 源码：`src/services/extractMemories/extractMemories.ts`、`src/services/autoDream/autoDream.ts`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 三条路径总览

```
路径 A：主 Agent 直接写入（用户说"记住 XXX"）
    ↓
    主 Agent 调用 Write/Edit → 写主题文件 + 更新 MEMORY.md
    ↓
    hasMemoryWritesSince() = true → 路径 B 跳过本轮

路径 B：后台提取 Agent（每轮对话结束自动触发）
    ↓
    forked subagent 分析最近消息 → 提取值得记忆的内容
    ↓
    权限沙箱：只能读任意文件，只能写记忆目录

路径 C：Auto-dream（24h + 5 会话触发）
    ↓
    日志整合 → 主题文件 + MEMORY.md 索引
```

---

## 路径 A：主 Agent 直接写入

最简单的路径。用户说"记住我喜欢函数式"，主 Agent 直接调用 Write 工具。

两步操作：
1. 写主题文件 `feedback_code_style.md`（带 frontmatter）
2. 在 MEMORY.md 加一行索引

主 Agent 有完整的写入权限，可以写任意路径。这是唯一的"受信任"写入者。

---

## 路径 B：后台提取 Agent（重点）

### 触发时机

`extractMemories.ts:1-8` 注释：

> It runs once at the end of each complete query loop (when the model produces a final response with no tool calls).

每次 Claude 完成回答（不再调用工具）时，后台启动一个提取 Agent。这是一个 **forked subagent**——共享主 Agent 的 prompt cache，但独立运行。

### 互斥机制

`extractMemories.ts:121-148` 的 `hasMemoryWritesSince()`：

```typescript
function hasMemoryWritesSince(messages, sinceUuid): boolean {
  // 扫描本轮消息，看主 Agent 是否写了记忆文件
  for (const message of messages) {
    if (message.type !== 'assistant') continue
    for (const block of content) {
      const filePath = getWrittenFilePath(block)
      if (filePath !== undefined && isAutoMemPath(filePath)) {
        return true  // 主 Agent 已经写了 → 跳过后台提取
      }
    }
  }
  return false
}
```

**一个 turn 只有一个写入者**。如果主 Agent 本轮已经写了记忆，后台提取 Agent 直接跳过。这避免了两个 Agent 同时写同一个文件的冲突。

### 权限沙箱

`extractMemories.ts:171-222` 的 `createAutoMemCanUseTool()`：

```typescript
// Read/Grep/Glob → 无限制（只读，天然安全）
if (tool.name === FILE_READ_TOOL_NAME || tool.name === GREP_TOOL_NAME || ...) {
  return { behavior: 'allow' }
}

// Bash → 只读命令（ls, find, cat, stat, wc, head, tail）
if (tool.name === BASH_TOOL_NAME) {
  if (tool.isReadOnly(parsed.data)) return { behavior: 'allow' }
  return denyAutoMemTool(...)  // 写命令被拒绝
}

// Edit/Write → 只能写记忆目录
if (tool.name === FILE_EDIT_TOOL_NAME || tool.name === FILE_WRITE_TOOL_NAME) {
  if (isAutoMemPath(filePath)) return { behavior: 'allow' }
}
```

提取 Agent 的权限：
- ✅ 读任意文件
- ✅ 执行只读 shell 命令
- ✅ 写记忆目录
- ❌ 写项目代码
- ❌ 执行写命令（rm, mv, etc.）
- ❌ 使用 MCP 工具
- ❌ 使用 Agent 工具

这是一个严格的权限沙箱。即使提取 Agent 的 LLM 被 prompt injection 攻击，它也**没有能力**修改项目代码。

### Turn 预算

`extractMemories.ts:426`：

```typescript
maxTurns: 5,
```

最多 5 轮。源码注释：

> Well-behaved extractions complete in 2-4 turns (read → write). A hard cap prevents verification rabbit-holes from burning turns.

正常流程：turn 1 读相关文件 → turn 2 写记忆。5 轮是安全上限，防止 LLM 陷入"验证兔子洞"（读代码确认模式存在 → 发现更多代码 → 继续读...）。

### 节流机制

`extractMemories.ts:377-385`：

```typescript
turnsSinceLastExtraction++
if (turnsSinceLastExtraction < (getFeatureValue('tengu_bramble_lintel') ?? 1)) {
  return  // 还没到触发频率
}
turnsSinceLastExtraction = 0
```

不是每轮都跑提取。可配置每 N 轮触发一次（默认 1 = 每轮都跑）。

### 预注入现有记忆

`extractMemories.ts:398-399`：

```typescript
const existingMemories = formatMemoryManifest(
  await scanMemoryFiles(memoryDir, createAbortController().signal),
)
```

提取 Agent 启动前，先扫描所有现有记忆的 frontmatter，生成 manifest 注入 prompt。这样提取 Agent 知道"已经有这些记忆"，避免重复写入。

### 并发处理

`extractMemories.ts:556-563`：

```typescript
if (inProgress) {
  // 如果提取正在进行，把当前 context 暂存，等当前完成后跑一次 trailing
  pendingContext = { context, appendSystemMessage }
  return
}
```

如果用户快速连续发消息，多个提取请求可能同时到达。处理方式：
- 第一个请求正常执行
- 后续请求暂存 context（覆盖旧的暂存）
- 第一个完成后，跑一次 trailing 提取（只处理新消息）

---

## 路径 C：Auto-dream（记忆整合）

Assistant 模式下的记忆写入方式不同。看 `memdir.ts:327-370` 的 `buildAssistantDailyLogPrompt()`：

```typescript
'Write each entry as a short timestamped bullet. Create the file on first write if it does not exist. 
 Do not rewrite or reorganize the log — it is append-only. 
 A separate nightly process distills these logs into MEMORY.md and topic files.'
```

Assistant 会话是长期运行的（可能持续数天）。在这种模式下：
- 新记忆 **append-only** 写入日志文件（`memory/logs/YYYY/MM/YYYY-MM-DD.md`）
- 不维护 MEMORY.md（那是 nightly 进程的事）
- nightly 进程（auto-dream）整合日志 → 主题文件 + 更新 MEMORY.md

类比人类记忆：白天经历存为短期记忆，晚上睡眠时整合。Auto-dream 就是 Claude Code 的"睡眠"。

触发条件：距上次 24h + 累计 5 个会话。使用文件锁防止并发整合。

---

## 并发安全总结

```
主 Agent 写入 ──→ hasMemoryWritesSince() = true ──→ 后台提取跳过
                                                         │
后台提取执行 ──→ inProgress = true ──→ 新请求暂存 ──→ trailing run
                                                         │
Auto-dream   ──→ 文件锁 ──→ 只有一个实例运行
```

三种写入路径永远不会同时操作记忆文件。

---

## 做 Agent 时如何借鉴

1. **前台写入和后台提取必须互斥**：否则会写冲突
2. **后台 Agent 必须有权限沙箱**：只能写记忆目录，不能碰项目代码
3. **要有 turn 预算**：防止 LLM 陷入无限循环
4. **预注入现有记忆清单**：防止重复写入
5. **并发请求用暂存+trailing**：不要启动多个并行提取
6. **长期运行用日志+定期整合**：比实时维护结构化记忆更可靠

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]
- [[concepts/claude-code-memory-recall|LLM 语义路由]]
- [[concepts/claude-code-memory-session|Session Memory]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
