---
title: QMD（Query Markup Documents）
tags: [entity, tool, search, local, markdown]
date: 2026-04-09
sources: []
---

# QMD

**类型**：本地文档搜索引擎
**作者**：Tobias Lütke（Shopify CEO）
**仓库**：`tobi/qmd`
**安装**：`npm install -g @tobilu/qmd`（本机已安装 v2.1.0）

> 为 agent 记忆系统设计的本地混合搜索引擎。

## 三层搜索

1. **BM25**：精确关键词匹配（快）
2. **向量搜索**：语义相似性（需 embed）
3. **LLM 重排**：排序优化（最佳质量）

## 本机配置

```bash
# 已索引的 collection
qmd://wiki/       → llm-wiki 知识库
qmd://obsidian/   → 完整 Obsidian vault（320 篇）
```

## 常用命令

```bash
qmd search "关键词"    # 快速关键词
qmd query "语义查询"   # 混合+重排
qmd embed              # 更新向量嵌入
qmd status             # 查看状态
```

## 关联实体

- [[entities/openclaw]]（OpenClaw 的可选记忆搜索后端）
