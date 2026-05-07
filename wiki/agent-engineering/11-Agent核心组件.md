---
title: Agent 核心组件
tags: [agent-engineering, components, memory, planning, tool-use, multi-agent, safety]
date: 2026-04-28
---

# Agent 核心组件

> Agent = LLM + Memory + Planning + Tool Use。每个组件都可以独立设计和替换。

---

## 一、Memory 系统

### 三层架构

| 层 | 存储 | 生命周期 | 类比 |
|---|---|---|---|
| 短期记忆 | Context Window | 当前对话 | 本地变量 |
| 工作记忆 | Scratchpad / 任务快照 | 当前任务 | ThreadLocal |
| 长期记忆 | 向量数据库 / 知识图谱 | 跨 session | 数据库 |

### 四层架构（前沿）

```
L1 Active Context    → 当前 prompt 中的活跃信息
L2 Working Memory    → 提取的重要事实
L3 Episodic Memory   → 经历和交互历史
L4 Semantic Memory   → 蒸馏后的长期知识
```

### 核心机制

**编码 → 存储 → 检索 → 遗忘**

- 不是无限堆积——按时间衰减、按重要性保留
- Session 外部化（append-only event log）：不做不可逆的 token 丢弃决策，上下文存于 Agent 之外，按需检索
- 记忆检索用语义相似度，不是精确匹配

### 关键论文

| 论文 | 贡献 |
|---|---|
| Generative Agents (Park, 2023) | 记忆流 + 反思 + 规划，开山之作 |
| MemGPT (Packer, 2023) | OS 分页思想用于 LLM 上下文管理 |
| Mem0 (2025) | 生产级记忆层 |

> 详见 [[concepts/agent-memory]]、[[concepts/agent-session]]

---

## 二、Planning 策略

### 策略谱系

| 策略 | 思路 | 适用 |
|---|---|---|
| **ReAct** | 想一步 → 做一步 → 观察 → 再想 | 简单任务，灵活 |
| **Plan-and-Solve** | 先制定完整计划，再逐步执行 | 多步任务，有计划 |
| **Tree-of-Thoughts** | 每步探索多个方案，选最优的 | 需要搜索空间的任务 |
| **Reflexion** | 执行出错了自我反思，下次避免 | 需要自我改进的任务 |

### 取舍

| 维度 | ReAct | Plan-and-Solve |
|---|---|---|
| Token 消耗 | 低（每步想一点） | 高（计划本身就占 token） |
| 适应性 | 强（观察到变化立即调整） | 弱（计划可能过期） |
| 可预测性 | 低（下一步不确定） | 高（步骤预先列出） |
| 复杂任务效果 | 一般（容易迷路） | 好（结构化推进） |

### Java 类比

- ReAct ≈ 敏捷迭代（边做边调整）
- Plan-and-Solve ≈ 瀑布模型（先设计再编码）
- Tree-of-Thoughts ≈ 每个技术决策做 POC，选最优方案
- Reflexion ≈ 事故复盘 postmortem

---

## 三、Tool Use 工程

### 工具安全分级

```
L0 只读 — 读文件、查数据库 → 自动执行
L1 读取+过滤 — 搜索、聚合 → 自动执行
L2 写入 — 创建文件、修改数据 → 需确认
L3 高风险 — 发邮件、部署、支付 → 必须人在回路
```

### Schema 设计原则

- **description 是给 LLM 看的**——自然语言描述何时用、怎么用
- **parameters 是给代码看的**——类型、必填、约束
- **名字即意图**——`get_weather` 比 `tool_1` 好 100 倍

### MCP（Model Context Protocol）

解耦 Agent 和工具的网关协议。Agent 不直接调工具，通过 MCP Server 中转——工具提供方和消费方独立演进。

> 详见 [[concepts/mcp]]、[[concepts/skills-architecture]]

---

## 四、多 Agent 协作

### 四种模式

| 模式 | 机制 | 适用场景 |
|---|---|---|
| **Orchestrator** | 一个主 Agent 分派、追踪、合并 | 任务可拆分且结果需要汇总 |
| **Handoff** | Agent A 完成后移交上下文给 B | 不同专长接力（客服→专家） |
| **Debate** | 多个 Agent 独立出方案，裁判投票 | 高风险决策需要多视角 |
| **Pipeline** | 研究者→写手→编辑，流水线传递 | 内容生产链 |

### 设计约束

- 子 Agent 默认无 session 管理权限
- 嵌套深度可控（建议 ≤2 层）
- 多 Agent ≠ 更好——Token 消耗翻倍，需要明确收益才用

### Java 类比

- Orchestrator ≈ API Gateway（路由分发，聚合响应）
- Handoff ≈ 责任链模式
- Debate ≈ 多人 Code Review
- Pipeline ≈ Stream 处理链

---

## 五、安全与护栏

### 四层防御

```
输入层  → Prompt 注入检测、越狱检测、PII 脱敏
执行层  → 工具调用前参数校验、操作风险分级
输出层  → 幻觉检测、内容审核、合规检查
系统层  → 死循环熔断、成本上限、超时强制终止
```

### Human-in-the-Loop

高危操作（删文件、发邮件、部署、超预算）必须人工确认后才执行。不是所有操作都要审批——分级是关键。

### Java 类比

- Input Guardrail ≈ Web 应用 XSS/SQL 注入防护
- 熔断 ≈ Hystrix/Sentinel
- Human-in-the-Loop ≈ 审批工作流
- 审计日志 ≈ 操作审计表

---

## 关联

- [[00-总览]]
- [[10-不易变化的基础]]
- [[concepts/agent-memory]]
- [[concepts/agent-session]]
- [[concepts/managed-agents]]
- [[concepts/skills-architecture]]
- [[concepts/mcp]]
