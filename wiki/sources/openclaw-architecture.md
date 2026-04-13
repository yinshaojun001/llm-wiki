---
title: "源：OpenClaw 架构深度研究"
tags: [source, openclaw, agent, architecture]
date: 2026-04-09
sources: [AI研究 research/OpenClaw架构研究文档.md, AI研究 research/OpenClaw 多智能体架构解析.md]
---

# 源：OpenClaw 架构深度研究

**原始位置**：`Obsidian Vault/AI研究 research/OpenClaw*.md`
**研究时间**：2025-07-17（v1.0）
**核心主题**：OpenClaw 作为个人 AI 助手平台的系统架构

---

## 核心结论

> AI 模型提供智能，OpenClaw 提供执行环境。

OpenClaw 是一个运行在用户自有基础设施上的 **AI Agent 操作系统**，将"会回复的聊天机器人"变成"能行动的 Agent"。

---

## 架构要点

- **Hub-and-Spoke**：单一 Gateway 为控制中心，所有 Channel（飞书/Telegram/Discord/WhatsApp 等）接入
- **多智能体**：Sub-agent（原生）+ ACP Agent（外接 Claude Code、Codex、Gemini CLI）
- **记忆系统**：Markdown 文件 + SQLite 向量索引（[[entities/qmd]] 作为可选后端）
- **沙箱**：Docker 容器隔离工具执行
- **存储**：SQLite（索引）+ JSON/JSONL（Session 状态）+ Markdown（记忆）

---

## 多智能体模型

```
Main Agent (depth 0)
  └──→ Orchestrator (depth 1) — 可再 spawn
         ├──→ Worker 1 (depth 2) — 叶子，不可再 spawn
         └──→ Worker 2 (depth 2)
```

- 默认 maxSpawnDepth: 1，设为 2 开启编排模式
- 子代理默认无 session 管理工具（安全隔离）
- 结果通过 `announce` 推回主会话（非阻塞）

---

## 关联概念

- [[concepts/agentic-web]]（OpenClaw 是 Agentic Web 的具体实践）
- [[entities/qmd]]（记忆搜索后端）
