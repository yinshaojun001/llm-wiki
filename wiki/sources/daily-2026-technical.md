---
title: "源：2026 技术日志精华"
tags: [source, daily, 2026, ai-workflow, java, agent]
date: 2026-04-09
sources: [daily/2026/]
---

# 源：2026 技术日志精华

**原始位置**：`Obsidian Vault/daily/2026/`
**覆盖范围**：2026-01 至 2026-04（约 55 篇）

---

## 核心发现

### 个人 AI 增强开发工作流（2026-03-03）

> 早上来了先让**龙虾**给我创建工作日报文件，然后用 **Claude Code CLI** 读取内网接口文档（利用自己写的 skills），用 **Codex** 查生产问题，发现是个 bug 让龙虾给我在云效上建技术改进，用 **Trae（Gemini）** 写代码，上线，再用 **Claude Code** 给我 code review，最后看一下 token 使用，一天花了 20 块钱 token，又是付费上班的一天。

这描述了一个完整的 AI 工具协作链路：任务创建 → 文档理解 → 问题排查 → 编码 → 上线 → 代码审查。"龙虾"为个人 AI 助手（可能是 [[entities/openclaw]] 实例的昵称）。

### 深度技术笔记

| 笔记 | 内容 |
|---|---|
| PI-MONO-GUIDE (×2) | [[entities/pi-mono]] 框架完整解析 |
| 20260407 | [[entities/memos]] × 技能市场集成架构 |
| 20260331 | [[concepts/java-copy]] 深拷贝/浅拷贝 + JdbcTemplate 相关 |
| 20260316 | AI Agent Memory 机制调研 |
| 20260325 | sandbox 调研 + 技能市场生态建设 |

### 当前工作背景（推断）

在某公司（疑似 58 系）内部 LBG 团队开发：
- **技能市场**（`lbg_scf_lbgagent`）：AI 技能的注册、发布、语义检索
- 正将 [[entities/memos]] 接入技能市场，替换 SQL LIKE 为向量语义检索
- 使用多 AI 工具（Claude Code、Codex、Trae）协同工作
