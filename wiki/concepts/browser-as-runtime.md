---
title: Browser as Runtime
tags: [concept, browser, runtime, agent, ai]
date: 2026-04-09
sources: [sources/agent-web-research.md]
---

# Browser as Runtime

> 浏览器不只是页面展示容器，也可以成为 AI agent 的运行环境。

## 为什么浏览器适合作为 Agent 运行时

- **交互能力成熟**：鼠标、键盘、表单、DOM 操作
- **安全模型成熟**：沙箱、跨域、权限管理
- **跨平台**：无需安装，随处可用
- **分发成本低**：URL 即入口

## 核心观点

浏览器不仅能"显示 agent 的结果"，还能"承载 agent 的行为"。

这是 [[concepts/agentic-web]] 的基础设施前提——当 agent 需要原生参与 Web，浏览器是最自然的宿主环境。

## 关联

- [[concepts/agentic-web]]（Browser as Runtime 是其基础设施层）
- [[entities/openclaw]]（OpenClaw 的 ACP Agent 支持通过浏览器运行的 Claude Code）
