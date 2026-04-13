---
title: OpenClaw
tags: [entity, tool, platform, agent, ai]
date: 2026-04-09
sources: [sources/openclaw-architecture.md]
---

# OpenClaw

**类型**：个人 AI 助手平台 / Agent 操作系统
**定位**：运行在用户自有基础设施上（Mac、VPS、云容器等）

> AI 模型提供智能，OpenClaw 提供执行环境。

## 核心价值

解决直接调用 API 的五大痛点：

| 痛点 | 解决方案 |
|---|---|
| 上下文无法持久化 | Session 管理 + 自动 Compaction |
| 多平台接入困难 | 统一 Channel Adapter 层 |
| 工具调用不安全 | Docker 沙箱 + 分层权限 |
| 记忆不连续 | 向量搜索 + Markdown 文件 |
| 无法主动行动 | Cron 定时任务 + Webhook 触发 |

## 架构

- **Hub-and-Spoke**：Gateway 为控制中心
- **Channels**：飞书、WhatsApp、Telegram、Discord、Signal、iMessage
- **多智能体**：Sub-agent（原生）+ ACP Agent（Claude Code、Codex、Gemini CLI）
- **记忆后端**：SQLite + Markdown，可选接入 [[entities/qmd]]

## 多智能体层级

```
Main Agent (depth 0)
  └─→ Orchestrator (depth 1)
        ├─→ Worker (depth 2)
        └─→ Worker (depth 2)
```

- 默认最大嵌套深度 1，设为 2 开启编排模式
- 子代理默认无 session 管理权限（安全隔离）

## 技术栈

Node.js 22+、WebSocket、SQLite、Docker、TypeBox

## 关联概念

- [[concepts/agentic-web]]（OpenClaw 是 Agentic Web 的具体实践）
- [[entities/qmd]]（记忆搜索后端选项）
