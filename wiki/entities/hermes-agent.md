---
title: Hermes Agent
tags: [entity, tool, agent, self-improving, nous-research, open-source]
date: 2026-04-12
sources: [sources/hermes-agent.md]
---

# Hermes Agent

**类型**：自我改进型开源 AI Agent 框架  
**作者**：Nous Research  
**版本**：v0.7.0（2026-04-03）  
**License**：MIT  
**仓库**：https://github.com/NousResearch/hermes-agent

> The agent that grows with you.

---

## 核心价值

| 能力 | 说明 |
|------|------|
| **学习循环** | 每次完成复杂任务后自动创建/精炼 Skill |
| **持久记忆** | 三层记忆（短期/情节/过程）跨会话连续 |
| **多端接入** | CLI + Telegram/Discord/Slack/WhatsApp/Signal |
| **灵活部署** | Local → Docker → SSH → Serverless (Modal) |
| **模型无关** | 400+ 模型，任意 OpenAI 兼容端点 |

---

## 与 OpenClaw 核心差异

| 维度 | Hermes Agent | [[entities/openclaw\|OpenClaw]] |
|------|-------------|---------|
| 语言栈 | Python | Node.js |
| 自我改进 | ✅ 内建 Skill 学习循环 | ❌ 无 |
| 记忆架构 | 3 层（短期/情节/过程） | Session-based SQLite |
| 模型数量 | 400+ | 包装 Claude/Gemini/GPT |
| Token 效率 | 高（Skill 复用减少重复推理） | 标准 |
| 生态成熟度 | 成长期（33k stars） | 成熟（247k stars） |
| 迁移支持 | 可从 OpenClaw 一键导入 | — |
| ACP 支持 | ❌（原生子代理） | ✅ |

---

## 技术特征

- **Observe → Plan → Act → Learn** 四步循环
- FTS5 全文检索 + LLM summarization（情节记忆）
- Honcho 用户建模（跨会话个性化）
- 40+ 内置工具
- MCP 集成
- Cron 自然语言定时任务
- 子代理并发委派
- DSPy + GEPA 自进化扩展（独立仓库，ICLR 2026）

---

## 关联概念

- [[concepts/skills-architecture]]（Hermes Skill 系统是 元工具模式 的工程实现）
- [[concepts/agent-memory]]（三层记忆与四层架构对应）
- [[concepts/mcp]]（MCP 服务器集成）
- [[entities/openclaw]]（竞品 / 迁移来源）
