---
title: "源：AI 工具生态月报 2026-03"
tags: [source, ai-tools, monthly-radar, agent, 2026]
date: 2026-04-09
sources: [monthly-ai-radar/src/content/reports.ts, monthly-ai-radar/post-to-wechat/2026-04-03/]
---

# 源：AI 工具生态月报 2026-03

**覆盖周期**：2026-03-03 至 2026-03-30
**核心判断**：AI 工具正在从"功能竞赛"转向"[[concepts/trust-infrastructure|信任竞赛]]"

---

## 一句话总结

> 3 月最重要的变化不是谁又多了一个功能，而是谁开始承担"可交付、可追责、可观测"的产品责任。

---

## 5 个关键信号

1. **任务执行型 Agent 成主产品形态**：Plan Mode、Auto Mode、后台异步任务在一个月内从点状特性变成多家工具共同推进的默认能力
2. **MCP 从差异化变成准入门槛**：协议覆盖度高，但 OAuth、审批粒度、生命周期治理仍碎片化
3. **Rust 与高性能运行时迁移加速**：CLI 性能和内存安全从"优化项"变"基础项"
4. **[[concepts/agents-md]] 正在形成跨工具配置层**：项目级 AI 配置迁移性开始产生网络效应
5. **[[concepts/trust-infrastructure]] 开始决定采用速度**：权限边界、消费监控、异常回滚、跨会话状态恢复决定谁能进入生产

---

## 头部三强对比

| | [[entities/claude-code]] | OpenAI Codex | [[entities/gemini-cli]] |
|---|---|---|---|
| 优势 | 能力上限最高，生态最成熟 | 底层工程最激进（Rust重构） | ADK迁移后架构最模块化 |
| 风险 | Auto Mode 权限事故、幽灵限流危机 | 计费争议、社区外溢弱 | 后发，节奏稳但尚未登顶 |

---

## 3 月重要时间线

| 日期 | 事件 | 意义 |
|---|---|---|
| 03-03 | OpenAI Codex 子代理系统 GA | 多 Agent 编排进入生产视野 |
| 03-11 | Kimi Code Plan Mode + kimi vis | 国产工具在异步体验上首次差异化 |
| 03-15 | Gemini CLI 完成 ADK 架构迁移 | Google 追赶头部，社区贡献强度上升 |
| 03-27 | Claude Code Auto Mode 发布 | 自主执行具备产品级入口 |
| 03-28 | Claude Code 执行 `git reset --hard` Bug | 安全边界问题推到台前 |
| 03-29 | Claude Code Max 幽灵限流危机 | 计费透明度变成行业级议题 |

---

## 关联概念与实体

- [[concepts/trust-infrastructure]]
- [[concepts/agents-md]]
- [[concepts/mcp]]
- [[entities/claude-code]]、[[entities/gemini-cli]]、[[entities/openclaw]]
