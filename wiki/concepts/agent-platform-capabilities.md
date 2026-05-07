---
title: Agent 平台能力模型
tags: [concept, agent, platform, architecture]
date: 2026-04-28
sources: [sources/managed-agents.md, sources/openclaw-architecture.md, sources/agent-web-research.md, sources/monthly-ai-radar-2026-03.md]
---

# Agent 平台能力模型

> 综合 Managed Agents、OpenClaw、Claude Code 及 2025-2026 行业实践，提炼 Agent 平台的七层能力模型。

---

## 总览

```
┌──────────────────────────────────────────────┐
│           L7 平台开放性（配置即代码、Channel、市场）  │
├──────────────────────────────────────────────┤
│           L6 部署与运维（渐进发布、多租户、审计）     │
├──────────────────────────────────────────────┤
│           L5 可观测与评估（Tracing、Eval、成本）    │
├──────────────────────────────────────────────┤
│           L4 安全与护栏（四层防御、人在回路）        │
├──────────────────────────────────────────────┤
│           L3 多 Agent 编排（Orch/Handoff/Debate）│
├──────────┬──────────────┬────────────────────┤
│  L2 记忆  │  L1 工具系统  │  L0 Agent 运行时     │
│  三层记忆 │  元工具模式   │  Brain-Hands-       │
│  Session │  风险分级     │  Session 解耦       │
│  外部化   │  MCP 网关    │  多模型路由          │
└──────────┴──────────────┴────────────────────┘
```

下面从 L0 到 L7 逐层展开。**下层是上层的依赖，缺一层整个平台就不完整。**

---

## L0：Agent 运行时（核心引擎）

这是平台的心脏。决定了 Agent 怎么"活"起来。

### 能力清单

| 能力 | 说明 | 参考 |
|---|---|---|
| **Brain-Hands-Session 解耦** | 推理（Brain）、执行（Hands）、上下文（Session）三个组件独立，各有接口，任一可独立失败和替换 | [[concepts/managed-agents]] |
| **执行循环** | Observe → Retrieve → Propose → Validate → Execute → Update，这是所有 Agent 的基本节拍 | [[concepts/managed-agents]] |
| **按需 Provision** | Sandbox 只在 `execute()` 被调用时创建，闲置时销毁——p95 TTFT 降低 90% 的核心 | [[concepts/managed-agents]] |
| **多模型路由** | 不绑死一个模型供应商。大模型做核心推理，小模型做分类/摘要，按任务路由 | [[12-框架与技术栈]] |
| **Harness 无状态化** | Harness 崩溃后新实例通过 `wake(sessionId)` 恢复，不依赖内存状态 | [[concepts/agent-session]] |
| **Pets → Cattle** | 所有组件可随时替换，像 K8s Pod 一样，不抢救单个实例 | [[concepts/managed-agents]] |

### 为什么 L0 是地基

如果运行时组件耦合在一起（旧 Managed Agents 模式），容器挂了需要人工抢救，无法水平扩展，一个 session 的异常会阻塞整个 Brain。解耦之后每个组件独立伸缩，失败了自动替换。

---

## L1：工具 / Skills 系统

Agent 的手和脚。工具系统的设计质量，直接决定 Agent 能做什么、做错什么。

### 能力清单

| 能力 | 说明 | 参考 |
|---|---|---|
| **元工具模式** | LLM 只看到一个 `use_skill()` 入口，框架负责路由和加载——解决工具列表爆炸 | [[concepts/skills-architecture]] |
| **三级渐进披露** | 发现层（名称+一行摘要）→ 接口层（参数 schema）→ 实现层（代码不进上下文） | [[concepts/skills-architecture]] |
| **风险分级执行** | L0 只读自动执行 → L1 读取+过滤 → L2 写入需确认 → L3 高风险必须人在回路 | [[11-Agent核心组件]] |
| **MCP 网关** | 标准化工具接入协议，工具提供方和消费方解耦，支持第三方工具热插拔 | [[concepts/mcp]] |
| **沙箱执行** | 代码/命令在隔离环境执行，凭证永不进入沙箱 | [[concepts/managed-agents]] |
| **工具 Schema 校验** | 调用前验证参数类型和范围，调用后验证返回值——防止 Agent 的幻觉操作产生副作用 | [[10-不易变化的基础]] |
| **动态技能发现** | < 30 个技能：静态注入 prompt；> 30 个技能：语义搜索按需加载 | [[concepts/skills-architecture]] |

### 为什么工具系统是 L1 而非附加功能

工具是 Agent 的**唯一对外行动通道**。没有工具，Agent 只是一个聊天机器人。工具设计不好——权限太宽、描述不清晰、没有校验——Agent 就会做错事，而且你不知道它做错了。

---

## L2：记忆系统

Agent 的记忆。没有记忆的 Agent 每次对话都是"初次见面"。

### 能力清单

| 能力 | 说明 | 参考 |
|---|---|---|
| **三层记忆** | 短期（context window）→ 工作记忆（当前任务快照）→ 长期记忆（向量存储+知识图谱） | [[concepts/agent-memory]] |
| **Session 外部化** | 上下文存为 append-only 事件日志，存在 Agent 之外，通过 `getEvents()` 按需检索——不做不可逆的 token 丢弃决策 | [[concepts/agent-session]] |
| **跨 Session 检索** | 用语义相似度检索历史知识和偏好，不是简单堆砌历史对话 | [[concepts/agent-memory]] |
| **记忆管理（遗忘）** | 编码→存储→检索→遗忘（时间衰减+重要性评分），不是无限堆积 | [[concepts/agent-memory]] |
| **Harness 可恢复** | 崩溃后新 Harness 通过 `wake(sessionId)` + `getSession(id)` 恢复到最后一个事件 | [[concepts/agent-session]] |

### Session 外部化 vs 直接把历史塞进 Context Window

这是两级不同的设计哲学：

| 方案 | 做法 | 问题 |
|---|---|---|
| 塞进 Context Window | 把历史对话拼进 Prompt | 不可逆——裁剪了就找不回来；上下文越长 IQ 越衰减 |
| Session 外部化 | 事件日志存外部，Harness 按需检索并按需传给模型 | 可逆——检索策略可以事后调整；上下文窗口留给最重要的信息 |

---

## L3：多 Agent 编排

单 Agent 是细胞，多 Agent 才是组织。但不是所有任务都需要多 Agent。

### 能力清单

| 能力 | 说明 |
|---|---|
| **Orchestrator 模式** | 一个主管 Agent 分派任务、追踪进度、聚合结果 |
| **Handoff 模式** | Agent 之间直接移交任务和上下文（类似客服转接专家） |
| **Debate 模式** | 多个 Agent 独立出方案，裁判投票选最优 |
| **Pipeline 模式** | 研究者→分析师→写手，流水线传递 |
| **嵌套深度控制** | 子 Agent 嵌套 ≤2 层；深层 Agent 默认无 session 管理权限 |
| **Agent 间通信协议** | ACP（Agent Communication Protocol）标准化 Agent 间的消息传递 | [[concepts/acp]] |
| **动态 Agent 注册** | 按能力标签和 embedding 发现可用 Agent，类似服务网格的 Service Discovery |

### 多 Agent 不是默认选项

多 Agent 的代价：Token 消耗翻倍、协调开销、结果不一致。判断标准——**单 Agent 能在 5 步内完成的任务，不需要多 Agent**。

---

## L4：安全与护栏

Agent 的免疫系统。能力越强，安全越重要。

### 四层防御

```
输入层  → Prompt 注入检测、越狱检测、PII 自动脱敏
执行层  → 工具调用前参数校验、操作风险分级、权限校验
输出层  → 幻觉检测、内容安全审核、格式合规校验
系统层  → 死循环检测与自动熔断、Token 预算上限、超时强制终止
```

### 能力清单

| 能力 | 说明 |
|---|---|
| **Prompt 防火墙** | 检测和拦截注入攻击——用户输入里藏"忽略之前的指令" |
| **操作风险分级** | 每次工具调用自动分级：只读→自动 / 写入→确认 / 高风险→人在回路 |
| **人在回路** | 高危操作（发邮件、部署、支付、删文件）必须人工确认 |
| **熔断机制** | 同一工具连续调用超 5 次、Token 消耗超预算、延迟超阈值 → 自动熔断 |
| **凭证隔离** | 凭证永不进入沙箱——Token 在 Harness 层，通过 Proxy 调用 MCP 工具时注入 |
| **审计日志** | 谁、什么时候、触发了什么操作、结果如何、是否经人工确认——不可篡改 |

### Java 类比

- Input Guardrail ≈ Web 应用 XSS/SQL 注入防护
- 熔断 ≈ Hystrix/Sentinel
- 人在回路 ≈ 审批工作流
- 审计日志 ≈ 操作审计表

---

## L5：可观测性与评估

[[concepts/trust-infrastructure]] 的核心。看不见的东西没法信任。

### 能力清单

| 能力 | 说明 |
|---|---|
| **全链路 Tracing** | 每个 LLM 调用、工具执行、检索、Agent 间通信，都有 Trace（OpenTelemetry 兼容） |
| **成本仪表盘** | Token 消耗按任务/用户/时间/模型可拆分；会话运行时间精确到毫秒 |
| **自动化评估 Pipeline** | Golden Test Set + LLM-as-Judge + 持续回归——每次变更自动跑 |
| **关键指标面板** | 目标成功率、工具选择准确率、幻觉率、延迟 p50/p95、人工修正率 |
| **告警规则** | 延迟超阈值、Token 异常飙升、成功率下降、死循环检测 → 自动告警 |
| **Trace 回溯** | 出问题后能按 Trace 定位到具体哪一步出错——是 LLM 推理错了还是工具返回错了 |

### 评估是 Agent 开发的 CI/CD

不是"上线前测一下"，而是和 CI/CD 的 test stage 一样——**每次变更都跑全量评估，不通过不发版**。Agent 的非确定性让这件事比传统软件更重要。

---

## L6：部署与运维

把 Agent 变成线上服务，而不是本地脚本。

### 能力清单

| 能力 | 说明 |
|---|---|
| **渐进式发布** | Sandbox → Shadow Mode（静默跑真实流量）→ Canary（1%）→ 5% → 25% → 100% |
| **回滚机制** | 每个阶段都有可执行回滚方案，不是"理论上可以" |
| **自动扩缩容** | Agent 任务入队，Worker 按需扩容（K8s HPA 或 Serverless） |
| **多模型供应商** | 架构上支持多模型切换——你的主力模型可能被弃用 |
| **优雅关闭** | Agent 正在执行的任务不中断，新任务不再接收，排空后关闭 |
| **健康检查** | Harness、Sandbox、MCP Server、向量数据库，每个组件都有健康端点 |

### 部署不是最后一步

Agent 的失败模式不可预测——一个 Prompt 变体可能导致完全不同的行为路径。所以不能一次性全量上线。Shadow Mode 跑 2 周，Canary 跑 1 周，确认所有指标正常再全量。和你七年前学到的发布流程一模一样。

---

## L7：平台开放性

平台不是一次性产品，要有生态才能持续。

### 能力清单

| 能力 | 说明 | 参考 |
|---|---|---|
| **配置即代码** | 项目级 Agent 配置文件，可版本控制、可迁移、可 CI/CD | [[concepts/agents-md]] |
| **Channel 适配** | 统一抽象层对接飞书/Slack/Telegram/Web——Agent 不关心消息从哪来 | [[entities/openclaw]] |
| **多租户隔离** | 不同团队的 Session、记忆、工具权限、成本核算完全隔离 | |
| **Skill / 插件市场** | 第三方可贡献工具和 Skill，语义检索动态发现 | [[entities/memos]] 技能市场 |
| **API 优先** | 所有平台能力通过 API 暴露——不是 GUI 操作，而是可编程的 | [[concepts/managed-agents]] Sessions API |
| **Meta-harness 设计** | 不规定用哪个 Harness，只规定接口形状——Claude Code、自建 Agent、第三方 Agent 都能接入 | [[concepts/managed-agents]] |

---

## 七层之间的关系

```
L7 开放性    ← 让平台被集成、被扩展（API、Channel、市场）
L6 部署运维  ← 让平台稳定跑在生产环境（发布、扩缩容、回滚）
L5 可观测    ← 让平台可见、可量化、可优化（Trace、Eval、成本）
L4 安全护栏  ← 让平台不乱来（四层防御、人在回路、熔断）
L3 多Agent   ← 让多个 Agent 协同工作（Orch/Handoff/Debate）
L2 记忆      ← 让 Agent 有记忆（三层记忆、Session 外部化）
L1 工具系统  ← 让 Agent 能做事（元工具、风险分级、MCP）
L0 运行时    ← 让 Agent 活起来（Brain-Hands-Session 解耦）
```

**下层决定"能不能跑"，上层决定"敢不敢用"。**

大多数 Demo 项目停在 L0-L2（能跑、能调工具、能记住），但生产级平台必须到 L5（可观测 + 评估），企业级平台必须到 L7（多租户 + 开放 API + 市场）。

---

## 各阶段的核心权衡

| 阶段 | 核心权衡 |
|---|---|
| L0 运行时 | 解耦带来的复杂度 vs Pets 模式的不可扩展——**值得解耦** |
| L1 工具 | 工具越多能力越强 vs 工具越多选择越容易错——**5-8 个核心工具 + 按需加载** |
| L2 记忆 | 记住越多越好 vs 记忆越多检索越慢——**选择性遗忘** |
| L3 多 Agent | 多 Agent 更强大 vs Token 翻 N 倍——**单 Agent 能解决的不用多 Agent** |
| L4 安全 | 安全越严格 Agent 越受限 vs 越自由越危险——**风险分级，高危操作人在回路** |
| L5 可观测 | 指标越多看得越全 vs 指标越多越疲劳——**聚焦 3-5 个业务相关指标** |
| L6 部署 | 发布越快迭代越快 vs Agent 失败模式不可预测——**渐进式发布不可跳过** |
| L7 开放性 | 越开放集成越容易 vs 越开放安全越难控——**API 优先，权限最小化** |

---

## 关联

- [[concepts/managed-agents]]（L0 运行时核心参考）
- [[concepts/agent-session]]（L2 记忆核心参考）
- [[concepts/agent-memory]]（L2 记忆机制）
- [[concepts/skills-architecture]]（L1 工具系统核心参考）
- [[concepts/mcp]]（L1 工具协议）
- [[concepts/acp]]（L3 Agent 间通信协议）
- [[concepts/trust-infrastructure]]（L4+L5 信任体系）
- [[concepts/agents-md]]（L7 配置即代码）
- [[entities/openclaw]]（完整平台实现参考）
- [[agent-engineering/00-总览]]（学习路径）
- [[agent-engineering/11-Agent核心组件]]（L1-L4 组件详解）
