---
title: Hermes Agent — NousResearch 深度调研
tags: [source, agent, self-improving, nous-research, open-source]
date: 2026-04-12
---

# Hermes Agent — NousResearch 深度调研

**原始资料**：https://github.com/NousResearch/hermes-agent  
**文档站**：https://hermes-agent.nousresearch.com/docs/  
**调研日期**：2026-04-12  
**当前版本**：v0.7.0 "The Resilience Release"（2026-04-03 发布）

---

## 项目背景

Nous Research 是一家专注于开源 LLM 研究的机构（以 Hermes 系列微调模型闻名）。Hermes Agent 于 **2026 年 2 月**发布，定位是"会自我成长的 Agent"，核心差异化是内建的学习循环（learning loop）。

截至 2026-04-12：
- GitHub Stars：33,000+
- Forks：4,200+
- License：MIT

---

## 核心定位

> "The only agent with a built-in learning loop — it creates skills from experience, improves them during use, nudges itself to persist knowledge, and builds a deepening model of who you are across sessions."

关键词：**自我改进**、**跨会话记忆**、**技能自动化**。

---

## 架构要点

### 学习循环（Learning Loop）

```
Observe → Plan → Act → Learn
```

每次完成复杂任务后，Hermes 自动：
1. 提取任务模式，生成 Skill 文档
2. 将 Skill 存入技能库
3. 下次遇到相似任务时直接引用（减少 token 消耗）
4. 技能随使用不断自我精炼

### 三层记忆架构

| 层次 | 内容 | 技术实现 |
|------|------|----------|
| 短期上下文 | 当前会话内容 | In-context window |
| 情节记忆（Episodic） | 历史会话摘要 | FTS5 全文检索 + LLM summarization |
| 过程记忆（Procedural） | 可复用 Skill 文档 | Markdown 文件 + 向量检索 |

另有 **Honcho 用户建模**：跨会话构建用户画像，个性化响应。

### 六种终端后端

| 后端 | 场景 |
|------|------|
| Local | 本机开发 |
| Docker | 隔离/沙箱执行 |
| SSH | 远程服务器 |
| Daytona | 云端开发环境 |
| Singularity | HPC / 高性能计算 |
| Modal | Serverless 弹性部署 |

### 消息渠道

- **CLI**：`hermes` 命令行交互
- **Messaging Gateway**：Telegram、Discord、Slack、WhatsApp、Signal

### LLM 支持

- Nous Portal（原生）
- OpenRouter（200+ 模型）
- OpenAI
- Anthropic
- 任何 OpenAI 兼容端点（合计 400+ 模型）

---

## 内置能力

- 40+ 内置工具（Web 搜索、浏览器自动化、文件操作、代码执行…）
- MCP（Model Context Protocol）服务器集成
- Cron 定时任务（自然语言规格）
- 子代理（Subagent）并发委派
- 语音交互
- 批量轨迹生成（用于 AI 研究）

---

## 技术栈

- **语言**：Python 94%（`uv` 管理依赖）+ Shell + Nix
- **测试**：pytest
- **扩展研究**：[hermes-agent-self-evolution](https://github.com/NousResearch/hermes-agent-self-evolution)（DSPy + GEPA，已在 ICLR 2026 发表）

---

## OpenClaw 迁移

Hermes 官方提供 **一键从 OpenClaw 迁移**功能：自动导入 settings、memories 和 skills。2026 年初出现明显的开发者迁移潮，主要驱动力是 Hermes 的自学习能力和 v0.7.0 稳定性改进。

---

## 相关页面

- [[entities/hermes-agent]]
- [[entities/openclaw]]
- [[concepts/agent-memory]]
- [[concepts/skills-architecture]]
- [[concepts/mcp]]
