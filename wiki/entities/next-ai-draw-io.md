---
title: next-ai-draw-io
tags: [entity, tool, ai, diagram, drawio, opensource]
date: 2026-04-09
sources: [sources/58-experience.md]
---

# next-ai-draw-io

**类型**：开源 AI 图表生成工具
**仓库**：`DayuanJiang/next-ai-draw-io`（~18k stars）
**技术栈**：Next.js + React + Vercel AI SDK + draw.io XML

> AI 驱动的图表创建工具：自然语言 → 可编辑的 draw.io 图表。

## 核心能力

- 自然语言生成流程图、架构图、UML
- AI + 手工**混合编辑**（生成后仍可手动调整）
- AI 修改现有图表（精确改动，不重画）
- 上传图片/PDF 自动重建图表
- 支持云架构图（AWS/GCP/Azure）
- MCP Server（实验性）——可通过 Agent 自动化绘图

## 多模型支持

Claude Sonnet、GPT、Gemini、DeepSeek 等，通过 Vercel AI SDK 抽象。

## 为什么值得关注

**区别于同类工具的关键**：生成的是真正可编辑的 draw.io XML 结构，而不是静态图片。AI 能理解现有图表并做局部修改。

## 关联概念

- [[concepts/agentic-web]]（MCP 支持使其成为 agent 可调用的工具）
