---
title: pi-mono
tags: [entity, tool, framework, ai-agent, typescript, opensource]
date: 2026-04-09
sources: [sources/daily-2026-technical.md]
---

# pi-mono

**类型**：开源 AI Agent 工具套件
**作者**：Mario Zechner（badlogic）
**仓库**：`badlogic/pi-mono`
**核心理念**：极简内核 + 无限扩展，适应你的工作流，而不是强迫你适应它。

## 三层架构

```
pi-coding-agent     ← 终端 Coding Agent CLI / SDK（最上层）
      ↑
pi-agent-core       ← 有状态 Agent 运行时（工具调用循环 / 事件流 / 会话管理）
      ↑
pi-ai               ← 统一 LLM API（Anthropic / OpenAI / Google / Azure...）
```

**按需使用**：只需多供应商 LLM → 用 `pi-ai`；需要 Agent 运行时 → 用 `pi-agent-core`；需要完整 CLI → 用 `pi-coding-agent`。

## 核心扩展机制

| 类型 | 说明 |
|---|---|
| Extensions | TypeScript 扩展，注入工具/钩子 |
| Skills | Markdown 技能包，可分发 |
| Prompt Templates | 提示词模板 |
| Pi Packages | 可分发的完整包 |

## 解决的问题

直接调用 AI API 时，每个项目要手动处理：多轮对话历史维护、SSE 流式解析、工具调用循环、会话状态。pi-mono 把这些打包成标准运行时，开发者只需专注业务逻辑。

## 关联

- [[concepts/agentic-web]]（pi-mono 是构建 Agentic Web 应用的工具链之一）
- [[entities/openclaw]]（同为 Agent 运行时，但 OpenClaw 更偏个人助手，pi-mono 更偏开发框架）
