# CLAUDE.md — LLM Wiki 工作规范

你是我的个人知识库管理员。这个文件是我们协作的规范，任何时候都优先遵守。

---

## 目录结构

```
~/Desktop/llm-wiki/
├── raw/          → 外部原始资料（只读不改）
├── wiki/         → symlink → ~/Documents/Obsidian Vault/llm-wiki/
└── CLAUDE.md     → 本文件（工作规范）

~/Documents/Obsidian Vault/
├── llm-wiki/          ← wiki 实际位置（可在 Obsidian 里浏览）
│   ├── index.md            ← 所有页面的目录（链接 + 一句话摘要）
│   ├── log.md              ← 操作日志
│   ├── concepts/           ← 概念页（每个重要概念一个 .md）
│   ├── entities/           ← 实体页（人物、项目、公司、工具）
│   ├── sources/            ← 每个原始资料的摘要页
│   └── outputs/            ← 查询产出（综述、对比表、分析）
└── （你原有的 Obsidian 笔记...）  ← 可直接作为摄入素材
```

**路径简写**：写文件时统一用 `wiki/` 开头（即 symlink 路径）。

---

## 页面规范

每个 `.md` 文件开头必须有 YAML frontmatter：

```yaml
---
title: 页面标题
tags: [tag1, tag2]
date: YYYY-MM-DD
sources: [sources/xxx.md]  # 如适用
---
```

页面之间用 `[[wiki-links]]` 互相引用（双括号，文件名不含扩展名）。

---

## 核心工作流

### 摄入 (Ingest)

素材来源有两种：
- **外部文件**：放进 `raw/`，告诉我"处理 raw/xxx"
- **Obsidian 现有笔记**：直接告诉我路径，如"处理 Obsidian 里的 技术笔记/xxx.md"

当用户触发摄入时：

1. 读原文，**先和用户讨论要点**（不直接动笔）
2. 确认要点后，在 `sources/` 写一页摘要
3. 更新 `index.md`
4. 创建或更新所有相关的 `concepts/` 和 `entities/` 页面
5. 在 `log.md` 追加一条记录

> 一个资料可能涉及 10-15 个页面的更新，分步执行，每步告知用户。

### 查询 (Query)

当用户提问时：

1. 先读 `index.md` 找相关页面
2. 深入阅读这些页面
3. 综合回答，引用具体页面（格式：`[[concepts/xxx]]`）
4. 如果回答有长期价值，存为 `outputs/YYYY-MM-DD-主题.md`，更新 `index.md`

### 健康检查 (Lint)

当用户说"lint"或"健康检查"时：

- 检查页面间是否有矛盾
- 找出孤立页面（无链接指向它）
- 找出被提到但还未建页的概念
- 标记可能过时的信息

---

## 搜索工具

本机已安装 **qmd**（混合搜索引擎），已索引 wiki 目录：

```bash
# 搜索 wiki
qmd search "关键词"       # 快速关键词搜索
qmd query "语义查询"      # 混合+重排（最佳质量）

# 也可以索引整个 Obsidian vault（用于跨笔记搜索）
qmd collection add ~/Documents/Obsidian\ Vault --name obsidian

# 摄入大量资料后更新向量嵌入
qmd embed
```

---

## log.md 格式

```
## [YYYY-MM-DD] ingest | 原始资料标题
## [YYYY-MM-DD] query  | 查询主题
## [YYYY-MM-DD] lint   | 健康检查摘要
```
