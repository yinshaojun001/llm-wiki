---
title: Eval 综合指南——Agent 评估从原理到工具全景
tags: [output, eval, agent, evaluation, tools, team-sharing]
date: 2026-04-29
sources: [concepts/eval-in-agents.md, concepts/eval-tech-stack.md, agent-engineering/14-评估与可观测.md]
---

# Eval 综合指南——Agent 评估从原理到工具全景

> 团队分享用。覆盖：为什么需要 Eval → 怎么做 → 主流工具对比 → 最佳实践。

---

## 一、为什么 Eval 是 Agent 的命门

### 核心问题：Agent 是非确定性系统

传统软件：输入 A → 输出 B，永远是 B。测试通过 = 代码对了。

Agent：同一个问题问两次，答案可能不一样。因为 Agent 的大脑是 LLM，输出是概率性的。

Agent 的工作链路中每一步都有不确定性：

```
用户提问 → Agent 想怎么处理（不确定）→ 选哪个工具（不确定）→ 怎么组织参数（不确定）→ 怎么回答（不确定）
```

**你没法靠"看代码"判断 Agent 好不好，只能靠"看结果"——这就是 Eval。**

### 为什么现在特别重要

Agent 已经过了 demo 阶段，到了要上生产的阶段。踩过的坑：
- 改了一版 prompt，某个场景好了但另外两个退步了（回退），没有 eval 根本发现不了
- 换了更便宜的模型，表面测试通过，幻觉率从 2% 涨到 8%
- 测试环境表现好，上线后用户输入千奇百怪，成功率暴跌

**一句话：Eval 是你唯一能信任 Agent 的理由。**

---

## 二、Eval 怎么做：核心方法论

### 2.1 三步循环：出题 → 考试 → 改错

#### 出题：建 Golden Test Set

准备 30-200 道"黄金题目"，每道包含：
- **输入**：用户会问什么
- **期望输出**：正确答案
- **期望路径**：Agent 应该怎么处理（可选）

覆盖三类场景：正常路径 + 边界情况 + 已知容易出错的 case。

#### 考试：跑评估

两种打分方式：

| 方式 | 适用场景 | 优缺点 |
|------|---------|--------|
| **精确匹配** | 答案明确对/错 | 快速可靠，但只能测简单场景 |
| **LLM-as-a-Judge** | 主观题（"回答是否礼貌"） | 灵活，但 Judge 本身有偏见，需人工校准 |

#### 改错：迭代

```
做题 → 对答案 → 看错题 → 改 prompt → 再跑全部题 → 确认进步且没退步
```

### 2.2 Anthropic 官方方法论

来源：[Anthropic 官方文档——Define success criteria and build evaluations](https://platform.claude.com/docs/en/docs/build-with-claude/develop-tests)

#### 定义成功标准（四个原则）

| 原则 | 说明 | 反面教材 |
|------|------|---------|
| **Specific（具体）** | 清晰定义目标 | "表现要好" ✗ → "F1 ≥ 0.85" ✓ |
| **Measurable（可量化）** | 用数字或明确的量表 | "安全输出" ✗ → "10000 次中 <0.1% 有毒性" ✓ |
| **Achievable（可达）** | 基于行业基准设定 | 目标超过当前模型能力 ✗ |
| **Relevant（相关）** | 和业务目的对齐 | 医疗场景要求高引用准确性 ✓，闲聊 bot 不需要 |

#### 多维度评估（不要只看一个指标）

```
一个场景至少评估：
- 任务准确率（F1 / 精确匹配）
- 安全性（毒性 / 偏见 / 隐私泄露）
- 延迟（p50 / p95）
- 成本（token 消耗 / 任务）
```

#### 三种评分方式

| 方式 | 速度 | 质量 | 适用场景 |
|------|------|------|---------|
| **代码评分**（精确匹配、字符串匹配） | 最快 | 最可靠 | 答案明确的任务 |
| **LLM 评分**（LLM-as-a-Judge） | 快 | 灵活 | 主观判断、复杂场景 |
| **人工评分** | 最慢 | 最高 | 少量关键 case、校准 LLM 评分 |

#### LLM 评分最佳实践（来自 Anthropic）

- **给详细的评分标准（Rubric）**："答案必须在第一句提到'XX公司'，否则直接判错"
- **输出要具体**：让 LLM 输出"正确/错误"或 1-5 分，不要输出纯文字评价
- **鼓励推理**：让 LLM 先思考再打分（用 thinking tags），打分更准
- **用不同模型评分**：生成用 Claude，评分用 GPT（或反过来），避免自我偏见

#### 六类评估维度（Anthropic 推荐）

| 维度 | 衡量什么 | 评分方法 |
|------|---------|---------|
| Task Fidelity | 任务完成准确率 | 精确匹配 / F1 |
| Consistency | 同类问题回答一致性 | 余弦相似度 |
| Relevance & Coherence | 回答是否切题、有逻辑 | ROUGE-L |
| Tone & Style | 语气是否合适 | LLM Likert 量表 |
| Privacy Preservation | 是否泄露隐私信息 | LLM 二分类 |
| Context Utilization | 是否利用了对话上下文 | LLM 序数量表 |

---

## 三、主流工具对比

### 3.1 全景图

```
┌─────────────────────────────────────────────────────┐
│  第 4 层：Agent 行为评估   Ragas / Agent-as-a-Judge  │
├─────────────────────────────────────────────────────┤
│  第 3 层：LLM 评估框架     DeepEval / Promptfoo     │
├─────────────────────────────────────────────────────┤
│  第 2 层：Tracing 平台     Langfuse / Braintrust    │
├─────────────────────────────────────────────────────┤
│  第 1 层：数据集 & 基准     HELM / MMLU / GAIA      │
└─────────────────────────────────────────────────────┘
```

### 3.2 工具详细对比

#### DeepEval

- **定位**：开源 LLM 评估框架，写 eval 跟写 pytest 一样
- **语言**：Python
- **核心特点**：
  - 单轮评估（`LLMTestCase`）+ 多轮对话评估（`ConversationalTestCase`）
  - 组件级评估（tracing 到单个 span）+ 端到端评估
  - `@observe()` 装饰器做 tracing，非侵入式
  - 支持自定义指标 `GEval`，用自然语言定义评分标准
  - 内置指标：Faithfulness、Answer Relevancy、Hallucination、Toxicity、Bias
  - 分数 0-1，可配 threshold 判定 pass/fail
  - 自动重试 LLM 调用（指数退避 + jitter）
- **云端平台**：Confident AI（可选），提供回归测试、side-by-side 对比、生产监控
- **集成**：LangChain、LangGraph、OpenAI、CrewAI
- **评分模型**：OpenAI（默认）、Ollama、Azure、Anthropic、Gemini、自定义
- **来源**：[deepeval.com/docs](https://www.deepeval.com/docs/getting-started)

```python
# DeepEval 示例
from deepeval import assert_test
from deepeval.metrics import FaithfulnessMetric
from deepeval.test_case import LLMTestCase

def test_answer():
    test_case = LLMTestCase(
        input="我要退货",
        actual_output="请提供订单号，我来帮您处理退货",
        retrieval_context=["退货流程需要订单号..."]
    )
    assert_test(test_case, [FaithfulnessMetric(threshold=0.8)])
```

#### Ragas

- **定位**：RAG 专项评估框架，从"vibes 检查"到系统化评估
- **语言**：Python
- **核心特点**：
  - 四大核心指标：Faithfulness（忠实性）、Answer Relevancy（回答相关性）、Context Precision（上下文精准度）、Context Recall（上下文召回率）
  - 支持自定义指标（decorator 方式）
  - 内置测试集生成工具（含 Agent/Tool use 场景）
  - 实验驱动：修改 → 评估 → 观察 → 迭代
  - 支持 SQL 评估、Agent/Tool use 评估、NVIDIA 专用指标
- **集成**：LangChain、LlamaIndex
- **来源**：[docs.ragas.io](https://docs.ragas.io/en/latest/)

#### Promptfoo

- **定位**：开源 CLI，LLM 测试 + 红队安全
- **语言**：Node.js/TypeScript（支持 Python/JS 调用）
- **核心特点**：
  - YAML 配置驱动，不需要写代码
  - 矩阵视图：多 prompt × 多模型 side-by-side 对比
  - 红队测试：自动扫描安全漏洞和合规风险
  - 支持 Guardrails（实时防护）、MCP Proxy、Code Scanning
  - 完全本地运行，数据不出机器
  - CI/CD 集成（GitHub Actions）
  - 已被 OpenAI 收购
- **适用**：安全测试、多模型对比、合规场景（金融 FINRA、保险、房地产公平住房）
- **来源**：[promptfoo.dev/docs](https://www.promptfoo.dev/docs/intro/)

#### Langfuse

- **定位**：开源 LLM 工程平台，Tracing + 评估 + Prompt 管理一体化
- **核心特点**：
  - **Tracing**：捕获所有 LLM 和非 LLM 调用（检索、embedding、API）
  - **Session 追踪**：多轮对话、用户级监控
  - **Agent Graph**：可视化 Agent 工作流为有向图
  - **Prompt 管理**：版本控制、标签部署、LLM Playground
  - **评估**：LLM-as-a-Judge、用户反馈、人工标注队列（Annotation Queues）、数据集实验
  - 基于 OpenTelemetry 标准，减少厂商锁定
  - 支持多模态（文本 + 图片）
- **集成**：OpenAI SDK、LangChain、LlamaIndex、50+ 库
- **来源**：[langfuse.com/docs](https://langfuse.com/docs)

```python
# Langfuse 评分示例
langfuse.score(
  trace_id="123",
  name="my_custom_evaluator",
  value=0.5,
)
```

#### Braintrust

- **定位**：AI 可观测性平台，评估 + 回归 + 生产监控
- **核心特点**：
  - 六阶段工作流：Instrument → Observe → Annotate → Evaluate → Deploy → Admin
  - 从生产数据中挖掘评估用例
  - A/B 对比 + 回归检测
  - 人工标注 → 数据集 → 实验 → 部署闭环
- **适用**：工程化程度高的团队，需要从生产数据持续改进
- **来源**：[braintrust.dev/docs](https://www.braintrust.dev/docs)

#### 其他值得了解的工具

| 工具 | 定位 |
|------|------|
| **LangSmith** | LangChain 生态原生，集成最顺滑 |
| **Arize Phoenix** | 企业级可观测性 + 评估 |
| **Inspect AI**（UK AISI） | 英国 AI 安全研究所出品，安全评估最强 |
| **lm-evaluation-harness**（EleutherAI） | Open LLM Leaderboard 底层引擎 |
| **OpenAI Evals** | OpenAI 官方，社区贡献评估用例 |
| **Weights & Biases** | 实验追踪起家，加了 LLM eval |
| **HELM**（Stanford） | 大学级综合评测，40+ 场景 |
| **GAIA / AgentBench** | Agent 专项基准测试 |

---

## 四、评估驱动开发（ADD）

和 TDD 逻辑一样——先写考试题，再写代码：

```
1. 写 Golden Test Set（定义"好"是什么）
2. 写 Prompt / 搭 Agent
3. 跑评估 → 看分数
4. 分析失败 case → 改 Prompt / 改检索 / 换模型
5. 再跑评估 → 确认没有回退
6. 把新发现的失败 case 加入 Golden Test Set
→ 回到第 3 步
```

**关键原则**：
- 改 prompt 就必须跑 eval，跟改代码必须跑测试一样
- 每次回归测试要跑全量，不能只跑改过的 case
- 新发现的 edge case 要及时加入 Golden Test Set，让题库越来越厚

---

## 五、Eval vs Observability

| | Eval（评估） | Observability（可观测性） |
|---|---|---|
| **时机** | 上线前 | 上线后 |
| **作用** | 证明 Agent 能发布 | 看到 Agent 正在干什么 |
| **回答的问题** | "Agent 靠不靠谱？" | "Agent 现在怎么了？" |
| **核心指标** | 准确率、F1、Faithfulness | 延迟 p95、token 成本、工具成功率 |
| **工具** | DeepEval、Ragas、Promptfoo | Langfuse、Braintrust、Arize |

两者合起来才是完整的质量闭环：eval 保证发版质量，observability 保证线上稳定性。

---

## 六、选型决策树

```
你做的是什么？
│
├─ 纯 RAG（检索增强生成）
│   └─ Ragas + Langfuse
│
├─ Agent（调用工具执行任务）
│   ├─ 快速起步 → DeepEval + Langfuse
│   ├─ 工程化团队 → Braintrust
│   └─ 用 LangChain → LangSmith 全家桶
│
├─ 模型选型（选哪个模型）
│   └─ Promptfoo（多模型对比）+ lm-evaluation-harness
│
├─ 安全合规
│   └─ Inspect AI + Promptfoo 红队模式
│
└─ 什么都不确定
    └─ 从 DeepEval 开始（最像写测试，学习成本最低）
```

---

## 七、参考链接

| 资源 | 链接 |
|------|------|
| Anthropic 官方 Eval 指南 | [platform.claude.com/docs](https://platform.claude.com/docs/en/docs/build-with-claude/develop-tests) |
| DeepEval 文档 | [deepeval.com/docs](https://www.deepeval.com/docs/getting-started) |
| Ragas 文档 | [docs.ragas.io](https://docs.ragas.io/en/latest/) |
| Promptfoo 文档 | [promptfoo.dev/docs](https://www.promptfoo.dev/docs/intro/) |
| Langfuse 文档 | [langfuse.com/docs](https://langfuse.com/docs) |
| Braintrust 文档 | [braintrust.dev/docs](https://www.braintrust.dev/docs) |

---

## 关联

- [[concepts/eval-in-agents]] — Eval 的"为什么"和核心概念
- [[concepts/eval-tech-stack]] — 技术栈四层全景 + 选型
- [[agent-engineering/14-评估与可观测]] — 评估实操 + 可观测性指标
- [[concepts/trust-infrastructure]] — Eval 是信任基础设施的地基
