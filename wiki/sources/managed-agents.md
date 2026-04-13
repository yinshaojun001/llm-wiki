---
title: "源：Anthropic Managed Agents 工程博客"
tags: [source, anthropic, agent, managed-agents, architecture, infrastructure]
date: 2026-04-09
url: https://www.anthropic.com/engineering/managed-agents
published: 2026-02-04
updated: 2026-04-08
authors: [Lance Martin, Gabe Cemaj, Michael Cohen]
---

# 源：Anthropic Managed Agents 工程博客

**原文**：[Scaling Managed Agents: Decoupling the Brain from the Hands](https://www.anthropic.com/engineering/managed-agents)
**发布**：2026-02-04，最后更新：2026-04-08

---

## 核心论点

Harness 本质上是在编码"Claude 目前还做不到什么"。随着模型迭代这些假设会过时，所以需要将 harness 与基础设施解耦，建立一套**接口能活过任何具体实现**的托管服务。

类比：操作系统通过虚拟化硬件（process、file）让几十年后的程序还能运行；Managed Agents 通过虚拟化 agent 组件，让未来还不存在的 harness 也能运行。

---

## 三个核心组件

| 组件 | 角色 | 关键特性 |
|---|---|---|
| **Session** | 持久事件日志 | append-only，存在所有组件之外 |
| **Harness（Brain）** | 调用 Claude 的循环 | 无状态，可通过 `wake(sessionId)` 恢复 |
| **Sandbox（Hands）** | 执行环境 | 通过 `execute(name, input) → string` 调用，可替换 |

---

## 关键设计决策

### 从单容器到解耦

原始设计将三个组件放在同一容器（"宠物"问题）：容器挂了 session 丢失，无法调试，无法接入客户 VPC。

解耦后容器变成"牛"：可按需 `provision()`，失败后直接换新。

### Session 作为外部上下文存储

通过 `getEvents()` 接口按需检索事件切片，避免了传统 context 压缩的不可逆问题。详见 [[concepts/agent-session]]。

### 安全边界

凭证永远不进入 sandbox：
- Git：初始化时 clone，token wire 进 remote，agent 不接触 token
- 自定义工具（MCP）：OAuth token 存 vault，通过 proxy 调用，harness 全程不知道凭证

### 性能数据

解耦后 TTFT（time-to-first-token）：
- p50 降低约 **60%**
- p95 降低超过 **90%**

---

## 涉及页面

- [[concepts/managed-agents]] — 完整架构说明
- [[concepts/agent-session]] — Session 作为外部上下文存储
- [[concepts/mcp]] — MCP 作为自定义工具接口
- [[entities/claude-code]] — 文章末尾提到 Claude Code 是优秀 harness 的一个例子
