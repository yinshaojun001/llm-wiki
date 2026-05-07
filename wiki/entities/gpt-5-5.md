---
title: GPT-5.5
tags: [entity, llm, openai, frontier-model, agent]
date: 2026-04-24
sources: [sources/frontier-models-2026-04.md]
---

# GPT-5.5

OpenAI 于 **2026-04-23** 发布的最新旗舰模型，代号 "Spud"。距 GPT-5.4（2026-03-05）仅 6 周，是 GPT-5 系列第 5 次迭代。定位为"面向真实工作与 Agent 的新智能等级"，是 OpenAI 首次从预训练阶段全量重训的模型（自 GPT-4.5 以来）。

---

## 核心定位

专为**长时自主完成任务**设计：编程、网络研究、数据分析、文档创作、操控软件。核心卖点：**在不增加延迟的前提下大幅提升智能** — 匹配 GPT-5.4 的每 token 延迟，但用更少 token 完成更多任务。

---

## 规格

| 属性 | 值 |
|------|----|
| 发布时间 | 2026-04-23 |
| 架构 | 原生全模态（文本 + 图像 + 音频 + 视频） |
| 上下文窗口 | 1M tokens（Codex 版：400K） |
| API 输入定价 | $5/M tokens |
| API 输出定价 | $30/M tokens |
| Pro 版输入 | $30/M tokens |
| Pro 版输出 | $180/M tokens |
| 推理硬件 | NVIDIA GB200 / GB300 NVL72 联合设计 |
| 访问渠道 | ChatGPT Plus/Pro/Business/Enterprise + Codex；API 即将开放 |

> API 定价是 GPT-5.4 的两倍。

---

## 关键能力跃升（vs GPT-5.4）

| 维度 | GPT-5.4 | GPT-5.5 | 提升幅度 |
|------|---------|---------|----------|
| MRCR v2（1M 长上下文） | 36.6% | **74.0%** | +102% |
| Terminal-Bench 2.0（编程 Agent） | 75.1% | **82.7%** | +10% |
| FrontierMath Tier 4 | 27.1% | **35.4%** | +31% |
| GDPval（44 种真实职业） | 83.0% | **84.9%** | +2% |
| OSWorld-Verified（电脑操控） | 75.0% | **78.7%** | +5% |
| CyberGym（安全攻防） | 79.0% | **81.8%** | +4% |
| BrowseComp（网络研究） | 82.7% | **84.4%** | +2% |

---

## 完整 Benchmarks

### Agentic 编程与工具使用

| Benchmark | GPT-5.5 | GPT-5.5 Pro | Claude Opus 4.7 |
|-----------|---------|-------------|-----------------|
| Terminal-Bench 2.0 | **82.7%** | — | 69.4% |
| OSWorld-Verified | **78.7%** | — | 78.0% |
| CyberGym | **81.8%** | — | 73.1% |
| SWE-Bench Pro | 58.6% | — | **64.3%** |
| MCP Atlas | 75.3% | — | **79.1%** |
| Toolathlon | 55.6% | — | — |

### 知识与推理

| Benchmark | GPT-5.5 | GPT-5.5 Pro | Claude Opus 4.7 |
|-----------|---------|-------------|-----------------|
| GPQA Diamond | 93.6% | — | **94.2%** |
| HLE（无工具） | 41.4% | 43.1% | **46.9%** |
| HLE（带工具） | 52.2% | **57.2%** | 54.7% |
| FrontierMath Tier 1-3 | **51.7%** | 52.4% | 43.8% |
| FrontierMath Tier 4 | 35.4% | **39.6%** | 22.9% |
| BrowseComp | 84.4% | **90.1%** | 79.3% |
| GDPval（44 职业） | **84.9%** | 82.3% | 80.3% |
| Tau2-bench Telecom | **98.0%** | — | — |

### 长上下文

| Benchmark | GPT-5.5 | Claude Opus 4.7 |
|-----------|---------|-----------------|
| MRCR v2（1M） | **74.0%** | 32.2% |
| GraphWalks（256K） | 73.7% | — |
| GraphWalks（1M） | 45.4% | — |

---

## 效率创新

- **Token 效率**：在 Artificial Analysis 智能指数上以约一半的 token 消耗达到前沿分数
- **推理速度**：每 token 延迟与 GPT-5.4 持平，但总吞吐快约 20%（NVIDIA GB200/GB300 联合优化）
- **自适应计算**：根据任务复杂度动态分配算力

---

## 安全与部署

- 网络安全与生物能力评估为 Preparedness Framework **"高"** 级别
- 新推出 **"Trusted Access for Cyber"** 计划，管控高风险网络能力访问
- OpenAI 内部：财务团队用 GPT-5.5 审查 24,771 份 K-1 税表（71,637 页），节省 2 周工时
- 超过 85% 的 OpenAI 员工每周使用 Codex

---

## 优劣势总结

**优势**：Agentic 编程（Terminal-Bench 82.7%）、长上下文理解（MRCR 74.0%）、数学推理（FrontierMath）、网络研究（BrowseComp）、电脑操控（OSWorld 78.7%）均达到 SOTA 水平。

**劣势**：代码 Agent 任务（SWE-Bench Pro 58.6%）明显弱于 Claude Opus 4.7（64.3%）；纯知识推理（HLE 无工具 41.4%）也落后于 Opus 4.7（46.9%）；定价翻倍至 $5/$30 每百万 token。

---

## 关联

- [[entities/deepseek-v4]] — 同期最强开源竞争对手（2026-04-24）
- [[sources/frontier-models-2026-04.md]] — 原始调研摘要
- [[outputs/2026-04-24-frontier-models-report]] — 综合对比报告
