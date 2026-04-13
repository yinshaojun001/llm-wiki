---
title: AI Agent 记忆机制
tags: [concept, agent, memory, vector-search, long-term-memory]
date: 2026-04-09
sources: [sources/research-overview.md]
---

# AI Agent 记忆机制

> 调研时间：2026-03-16

## 记忆类型分类

### 按时间跨度

| 类型 | 对应实现 |
|---|---|
| 短期记忆 | LLM context window、对话历史 |
| 工作记忆 | System prompt scratchpad、active context |
| 长期记忆 | 向量数据库、知识图谱、关系型数据库 |

### 按内容性质

| 类型 | 说明 | 实现 |
|---|---|---|
| 情景记忆 | 具体事件/经历，带时间戳 | 对话日志、交互轨迹 |
| 语义记忆 | 抽象知识、事实、概念 | 知识图谱节点、蒸馏后的知识条目 |
| 程序记忆 | 如何做事的技能/流程 | 工具调用模式、ReAct 轨迹、skills |

## 前沿四层架构（2025-2026）

```
L1 Active Context    → 当前 prompt 中的活跃信息
L2 Working Memory    → 提取的重要事实
L3 Episodic Memory   → 经历和交互历史
L4 Semantic Memory   → 蒸馏后的长期知识
```

核心机制：**编码 → 存储 → 检索 → 管理/遗忘**

## 重要论文

| 论文 | 核心贡献 |
|---|---|
| Generative Agents (Park et al., 2023) | 开山之作：记忆流 + 反思 + 规划 |
| MemGPT (Packer et al., 2023) | 虚拟内存管理：OS 分页思想用于 LLM 上下文 |
| Zep (2025) | 时序知识图谱，事实有效期窗口 |
| Mem0 (2025) | 生产级记忆层，+26% accuracy vs OpenAI Memory |
| Hindsight (2025) | 四层记忆网络，LongMemEval 91.4% |

## 关联实体

- [[entities/memos]]（MemOS 是记忆机制的具体实现平台）
- [[entities/openclaw]]（OpenClaw 内置 Markdown + SQLite 记忆系统）
- [[entities/qmd]]（qmd 可作为 OpenClaw 的长期记忆检索后端）
