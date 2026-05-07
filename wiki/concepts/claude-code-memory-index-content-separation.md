---
title: 索引-内容分离——MEMORY.md 的架构哲学
tags: [claude-code, memory, context-engineering, architecture]
date: 2026-05-05
sources: [entities/claude-code]
---

# 索引-内容分离

> 源码：`src/memdir/memdir.ts:34-103`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 核心矛盾

记忆系统的根本矛盾：**记忆越多 → context 越满 → 留给实际工作的空间越小**。

如果把所有记忆都塞进 system prompt，100 条记忆可能占掉 50K tokens，留给代码编辑的空间就小了。但如果完全不加载记忆，Agent 每次都是失忆状态。

Claude Code 的解法：**索引-内容分离**。

---

## MEMORY.md 是什么？

`memdir.ts:34-38`：

```typescript
export const ENTRYPOINT_NAME = 'MEMORY.md'
export const MAX_ENTRYPOINT_LINES = 200
export const MAX_ENTRYPOINT_BYTES = 25_000
```

MEMORY.md 是一个**目录文件**，不是记忆存储本身。它只包含一行一条的索引：

```markdown
- [用户偏好代码风格](feedback_code_style.md) — 函数式优先，不用 class 组件
- [Pipeline bug 跟踪](ref_pipeline_bugs.md) — 在 Linear INGEST 项目
- [用户画像](user_role.md) — 7 年 Java，刚转前端
```

**铁律**：Never write memory content directly into MEMORY.md.

看 `memdir.ts:226-227` 的写入指令：

> `MEMORY.md` is an index, not a memory — each entry should be one line, under ~150 characters: `- [Title](file.md) — one-line hook`. It has no frontmatter. Never write memory content directly into `MEMORY.md`.

---

## 为什么有硬上限？

200 行 / 25,000 字节——因为 **MEMORY.md 常驻 system prompt**。

每次会话启动，`loadMemoryPrompt()` 会把 MEMORY.md 的内容注入 system prompt。如果不限制大小：
- 记忆 100 条 → ~15,000 bytes → 还行
- 记忆 500 条 → ~75,000 bytes → context 爆了

200 行 × ~125 字符/行 ≈ 25KB，这是一个经验阈值：足以容纳大多数项目的记忆索引，又不会挤占工作空间。

---

## 截断逻辑

`memdir.ts:57-103` 的 `truncateEntrypointContent()`：

```typescript
export function truncateEntrypointContent(raw: string): EntrypointTruncation {
  // 1. 先按行截断（200 行）
  let truncated = wasLineTruncated
    ? contentLines.slice(0, MAX_ENTRYPOINT_LINES).join('\n')
    : trimmed

  // 2. 再按字节截断（25KB），在最后一个换行符处切割（不切半行）
  if (truncated.length > MAX_ENTRYPOINT_BYTES) {
    const cutAt = truncated.lastIndexOf('\n', MAX_ENTRYPOINT_BYTES)
    truncated = truncated.slice(0, cutAt > 0 ? cutAt : MAX_ENTRYPOINT_BYTES)
  }

  // 3. 追加警告
  return {
    content: truncated + `\n\n> WARNING: MEMORY.md is ${reason}. Only part of it was loaded.`,
    ...
  }
}
```

两层截断的原因（源码注释 `memdir.ts:36-37`）：

> ~125 chars/line at 200 lines. At p97 today; catches long-line indexes that slip past the line cap (p100 observed: 197KB under 200 lines).

有人可能一行写 1000 字符，200 行就 200KB 了。所以字节上限是第二道防线。

截断时在**最后一个换行符处**切割（`lastIndexOf('\n')`），不切半行。被截断的部分会显示警告，提醒用户精简索引。

---

## 写入的两步法

保存一条记忆需要两步：

**Step 1** — 写主题文件（独立 .md）：

```yaml
---
name: 用户偏好代码风格
description: 用户偏好函数式风格，避免 class 组件
type: feedback
---

不要用 class 组件，优先用函数式写法。
**Why:** 用户 7 年 Java 经验...
```

**Step 2** — 在 MEMORY.md 加一行索引：

```markdown
- [用户偏好代码风格](feedback_code_style.md) — 函数式优先，不用 class 组件
```

为什么需要两步？因为：
- 主题文件可以很大（包含完整内容 + Why + How to apply）
- MEMORY.md 必须很小（只有一行钩子）
- Agent 先看索引判断哪些记忆相关，再按需读取主题文件

---

## 内容如何按需加载？

MEMORY.md 只是"目录"。真正把记忆内容加载进 context 的是 `findRelevantMemories()`（详见 [[concepts/claude-code-memory-recall|LLM 语义路由]]）。

流程：
1. 用户发消息
2. MEMORY.md 已在 system prompt 中（轻量索引）
3. 后台扫描所有记忆文件的 frontmatter
4. Sonnet 选出 ≤5 个相关记忆
5. 被选中的记忆文件内容作为附件注入 context

这样：
- 100 条记忆 → 只有 5 条进入 context
- 索引 25KB + 5 条内容 ≈ 可控的 token 消耗

---

## 做 Agent 时如何借鉴

1. **索引必须有硬上限**：不然会无限膨胀
2. **索引和内容用不同文件**：索引常驻 context，内容按需加载
3. **一行一条索引**：索引是"钩子"，不是"摘要"
4. **截断时要警告用户**：不要静默丢弃
5. **两层截断（行 + 字节）**：防止极端情况（少数超长行）

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-taxonomy|四种记忆类型]]
- [[concepts/claude-code-memory-recall|LLM 语义路由]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
