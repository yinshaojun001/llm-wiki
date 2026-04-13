---
title: ACP（Agent Communication Protocol）
tags: [concept, protocol, agent, multi-agent, openclaw]
date: 2026-04-09
sources: [sources/ai-research-2.md]
---

# ACP（Agent Communication Protocol）

> ACP 管理 Agent 运行时，[[concepts/mcp]] 管理工具/上下文。

## 定义

ACP 是一个 Agent 客户端（如 [[entities/openclaw]]）调度和管理多个 Agent 运行时的标准接口。

**不是** Agent 之间直接对话，**而是** 统一调度 Claude Code、Codex、Gemini CLI、Pi 等外部编码 Agent。

## 核心架构

```
ACP 客户端（OpenClaw）
       ↓
ACP Backend（acpx 插件）
       ↓
Agent 运行时（Claude Code / Codex / Gemini / Pi / Kimi）
```

## 与 MCP 的区别

| 维度 | MCP | ACP |
|---|---|---|
| 管理对象 | 工具（Tools）、上下文（Context） | Agent 运行时（Runtime） |
| 解决问题 | LLM 如何调用外部工具 | 如何调度和管理多个 Agent |
| 典型场景 | 调用数据库、搜索引擎 | 启动 Codex 写代码、用 Claude Code 做 review |

## 与 Sub-Agent 的区别

| | ACP Session | Sub-Agent |
|---|---|---|
| 适用场景 | 需要外部编码工具运行时 | OpenClaw 原生委托任务 |
| 沙盒支持 | 仅宿主机 | 支持沙盒 |

## 关联

- [[entities/openclaw]]（ACP 的调度方）
- [[concepts/mcp]]（同层协议，解决不同问题）
