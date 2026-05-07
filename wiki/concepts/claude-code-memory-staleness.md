---
title: 过期管理——不删记忆，但提醒可能过期
tags: [claude-code, memory, agent, context-engineering, staleness]
date: 2026-05-05
sources: [entities/claude-code]
---

# 过期管理

> 源码：`src/memdir/memoryAge.ts`、`src/memdir/memoryTypes.ts:240-256`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 核心原则：不自动删除

Claude Code 源码中**没有自动删除旧记忆的逻辑**。

为什么？因为 **过期 ≠ 无用**：
- 一个 30 天前的 feedback（"不要 mock 数据库"）→ 仍然完全有效
- 一个 2 天前的 project（"周四开始 merge freeze"）→ 可能已经过期

时间不能判断记忆是否过期，只有**内容本身**能判断。所以策略是：不删，但提醒。

---

## 时间衰减标签

`memoryAge.ts:6-8`：

```typescript
export function memoryAgeDays(mtimeMs: number): number {
  return Math.max(0, Math.floor((Date.now() - mtimeMs) / 86_400_000))
}
```

`memoryAge.ts:15-20`：

```typescript
export function memoryAge(mtimeMs: number): string {
  const d = memoryAgeDays(mtimeMs)
  if (d === 0) return 'today'
  if (d === 1) return 'yesterday'
  return `${d} days ago`
}
```

为什么用人类可读的 "47 days ago" 而不是 ISO 时间戳？源码注释：

> Models are poor at date arithmetic — a raw ISO timestamp doesn't trigger staleness reasoning the way "47 days ago" does.

LLM 不擅长日期算术。给它 "2026-03-18" 它不会觉得旧；给它 "47 days ago" 它立刻意识到这可能过期了。

---

## 过期警告

`memoryAge.ts:33-42`：

```typescript
export function memoryFreshnessText(mtimeMs: number): string {
  const d = memoryAgeDays(mtimeMs)
  if (d <= 1) return ''  // 今天/昨天的记忆不警告
  return (
    `This memory is ${d} days old. ` +
    `Memories are point-in-time observations, not live state — ` +
    `claims about code behavior or file:line citations may be outdated. ` +
    `Verify against current code before asserting as fact.`
  )
}
```

关键设计：
- **≤1 天不警告**：新鲜记忆的警告是噪音
- **>1 天附加警告**：提醒 LLM 这是"时间点快照"，不是"实时状态"

源码注释解释了动机：

> Motivated by user reports of stale code-state memories (file:line citations to code that has since changed) being asserted as fact — the citation makes the stale claim sound more authoritative, not less.

用户报告：记忆说"在 `src/auth.ts:42` 有 `validateToken` 函数"，但那个函数已经被重命名了。因为记忆引用了具体的文件和行号，LLM 说得特别自信——但完全错了。

**精确引用 + 过期 = 危险组合**。所以警告特别提到 "file:line citations may be outdated"。

---

## system prompt 中的信任指令

`memoryTypes.ts:240-256` 的 `TRUSTING_RECALL_SECTION`：

```typescript
export const TRUSTING_RECALL_SECTION = [
  '## Before recommending from memory',
  '',
  'A memory that names a specific function, file, or flag is a claim that it existed *when the memory was written*.',
  'It may have been renamed, removed, or never merged. Before recommending it:',
  '',
  '- If the memory names a file path: check the file exists.',
  '- If the memory names a function or flag: grep for it.',
  '- If the user is about to act on your recommendation, verify first.',
  '',
  '"The memory says X exists" is not the same as "X exists now."',
]
```

### 为什么标题是 "Before recommending" 而不是 "Trusting what you recall"？

源码注释（`memoryTypes.ts:228-238`）：

> H1 (verify function/file claims): 0/2 → 3/3 via appendSystemPrompt. When buried as a bullet under "When to access", dropped to 0/3 — **position matters**. The H1 cue is about what to DO with a memory, not when to look, so it needs its own section-level trigger context.

同样是要求"验证记忆中的文件引用"：
- 作为 "When to access memories" 的一个 bullet → 0/3 通过率
- 作为独立的 "Before recommending from memory" section → 3/3 通过率

**位置决定效果**。行动指令需要在决策点触发，不能埋在其他 section 里。

### 验证清单

给 LLM 的三条具体行动：
1. 记忆提到文件路径 → 检查文件是否存在
2. 记忆提到函数/flag → grep 一下
3. 用户要基于记忆行动 → 先验证

这不是抽象的"要小心"，而是具体的"做这几步"。

---

## 漂移警告

`memoryTypes.ts:201-202`：

```typescript
export const MEMORY_DRIFT_CAVEAT =
  '- Memory records can become stale over time. Use memory as context for what was true at a given point in time. ' +
  'Before answering the user or building assumptions based solely on information in memory records, ' +
  'verify that the memory is still correct and up-to-date by reading the current state of the files or resources. ' +
  'If a recalled memory conflicts with current information, trust what you observe now — ' +
  'and update or remove the stale memory rather than acting on it.'
```

核心规则：**如果记忆和当前观察冲突，信任当前观察，并更新/删除过期记忆**。

这是一个正向循环：
1. 记忆可能过期
2. LLM 验证后发现过期
3. LLM 更新/删除过期记忆
4. 记忆库保持准确

---

## 做 Agent 时如何借鉴

1. **不要自动清理记忆**：过期 ≠ 无用，只有内容能判断
2. **给记忆加"年龄标签"**：人类可读的时间（"47 days ago"），不是 ISO 时间戳
3. **≤1 天不警告**：新鲜记忆的警告是噪音
4. **精确引用 + 过期 = 危险组合**：对 file:line 引用特别警惕
5. **行动指令要放在决策点**：验证记忆的指令要独立成 section，不能埋在其他地方
6. **建立正向循环**：发现过期 → 更新/删除 → 记忆库保持准确

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-recall|LLM 语义路由]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
- [[concepts/agent-memory|Agent 记忆机制（论文综述）]]
