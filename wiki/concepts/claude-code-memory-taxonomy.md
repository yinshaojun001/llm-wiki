---
title: Claude Code 记忆分类法——四种类型与"不存什么"
tags: [claude-code, memory, agent, taxonomy, context-engineering]
date: 2026-05-05
sources: [entities/claude-code]
---

# Claude Code 记忆分类法

> 源码：`src/memdir/memoryTypes.ts`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 第一性原理：只记推导不出来的东西

源码注释（`memoryTypes.ts:5-12`）开宗明义：

> Memories are constrained to four types capturing context **NOT derivable from the current project state**. Code patterns, architecture, git history, and file structure are derivable (via grep/git/CLAUDE.md) and should NOT be saved as memories.

关键词：**NOT derivable**（不可推导的）。

这是整个记忆系统的第一条设计原则：**只记推导不出来的东西**。

判断标准很简单——问自己：**这个信息能不能通过工具调用（grep、git log、读文件）推导出来？**

- 代码模式？`grep` 能找到 → 不记
- Git 历史？`git log` 能查 → 不记
- 文件架构？读目录就行 → 不记
- 用户是数据科学家？**没有任何工具能推导** → 记！
- 用户讨厌 mock 测试？**代码里看不出来** → 记！
- 周四开始 merge freeze？**git 里没有** → 记！

---

## 四种记忆类型

源码 `memoryTypes.ts:14-19` 定义了封闭的四类型分类法：

```typescript
export const MEMORY_TYPES = ['user', 'feedback', 'project', 'reference'] as const
```

### 1. user — 用户画像

**核心问题**：用户是谁？

**为什么推导不出来**：没有任何文件记录用户的角色、经验水平、知识背景。

**典型内容**：
- "数据科学家，正在调查日志系统"
- "7 年 Java 经验，刚转前端"
- "第一次接触 React"

**使用场景**：当你的回答应该因人而异时。给 senior engineer 解释前端概念和给初学者解释完全不同。

**作用域**：始终私有。用户画像不该共享给团队。

### 2. feedback — 工作方式指导

**核心问题**：用户喜欢/讨厌什么工作方式？

**为什么推导不出来**：偏好只在对话中表达，不在代码里。

**关键设计**——同时记纠正和确认：

> Record from failure AND success: if you only save corrections, you will avoid past mistakes but drift away from approaches the user has already validated, and may grow overly cautious.

只记"不要做什么"会导致 Agent 越来越保守。也要记"这样做很好"。

**必须包含 `Why` 和 `How to apply`**：

```markdown
不要用 class 组件，优先用函数式写法。
**Why:** 用户 7 年 Java 经验，转前端后觉得 class 混淆了两种语言的心智模型。
**How to apply:** 所有 React 组件默认用函数式 + hooks。
```

知道 **Why** 才能判断边界情况。"不要 mock 数据库" → 如果只是单元测试呢？看 Why（"上次 mock 测试全过了但生产挂了"）→ 单元测试可以 mock，集成测试不行。

**作用域**：默认私有。只有当指导是"项目级惯例"（每个贡献者都该遵守）时才升级为团队。

### 3. project — 项目动态

**核心问题**：正在发生什么？

**为什么推导不出来**：决策、截止日期、事件、动机不在 git 里。

**关键设计**——相对日期必须转绝对日期：

> Always convert relative dates in user messages to absolute dates when saving (e.g., "Thursday" → "2026-03-05"), so the memory remains interpretable after time passes.

"下周四开始 freeze" → 存为 "2026-03-05 开始 merge freeze"。否则一个月后读到这条记忆，"下周四"是哪周？

**同样需要 Why 和 How to apply**：

```markdown
auth middleware rewrite is driven by legal/compliance requirements
**Why:** legal flagged it for storing session tokens in a way that doesn't meet new compliance
**How to apply:** scope decisions should favor compliance over ergonomics
```

**作用域**：偏向团队（strongly bias toward team）。项目动态通常对所有贡献者有价值。

### 4. reference — 外部系统指针

**核心问题**：去哪里找外部信息？

**为什么推导不出来**：外部系统的指针不在项目目录里。

**典型内容**：
- "pipeline bugs 在 Linear 的 INGEST 项目"
- "grafana.internal/d/api-latency 是 oncall 监控板"
- "反馈在 Slack #feedback 频道"

**作用域**：通常团队。外部资源对所有人有用。

---

## 不存什么？——反面清单

源码 `memoryTypes.ts:183-195`：

```typescript
export const WHAT_NOT_TO_SAVE_SECTION = [
  '## What NOT to save in memory',
  '',
  '- Code patterns, conventions, architecture, file paths, or project structure — these can be derived by reading the current project state.',
  '- Git history, recent changes, or who-changed-what — `git log` / `git blame` are authoritative.',
  '- Debugging solutions or fix recipes — the fix is in the code; the commit message has the context.',
  '- Anything already documented in CLAUDE.md files.',
  '- Ephemeral task details: in-progress work, temporary state, current conversation context.',
  '',
  'These exclusions apply even when the user explicitly asks you to save.',
]
```

### 为什么排除这些？

| 排除项 | 原因 | 替代方案 |
|--------|------|----------|
| 代码模式/架构 | 能从项目状态推导 | 读文件、grep |
| Git 历史 | git log/blame 更权威 | 直接查 git |
| 调试方案 | 修复在代码里，上下文在 commit message | 读代码 + commit |
| CLAUDE.md 已有内容 | 不该有两份真相来源 | 读 CLAUDE.md |
| 短期任务细节 | 过期快，噪音大 | Task 系统 |

### "即使用户明确要求也不存"

最后一句是最精妙的设计：

> These exclusions apply even when the user explicitly asks you to save. If they ask you to save a PR list or activity summary, ask what was *surprising* or *non-obvious* about it — that is the part worth keeping.

用户说"帮我记住这周的 PR 列表"→ 不该存整个列表（快照，几天就过期）。应该反问"有什么惊喜或意外的吗？" → 只存惊喜部分。

这条规则是 eval-validated 的：之前没有时，用户说"save this week's PR list"，Claude 就存了 → 产生大量 activity-log 噪音。

---

## 做 Agent 时如何借鉴

1. **定义记忆类型的判断标准**：不是"什么信息重要"，而是"什么信息推导不出来"
2. **feedback 类型必须记 Why**：没有 Why 就无法判断边界情况
3. **project 类型必须转绝对日期**：相对日期是定时炸弹
4. **必须有反面清单**：覆盖"用户明确要求但不该存"的场景
5. **同时记纠正和确认**：只记"不要做什么"会让 Agent 越来越保守

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
- [[concepts/agent-memory|Agent 记忆机制（论文综述）]]
