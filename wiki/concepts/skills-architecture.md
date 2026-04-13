---
title: Skills 系统架构（元工具模式）
tags: [concept, agent, skills, architecture, meta-tool, context-engineering]
date: 2026-04-09
sources: [sources/ai-research-2.md]
---

# Skills 系统架构（元工具模式）

> Skills 不是简单的插件系统，而是针对大模型上下文工程深度优化的能力扩展框架。

## 核心约束

- **上下文窗口有限**：每个 skill 含数 KB 文档和数十 KB 脚本，全量加载不可行
- **工具列表爆炸**：工具越多，模型选准确率越低，描述本身消耗大量 token

**核心思路**：按需加载、分级披露、代码不进上下文。

## 元工具模式（Meta-Tool Pattern）

LLM 只需知道一个统一入口，不感知底层实现细节：

```typescript
// 暴露给 LLM 的唯一工具
use_skill(
  skill_name: string,  // "baidu-web-search"
  action: string,      // "search" | "list_actions"
  params: object       // skill 专属参数
)
```

框架负责路由和加载，避免工具列表膨胀。

## 技能发现策略

| 规模 | 策略 |
|---|---|
| < 30 个技能 | 静态注入 system prompt（名称 + 一句话摘要） |
| > 30 个技能 | 动态查询：LLM 先调 `list_skills(query)` 语义搜索 |

## 三级加载（渐进式披露）

1. **发现层**：技能名 + 摘要（最小 token）
2. **接口层**：参数定义（按需加载）
3. **实现层**：脚本代码（不进上下文，运行时执行）

## 关联

- [[entities/memos]]（技能市场用语义检索实现动态发现）
- [[concepts/mcp]]（MCP 是工具协议，Skills 是更高层的能力框架）
- [[entities/openclaw]]（OpenClaw 的 Skills 系统遵循此架构）
