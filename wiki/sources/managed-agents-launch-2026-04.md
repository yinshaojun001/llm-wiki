---
title: "源：Claude Managed Agents 产品发布公告（2026-04）"
tags: [source, anthropic, agent, managed-agents, product-launch, pricing, enterprise]
date: 2026-04-10
url: https://siliconangle.com/2026/04/08/anthropic-launches-claude-managed-agents-speed-ai-agent-development/
published: 2026-04-08
---

# 源：Claude Managed Agents 产品发布公告（2026-04）

**发布日期**：2026-04-08，公开测试（Public Beta）
**参考来源**：SiliconANGLE、The New Stack、The Decoder、官方文档

> 注：这是产品正式上线的发布公告摘要，工程架构细节见 [[sources/managed-agents]]。

---

## 核心定位

Claude Managed Agents 是 Anthropic 推出的"Agent 即服务"云端平台——一套可组合的 API，用于构建和部署云托管 Agent。开发者用自然语言或 YAML 文件定义 Agent（任务、工具、规则、guardrail），基础设施（沙箱、状态、权限、链路追踪）全由 Anthropic 托管。

官方宣传：**"从原型到上线，几天而不是几个月"**。

---

## 产品功能

| 功能 | 说明 |
|---|---|
| 沙箱执行 | 隔离代码执行环境 |
| 长时会话（Checkpoint） | 断线可从断点续跑，进度不丢 |
| 多 Agent 协调 | 一个 Agent 可调起其他 Agent 并行执行（研究预览阶段） |
| 凭证管理 | 统一管理 Agent 访问外部工具的权限 |
| 链路追踪 | 完整操作日志，便于调试 |

---

## Sessions API

```
POST /v1/sessions           → 创建 Agent 会话
GET  /v1/sessions/{id}/stream  → 流式获取结果（Server-Sent Events）
```

发送用户消息后，Claude 自主调用工具并流式返回结果，事件历史由服务端持久化，可随时全量获取。

---

## 定价

| 费用项 | 价格 |
|---|---|
| Token 消耗 | 按 Claude 标准 API 定价 |
| 会话运行时间 | **$0.08 / 活跃会话小时**（精确到毫秒） |
| 内置网页搜索 | **$10 / 1000 次** |

长任务场景下，会话时间费用可能比 token 费用更显著。

---

## 早期企业用例

| 公司 | 用法 |
|---|---|
| **Notion** | 用户直接在工作区丢任务给 Claude，写代码/做 PPT/做网页，几十个任务并行跑 |
| **Rakuten** | 产品、销售、营销、财务、HR 各条线部署专用 Agent，每个 Agent 一周内上线 |
| **Asana** | 加速 AI Teammates 功能开发 |
| **Sentry** | bug 诊断工具 Seer × Claude Agent，根因→补丁→PR 一条龙，几周内集成上线 |
| **Vibecode** | 默认集成，用户从 prompt 直接到部署完成的应用 |

---

## 竞争背景

Anthropic 正式入局"Agent 即服务"赛道，与 OpenAI 的 Codex 方向类似：

- **OpenAI Codex**：云端容器运行，各 Agent 独立并行
- **Claude Managed Agents**：多 Agent 协调模式下，主 Agent 分配任务给子 Agent 并追踪进度（更像"团队协作"）

两家的共同趋势：从"卖模型"→"卖完整开发平台"，通过降低基础设施门槛锁定开发者生态。

---

## 核实情况

- 发布日期、定价、功能列表：✅ 多家媒体交叉核实
- 企业用例（Notion/Rakuten/Asana）：✅ 已确认
- 成功率提升 10 个百分点：⚠️ 仅见于官方说法，无第三方验证
- Sentry/Vibecode：⚠️ 仅见于部分来源

---

## 涉及页面

- [[concepts/managed-agents]] — 完整架构 + 产品信息
- [[sources/managed-agents]] — 工程博客：Brain/Hands/Session 架构细节
- [[entities/claude-code]] — Harness 参考实现
