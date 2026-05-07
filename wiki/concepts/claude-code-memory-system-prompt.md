---
title: 记忆行为指令——system prompt 如何驱动记忆系统
tags: [claude-code, memory, agent, context-engineering, prompt-engineering]
date: 2026-05-05
sources: [entities/claude-code]
---

# 记忆行为指令

> 源码：`src/memdir/memdir.ts:199-266`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 核心思想：用 prompt 驱动，而非代码驱动

Claude Code 的记忆管理（存什么、不存什么、怎么存、什么时候读）**全部由 system prompt 指令驱动**，不是由代码规则驱动。

代码只负责：
- 持久化文件的读写
- 权限控制
- 触发时机

而"该不该存这条记忆"、"这条记忆是否相关"、"这条记忆是否过期"——这些判断全部交给 LLM 自己。

---

## buildMemoryLines() 拆解

`memdir.ts:199-266` 构建了完整的记忆行为指令。逐段拆解：

### 1. 开场白

```typescript
`You have a persistent, file-based memory system at \`${memoryDir}\`.`,
'',
"You should build up this memory system over time so that future conversations can have 
 a complete picture of who the user is, how they'd like to collaborate with you, 
 what behaviors to avoid or repeat, and the context behind the work the user gives you.",
```

告诉 LLM：
- 记忆系统存在（路径在哪）
- 为什么要积累记忆（让未来会话更聪明）

### 2. 显式触发

```typescript
'If the user explicitly asks you to remember something, save it immediately.',
'If they ask you to forget something, find and remove the relevant entry.',
```

用户说"记住 X" → 立刻存。用户说"忘掉 X" → 找到并删除。

### 3. 四种类型定义

```typescript
...TYPES_SECTION_INDIVIDUAL,
```

详见 [[concepts/claude-code-memory-taxonomy|四种记忆类型]]。

### 4. 反面清单

```typescript
...WHAT_NOT_TO_SAVE_SECTION,
```

详见 [[concepts/claude-code-memory-taxonomy|四种记忆类型]] 中的"不存什么"。

### 5. 怎么存（两步法）

```typescript
'Saving a memory is a two-step process:',
'',
'**Step 1** — write the memory to its own file using this frontmatter format:',
...MEMORY_FRONTMATTER_EXAMPLE,
'',
'**Step 2** — add a pointer to that file in MEMORY.md.',
```

详见 [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]。

### 6. 什么时候读

```typescript
...WHEN_TO_ACCESS_SECTION,
```

```typescript
'## When to access memories',
'- When memories seem relevant, or the user references prior-conversation work.',
'- You MUST access memory when the user explicitly asks you to check, recall, or remember.',
'- If the user says to *ignore* or *not use* memory: proceed as if MEMORY.md were empty.',
```

三种触发：
1. 看起来相关 → 自动读
2. 用户要求 → 必须读
3. 用户说忽略 → 完全不提记忆

第三条是 eval-validated 的（`memoryTypes.ts:207-211`）：之前没有时，用户说"ignore memory about X"，Claude 还会说"not Y as noted in memory"——把"ignore"理解为"acknowledge then override"而不是"don't reference at all"。

### 7. 怎么信任回忆

```typescript
...TRUSTING_RECALL_SECTION,
```

详见 [[concepts/claude-code-memory-staleness|过期管理]]。

### 8. 与其他持久化的区别

```typescript
'## Memory and other forms of persistence',
'- When to use a Plan instead of memory: for non-trivial implementation alignment',
'- When to use Tasks instead of memory: for current conversation progress tracking',
```

Claude Code 有三种持久化机制：

| 机制 | 用途 | 生命周期 |
|------|------|----------|
| Memory | 跨会话的知识积累 | 永久 |
| Plan | 当前任务的实现方案 | 当前会话 |
| Task | 当前任务的进度追踪 | 当前会话 |

这段指令告诉 LLM：不要把"实现方案"存为记忆（那是 Plan 的事），不要把"任务进度"存为记忆（那是 Task 的事）。

### 9. 搜索历史上下文

```typescript
...buildSearchingPastContextSection(memoryDir),
```

当记忆文件不够时，提供两个搜索入口：
1. 记忆目录 grep
2. 会话 transcript grep（最后手段，大文件慢）

---

## 指令的 Eval 验证

源码注释中多次提到 eval-validated。Claude Code 团队用 eval 来验证每条指令的效果：

- **H1（验证文件引用）**：作为独立 section → 3/3 通过；埋在其他 section → 0/3
- **H5（噪音过滤）**：3/3 通过
- **H6（ignore 指令）**：之前没有 → 用户说 ignore 还是会引用；加上后 → 正确忽略
- **"Before recommending" vs "Trusting what you recall"**：前者 3/3，后者 0/3

**位置和措辞都影响效果**。同样的内容，放在不同位置、用不同标题，效果可能完全不同。

---

## 做 Agent 时如何借鉴

1. **用 prompt 驱动判断，用代码驱动执行**：该不该存 → LLM 决定；怎么存 → 代码执行
2. **指令要覆盖完整生命周期**：存什么、不存什么、怎么存、什么时候读、怎么信任
3. **行动指令要放在决策点**：验证记忆的指令要独立成 section
4. **用 eval 验证每条指令**：位置和措辞都影响效果
5. **区分持久化机制**：记忆 vs 计划 vs 任务，各司其职
6. **提供搜索回退**：记忆文件不够时，可以 grep 历史 transcript

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-taxonomy|四种记忆类型]]
- [[concepts/claude-code-memory-staleness|过期管理]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
- [[concepts/agent-prompt-principles|Agent Prompt 设计原则]]
