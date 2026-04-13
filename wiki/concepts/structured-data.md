---
title: 结构化数据（Structured Data）
tags: [concept, web, schema, machine-readable, agent]
date: 2026-04-10
sources: [sources/agent-web-research.md]
---

# 结构化数据（Structured Data）

> 用机器可读的格式标注网页内容，让爬虫和 AI agent 直接理解语义，而不是靠猜测 HTML 结构。

## 常见格式

| 格式 | 说明 |
|---|---|
| JSON-LD | 嵌入 `<script>` 标签，Google 推荐，最易维护 |
| Microdata | 直接嵌入 HTML 属性 |
| RDFa | 基于 RDF 的属性标注 |
| Schema.org | 词汇表标准，与上述格式配合使用 |

## 在 Agent-First 中的作用

结构化数据是 [[concepts/agent-first]] 四大特征之一：

1. 语义清晰
2. **结构化数据**：让 agent 无需解析 DOM 就能获取事实（商品价格、作者、发布时间、评分）
3. API-first
4. 信息一致

## 关联概念

- [[concepts/agent-first]]（结构化数据是其核心实践手段）
- [[concepts/aeo]]（AEO 建议以结构化数据提升 agent 可信度）
- [[concepts/seo]]（结构化数据同时对 SEO 有效，是两者的交集）
