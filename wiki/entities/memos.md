---
title: MemOS（Memory OS）
tags: [entity, tool, memory, vector-search, agent]
date: 2026-04-09
sources: [sources/daily-2026-technical.md]
---

# MemOS

**类型**：Agent 记忆管理服务（向量数据库 + 语义检索）
**内部地址（sandbox）**：`http://10.186.15.3:8099`
**定位**：为 AI Agent 提供长期记忆的存储和语义召回能力

## 核心概念

| 概念 | 说明 |
|---|---|
| Memory Item | 一条记忆单元，含 content + info 元数据 |
| Cube | 数据隔离单元，类似命名空间 |
| memory_type | 记忆类型标签（如 `SkillMemory`） |

## 主要接口

```
POST /product/add    → 写入一条记忆
POST /product/search → 向量语义检索（top_k + 相似度阈值）
```

## 技能市场集成案例

用于将 SQL LIKE 关键词搜索升级为语义向量搜索：

| 维度 | 接入前 | 接入后 |
|---|---|---|
| 召回方式 | 精确关键词包含 | 语义向量相似度 |
| 搜"数据分析"能找到"报表生成"？ | 否 | 是 |
| 降级策略 | — | MemOS 超时 → 回退 MySQL LIKE |

**写入时机**：技能发布（`publishSkillVersion`）→ 异步写入 MemOS，不阻塞发布流程

## 关联

- [[entities/qmd]]（同为本地语义搜索，但 qmd 用于文档搜索，MemOS 用于 Agent 记忆管理）
- [[entities/openclaw]]（OpenClaw 的记忆系统可对接类似后端）
