---
title: Claude Code 记忆系统——源码级架构分析
tags: [claude-code, memory, agent, context-engineering, architecture]
date: 2026-05-05
sources: [entities/claude-code]
---
# Claude Code 记忆系统

> 基于 claude-code 源码（`src/memdir/`、`src/services/extractMemories/`、`src/services/SessionMemory/`、`src/services/autoDream/`）的完整架构分析。
> 逐行源码级拆解，面向自建 Agent 的设计借鉴。

---

## 一句话总结

Claude Code 的记忆系统是一个**分层、分角色、有生命周期的上下文管理架构**，核心哲学是：文件即记忆、索引与内容分离、LLM 自治管理。

---

## 五层架构全景

```
┌──────────────────────────────────────────────────────┐
│  Layer 1: Auto Memory（跨会话持久记忆）               │
│  ~/.claude/projects/<project>/memory/                │
│  ├── MEMORY.md          ← 索引，常驻 system prompt   │
│  └── *.md               ← 主题文件，按需召回          │
├──────────────────────────────────────────────────────┤
│  Layer 2: Session Memory（会话内记忆）                │
│  ~/.claude/session-memory/<session-id>.md            │
│  结构化模板：Title/State/Files/Errors/Learnings...   │
├──────────────────────────────────────────────────────┤
│  Layer 3: Agent Memory（Agent 类型专属记忆）          │
│  user/project/local 三作用域                         │
├──────────────────────────────────────────────────────┤
│  Layer 4: Team Memory（团队共享记忆）                 │
│  REST API 同步，OAuth 认证，ETag 冲突解决             │
├──────────────────────────────────────────────────────┤
│  Layer 5: CLAUDE.md（传统指令文件）                   │
│  Managed → User → Project → Local 四级               │
└──────────────────────────────────────────────────────┘
```

---

## 分章详解

### 设计哲学

- [[concepts/claude-code-memory-principles|十大设计原则]] — 从源码提炼的 10 条可复用原则，含速查表

### 核心机制

- [[concepts/claude-code-memory-taxonomy|四种记忆类型与"不存什么"]] — 只记推导不出来的东西，四类型分类法，反面清单
- [[concepts/claude-code-memory-index-content-separation|索引-内容分离]] — MEMORY.md 的架构哲学，200 行硬上限，两步写入法
- [[concepts/claude-code-memory-write-paths|三条写入路径]] — 前台写入、后台提取 Agent、Auto-dream，互斥机制与权限沙箱
- [[concepts/claude-code-memory-recall|LLM 语义路由]] — 用 Sonnet 选记忆而非向量搜索，工具感知，去重，失败降级
- [[concepts/claude-code-memory-staleness|过期管理]] — 不删记忆但提醒可能过期，年龄标签，验证清单

### 进阶话题

- [[concepts/claude-code-memory-session|Session Memory 与 Auto-dream]] — 会话内压缩缓冲，日志+定期整合
- [[concepts/claude-code-memory-system-prompt|记忆行为指令]] — system prompt 如何驱动记忆系统，eval 验证

---

## 关键源码文件

| 文件 | 职责 |
|------|------|
| `src/memdir/memdir.ts` | 核心：MEMORY.md 处理、system prompt 构建、入口截断 |
| `src/memdir/memoryTypes.ts` | 四类型分类法、frontmatter 格式、行为指令模板 |
| `src/memdir/paths.ts` | 路径解析、sanitizePath、enable/disable 开关 |
| `src/memdir/memoryScan.ts` | 目录扫描、frontmatter 解析、manifest 格式化 |
| `src/memdir/findRelevantMemories.ts` | LLM 驱动的相关记忆选择（Sonnet sideQuery） |
| `src/memdir/memoryAge.ts` | 时间衰减计算、过期警告文本生成 |
| `src/memdir/teamMemPaths.ts` | 团队记忆路径、路径遍历安全防护 |
| `src/memdir/teamMemPrompts.ts` | 私有+团队记忆合并 prompt |
| `src/services/extractMemories/extractMemories.ts` | 后台记忆提取 Agent |
| `src/services/extractMemories/prompts.ts` | 提取 Agent 的 prompt 模板 |
| `src/services/SessionMemory/sessionMemory.ts` | 会话记忆提取 hook |
| `src/services/SessionMemory/sessionMemoryUtils.ts` | 会话记忆阈值配置 |
| `src/services/SessionMemory/prompts.ts` | 会话记忆模板和更新 prompt |
| `src/services/autoDream/autoDream.ts` | 记忆整合（auto-dream）后台进程 |
| `src/services/teamMemorySync/index.ts` | 团队记忆 pull/push/sync |
| `src/services/teamMemorySync/secretScanner.ts` | 密钥检测（gitleaks 正则） |
| `src/tools/AgentTool/agentMemory.ts` | Agent 专属记忆（user/project/local 三作用域） |
| `src/utils/claudemd.ts` | CLAUDE.md 加载、@include 解析、记忆文件组装 |
| `src/utils/attachments.ts` | 记忆预取和附件注入 |

---

## 与其他方案对比

| 维度   | Claude Code       | [[concepts/agent-memory\|论文综述方案]] | [[entities/memos\|MemOS]] |
| ---- | ----------------- | --------------------------------- | ------------------------- |
| 存储   | 文件系统（.md）         | 通常数据库/向量库                         | 向量语义检索                    |
| 索引   | MEMORY.md 目录      | 无统一标准                             | 向量嵌入                      |
| 召回   | LLM 选 LLM（Sonnet） | 向量相似度 / 关键词                       | 语义检索                      |
| 过期   | LLM 自觉 + 时间警告     | 通常无机制                             | 无明确机制                     |
| 团队共享 | REST API 同步       | 通常不支持                             | 支持                        |
| 可读性  | 人类可读 .md 文件       | 通常不可读                             | API 抽象                    |

Claude Code 的方案**最轻量、最人类可读**，但依赖 LLM 的自觉性（没有强制去重/清理）。适合 CLI 工具的"小而精"场景。
