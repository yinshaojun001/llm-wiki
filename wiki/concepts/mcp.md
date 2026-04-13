---
title: MCP（Model Context Protocol）
tags: [concept, protocol, agent, tool-calling, standard]
date: 2026-04-09
sources: [sources/monthly-ai-radar-2026-03.md]
---

# MCP

**Model Context Protocol**，模型上下文协议。

> MCP 已从差异化卖点变成准入门槛（2026-03）。

## 是什么

一个让 AI Agent 调用外部工具和服务的标准协议。Agent 通过 MCP Server 与外部系统（数据库、API、文件系统等）交互。

## 当前状态（2026-03）

- 协议覆盖度已经很高，主流 CLI 工具基本都支持
- 真正难的是**实现层和运维层**：OAuth 集成、审批粒度、服务生命周期治理仍碎片化
- 不能只当功能标签，需要作为独立的生态栏目跟踪

## 关联实体

- [[entities/claude-code]]（主要推动者之一）
- [[entities/qmd]]（可通过 MCP Server 暴露搜索能力）
- [[entities/next-ai-draw-io]]（支持 MCP 唤起服务生成架构图）
