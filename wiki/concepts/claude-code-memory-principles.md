---
title: Claude Code 记忆系统十大设计原则
tags: [claude-code, memory, agent, context-engineering, principles]
date: 2026-05-05
sources: [entities/claude-code]
---

# 十大设计原则

> 从 Claude Code 源码中提炼的记忆系统设计原则，可直接用于自建 Agent。

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 原则一：只记推导不出来的东西

**源码**：`memoryTypes.ts:5-12`

> Memories are constrained to four types capturing context NOT derivable from the current project state.

**判断标准**：这个信息能不能通过工具调用（grep、git log、读文件）推导出来？能就不记。

**四种类型**：
- `user`：用户是谁（推导不出来）
- `feedback`：用户喜欢/讨厌什么（推导不出来）
- `project`：正在发生什么（git 里没有）
- `reference`：去哪里找外部信息（项目目录里没有）

详见 [[concepts/claude-code-memory-taxonomy|四种记忆类型]]。

---

## 原则二：有明确的"不存什么"清单

**源码**：`memoryTypes.ts:183-195`

> These exclusions apply even when the user explicitly asks you to save.

**排除项**：代码模式、git 历史、调试方案、CLAUDE.md 已有内容、短期任务细节。

**关键**：即使用户明确要求也不存。用户说"记住这周的 PR 列表"→ 反问"有什么惊喜的？"→ 只存惊喜部分。

没有反面清单，记忆系统会变成垃圾桶。

详见 [[concepts/claude-code-memory-taxonomy|四种记忆类型]] 中的"不存什么"。

---

## 原则三：索引常驻 context，内容按需加载

**源码**：`memdir.ts:34-38`

```
MEMORY.md（索引，200 行上限）  ← 常驻 system prompt
├── feedback_code_style.md     ← 按需加载
├── ref_pipeline_bugs.md       ← 按需加载
└── user_role.md               ← 按需加载
```

**解决的矛盾**：记忆越多 → context 越满 → 工作空间越小。

**铁律**：Never write memory content directly into MEMORY.md.

详见 [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]。

---

## 原则四：前台写入和后台提取互斥

**源码**：`extractMemories.ts:121-148`

```typescript
if (hasMemoryWritesSince(messages, lastMemoryMessageUuid)) {
  // 主 Agent 已经写了 → 跳过后台提取
  return
}
```

**一个 turn 只有一个写入者**。否则两个 Agent 同时写同一个文件 → 冲突。

详见 [[concepts/claude-code-memory-write-paths|三条写入路径]]。

---

## 原则五：后台 Agent 必须有权限沙箱

**源码**：`extractMemories.ts:171-222`

```
✅ 读任意文件（Read/Grep/Glob）
✅ 只读 shell 命令
✅ 写记忆目录
❌ 写项目代码
❌ 写命令（rm, mv）
❌ MCP 工具
❌ Agent 工具
```

即使提取 Agent 被 prompt injection 攻击，它也没有能力修改项目代码。

详见 [[concepts/claude-code-memory-write-paths|三条写入路径]]。

---

## 原则六：用 LLM 做语义路由

**源码**：`findRelevantMemories.ts:18-24`

传统做法：向量相似度搜索。
Claude Code 做法：用 Sonnet 选哪些记忆对当前查询有用。

**优势**：LLM 能理解推理链（"用户在调试数据库 → 需要数据库 mock 的教训"），向量搜索只能做语义匹配。

**工具感知**：传入"最近使用的工具"，避免选已经在用的工具文档，但保留其警告。

详见 [[concepts/claude-code-memory-recall|LLM 语义路由]]。

---

## 原则七：不自动清理，用年龄标签让 LLM 自判

**源码**：`memoryAge.ts:33-42`

```typescript
if (d <= 1) return ''  // ≤1 天不警告
return `This memory is ${d} days old. Memories are point-in-time observations, not live state...`
```

**为什么不用 TTL**：过期 ≠ 无用。30 天前的 feedback 仍然有效，2 天前的 project 可能已过期。

**策略**：给记忆加年龄标签，让 LLM 自己判断。发现过期 → 更新/删除 → 正向循环。

详见 [[concepts/claude-code-memory-staleness|过期管理]]。

---

## 原则八：记忆行为指令覆盖完整生命周期

**源码**：`memdir.ts:199-266`

```
存什么     → 四种类型定义
不存什么   → 反面清单
怎么存     → 两步法（写文件 + 加索引）
什么时候读 → 三种触发条件
怎么信任   → 验证清单
和其他机制 → Memory vs Plan vs Task
```

每一条都要写清楚，否则 LLM 会做出你意想不到的事。

详见 [[concepts/claude-code-memory-system-prompt|记忆行为指令]]。

---

## 原则九：长对话需要会话内压缩缓冲

**源码**：`SessionMemory/`

Session Memory 是压缩时的安全网：
- 结构化模板（Title/State/Files/Errors/Learnings）
- 阈值触发（≥10K tokens 首次，≥5K tokens 后续）
- 压缩时注入 post-compact context

没有它，压缩会丢失关键上下文。

详见 [[concepts/claude-code-memory-session|Session Memory 与 Auto-dream]]。

---

## 原则十：长期运行用日志+定期整合

**源码**：`memdir.ts:327-370`

Assistant 模式下的记忆策略：
- 新记忆 append-only 写入日志
- 不实时维护 MEMORY.md
- nightly 进程整合日志 → 主题文件 + 索引

类比人类记忆：白天经历 → 短期记忆，晚上睡眠 → 整合到长期记忆。

详见 [[concepts/claude-code-memory-session|Session Memory 与 Auto-dream]]。

---

## 原则速查表

| # | 原则 | 一句话 | 源码位置 |
|---|------|--------|----------|
| 1 | 只记推导不出来的 | grep/git/读文件能获取的都不记 | `memoryTypes.ts:5-12` |
| 2 | 有反面清单 | 用户要求也不存的边界 | `memoryTypes.ts:183-195` |
| 3 | 索引-内容分离 | MEMORY.md 是目录不是内容 | `memdir.ts:34-38` |
| 4 | 写入互斥 | 一个 turn 一个写入者 | `extractMemories.ts:121-148` |
| 5 | 权限沙箱 | 后台 Agent 只能写记忆目录 | `extractMemories.ts:171-222` |
| 6 | LLM 语义路由 | 用小模型选记忆而非向量搜索 | `findRelevantMemories.ts:18-24` |
| 7 | 年龄标签 | 不删记忆，让 LLM 自判过期 | `memoryAge.ts:33-42` |
| 8 | 完整生命周期指令 | 存/不存/怎么存/何时读/怎么信 | `memdir.ts:199-266` |
| 9 | 会话内压缩缓冲 | Session Memory 防压缩丢信息 | `SessionMemory/` |
| 10 | 日志+定期整合 | 长期运行用 append-only 日志 | `memdir.ts:327-370` |

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/agent-memory|Agent 记忆机制（论文综述）]]
- [[concepts/agent-prompt-principles|Agent Prompt 设计原则]]
- [[concepts/skills-architecture|Skills 架构]]
- [[concepts/managed-agents|Managed Agents]]
