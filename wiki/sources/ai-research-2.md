---
title: "源：AI研究research 技术调研集"
tags: [source, ai-research, java, agent, protocol, skills]
date: 2026-04-09
sources: [AI研究research/]
---

# 源：AI研究research 技术调研集

**原始位置**：`Obsidian Vault/AI研究research/`（16 篇）
**主要方向**：Java LLM 框架、Agent 协议、Skills 架构、多 Agent 设计

---

## 核心内容

### 1. [[concepts/acp]] — ACP 协议深度解析（2026-03-10）
OpenClaw 调度外部编码 Agent 的标准协议，与 MCP 互补（MCP 管工具，ACP 管运行时）

### 2. [[concepts/skills-architecture]] — Skills 系统架构设计
元工具模式（Meta-Tool Pattern）+ 三级渐进式披露，解决工具列表爆炸和上下文浪费问题

### 3. Java LLM 框架梯队（2026-03）

| 梯队 | 框架 | 特点 |
|---|---|---|
| 第一梯队 | **LangChain4j**（11.1k⭐）| 生态最完善，Spring Boot 友好 |
| 第一梯队 | **BAML**（7.7k⭐）| 类型安全，多语言统一 Prompt |
| 第一梯队 | **Koog**（3.8k⭐）| JetBrains 出品，JVM 原生高性能 |
| 第二梯队 | Agents-Flex（1.3k⭐）| 轻量，中文文档，快速原型 |
| 第二梯队 | Spring AI | Spring 生态官方集成 |

### 4. 多 Agent 技术调研
多 Agent 编排、子代理系统设计完整文档
