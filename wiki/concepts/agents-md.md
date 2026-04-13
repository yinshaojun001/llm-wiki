---
title: AGENTS.md
tags: [concept, agent, configuration, standard, portability]
date: 2026-04-09
sources: [sources/monthly-ai-radar-2026-03.md]
---

# AGENTS.md

> 项目级 AI 配置文件，正在形成跨工具的事实标准。

## 定义

AGENTS.md 是放在项目根目录的配置文件，描述 AI agent 在这个项目中的工作规范、工具权限、行为边界。

## 意义

- **可迁移性**：同一份配置可以在不同 CLI 工具（Claude Code、Codex、Gemini CLI）间复用
- **网络效应**：越多工具支持，迁移成本越低，标准越容易固化
- **标准化竞争**：谁先推动 AGENTS.md 成为事实标准，谁就更难被替代

## 当前状态（2026-03）

Anthropic 通过 Claude Code 在推动 AGENTS.md 的标准化，其他工具正在跟进支持。

> 一旦项目级 AI 配置真正具备迁移性，竞争焦点就会从"工具绑定"转向"执行质量"。

## 关联

- [[entities/claude-code]]（主要推动者）
- [[concepts/trust-infrastructure]]（配置标准化是信任基础设施的组成部分）
