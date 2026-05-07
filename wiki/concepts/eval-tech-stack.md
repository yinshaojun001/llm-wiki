---
title: Eval 技术栈全景
tags: [concept, agent, evaluation, tech-stack, tools]
date: 2026-04-29
sources: [concepts/eval-in-agents.md]
---

# Eval 技术栈全景

> Eval 工具分四层，从"题库"到"过程监控"到"打分"到"行为评估"。

---

## 全景图

```
┌─────────────────────────────────────────────┐
│  第 4 层：Agent 专项评估框架                    │  ← 行为级评估
├─────────────────────────────────────────────┤
│  第 3 层：通用 LLM 评估框架                    │  ← 模型级评估
├─────────────────────────────────────────────┤
│  第 2 层：可观测性 & Tracing 平台              │  ← 看到过程
├─────────────────────────────────────────────┤
│  第 1 层：数据集 & 基准测试                    │  ← 评估的"题库"
└─────────────────────────────────────────────┘
```

---

## 第 1 层：数据集 & 基准测试（题库）

评估的前提是有"题"。行业标准题库：

| 名称 | 是什么 | 适合谁 |
|------|--------|-------|
| **HELM**（Stanford） | 大学级综合评测，覆盖 40+ 场景 | 做模型选型时全面对比 |
| **MMLU** | 57 个学科的选择题考试 | 快速判断模型知识广度 |
| **HumanEval / SWE-bench** | 代码能力评测，给题目写代码 | 做编程 Agent 必测 |
| **GAIA** | 通用 AI Agent 基准，模拟真实任务 | Agent 产品团队 |
| **AgentBench** | 多环境 Agent 行为评测 | Agent 框架开发者 |
| **BigCodeBench** | 大规模代码生成评测 | 代码 Agent |

> 行业基准测通用能力，你自己的项目最重要的是 **Golden Test Set**——自己的题测自己的场景。

---

## 第 2 层：可观测性 & Tracing（看到过程）

Agent 推理过程是黑盒，需要看到每一步在干什么。

| 名称 | 特点 | 适合谁 |
|------|------|-------|
| **Langfuse** | 开源，Agent 专用，Trace + 评估 + 成本追踪一体 | 最推荐入门，社区活跃 |
| **Arize Phoenix** | 企业级，免费开源版功能够用 | 需要深度分析的团队 |
| **LangSmith** | LangChain 生态原生，集成最顺滑 | 用 LangChain 的项目 |
| **Braintrust** | 端到端平台，评分 + 回归 + CI 集成 | 重工程化的团队 |
| **Weights & Biases (W&B)** | 实验追踪起家，加了 LLM eval 模块 | 同时做模型训练的团队 |
| **OpenTelemetry** | 通用标准，做 Trace 传输层 | 和现有监控体系集成 |

> 没有历史包袱首选 **Langfuse**；用 LangChain 生态选 **LangSmith**。

---

## 第 3 层：通用 LLM 评估框架（给模型打分）

回答"这个模型本身能力怎么样"。

| 名称 | 特点 | 适合谁 |
|------|------|-------|
| **DeepEval** | 开源，最像 pytest，写 eval 跟写测试一样 | Python 工程师首选 |
| **Promptfoo** | 命令行工具，配置驱动，支持红队测试 | 安全测试、多模型对比 |
| **lm-evaluation-harness**（EleutherAI） | Open LLM Leaderboard 底层引擎 | 跑行业标准 benchmark |
| **OpenAI Evals** | OpenAI 官方，社区贡献评估用例 | 用 OpenAI 模型的团队 |
| **Inspect AI**（UK AISI） | 英国 AI 安全研究所出品，安全评估最强 | 安全合规场景 |
| **Unitxt**（IBM） | 模块化，可组合评估流水线 | 需要自定义评估流程 |

DeepEval 示例——写 eval 跟写单元测试一样：

```python
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

跑 `pytest` 就行，CI/CD 直接集成。

---

## 第 4 层：Agent 专项评估框架（行为级）

最前沿的一层。Agent 评估比 LLM 评估复杂——不只看"答案对不对"，还要看**"过程对不对"**（调了什么工具、什么顺序、有没有死循环）。

| 名称 | 特点 | 适合谁 |
|------|------|-------|
| **Ragas** | RAG 专项，四大指标（Faithfulness / Relevancy / Precision / Recall） | 做 RAG 管线的项目 |
| **Langfuse Eval** | 在 tracing 基础上直接打分，支持人工标注 + LLM-as-Judge | 已用 Langfuse 的团队 |
| **Braintrust** | 回归测试 + A/B 对比 + CI 阻断 | 工程化程度高的团队 |
| **Anthropic Evals** | Claude 专用评估工具 | 用 Claude 做 Agent 的项目 |
| **Agent-as-a-Judge** | 让一个 Agent 评估另一个 Agent 的行为路径 | 多 Agent 系统 |

通用 LLM eval vs Agent eval 的区别：

```
用户问："帮我订明天北京到上海的机票"

❌ 只看答案：Agent 最终订了一张票 → 对了
✅ 看过程：Agent 先查日期 → 查航班 → 比价 → 选最便宜的 → 过程合理吗？
```

---

## 怎么选

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
└─ 安全合规
    └─ Inspect AI + Promptfoo 红队模式
```

---

## 关联

- [[concepts/eval-in-agents]] — Eval 的"为什么"和"怎么做"
- [[agent-engineering/14-评估与可观测]] — 评估实操 + 可观测性指标
- [[concepts/trust-infrastructure]] — Eval 是信任基础设施的地基
