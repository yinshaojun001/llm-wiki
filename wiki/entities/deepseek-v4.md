---
title: DeepSeek V4
tags: [entity, llm, deepseek, frontier-model, open-source, china-ai, agent]
date: 2026-04-24
sources: [sources/frontier-models-2026-04.md]
---

# DeepSeek V4

深度求索（DeepSeek）于 **2026-04-24** 正式发布 DeepSeek-V4 预览版，同步开源（MIT 协议）。这是继 V3/R1 之后最重大的更新，时隔一年多。

---

## 版本矩阵

| 规格 | V4-Pro（旗舰） | V4-Flash（经济） |
|------|---------------|-------------------|
| 总参数 | 1.6T | 284B |
| 激活参数 | 49B | 13B |
| 上下文窗口 | 1M tokens | 1M tokens |
| 预训练数据 | 33T tokens | 32T tokens |
| 精度 | FP4 + FP8 混合 | FP4 + FP8 混合 |
| 开源协议 | MIT | MIT |
| 推理模式 | Non-think / Think-High / Think-Max | 同左 |

两款均支持三种推理模式：快速响应（Non-think）、逻辑分析（Think-High）、极限推理（Think-Max）。

---

## 核心架构创新

### 混合注意力架构（长上下文效率）
独创 **CSA（压缩稀疏注意力）+ HCA（重度压缩注意力）** 双机制，在 token 维度做压缩。

- 1M 上下文下，V4-Pro 单 token 推理算力仅为 V3.2 的 **27%**，KV 缓存仅 **10%**
- V4-Flash 更极致：算力 **10%**，缓存 **7%**
- 1M 上下文成为所有官方服务的标配

### Engram 条件记忆
基于哈希的 O(1) DRAM 查表，将静态知识从 GPU attention 卸载到系统内存。长上下文 Needle-in-a-Haystack 准确率达 **97%**（从 84.2% 大幅提升）。

### mHC（流形约束超连接）
替代传统残差连接，将混合矩阵约束到 Birkhoff Polytope，解决万亿参数训练稳定性，额外计算开销约 6-7%。

### Muon 优化器
新型优化器，提升收敛速度与训练稳定性。

---

## Benchmarks（官方 + 第三方实测）

### Agent 能力
| Benchmark | V4-Pro | 参照 |
|-----------|--------|------|
| Agentic Coding | 开源 SOTA | 体验优于 Sonnet 4.5，交付质量接近 Opus 4.6 非思考 |
| SWE Verified | **80.6%** | 与顶级闭源打平 |
| Terminal-Bench 2.0 | **67.9%** | — |
| Toolathlon | **51.8%** | — |

### 推理与竞赛
| Benchmark | V4-Pro |
|-----------|--------|
| Apex Shortlist | **90.2%**（四项最高） |
| Codeforces Rating | **3206**（四项最高） |
| LiveCodeBench | **93.5** |

- 数学/STEM/竞赛代码：超越所有已公开评测的开源模型（含 Kimi K2.6 Thinking、GLM-5.1 Thinking），比肩 GPT-5.4 和 Gemini 3.1-Pro 级别
- V4-Pro-Max 模式：标准推理超越 GPT-5.2 和 Gemini 3.0-Pro，略逊于 GPT-5.4 和 Gemini 3.1-Pro

### 世界知识
- **大幅领先所有开源模型**
- 仅稍逊于顶级闭源模型 Gemini-3.1-Pro

### 官方自评
> 总体落后 GPT-5.4 和 Gemini-3.1-Pro，发展轨迹约滞后前沿闭源 **3-6 个月**。在非推理类创意任务上偏"干"（过于正式），落后于 Claude 和 GPT 最新版。

---

## API 定价（每百万 token）

| 计费项 | V4-Pro | V4-Flash |
|--------|--------|----------|
| 输入（缓存命中） | ¥1 | ¥0.2 |
| 输入（缓存未命中） | ¥12 | ¥1 |
| 输出 | ¥24 | ¥2 |

对比 GPT-5.5 输出定价约 $30/百万 token（≈¥200+），V4-Flash 仅 ¥2，差距超 100 倍。下半年昇腾 950 超节点批量部署后 Pro 版价格预计大幅下调。

---

## 国产算力底座

- **训练 + 推理全程采用华为昇腾**：昇腾 950 / A3 / A2 全面适配
- 昇腾 950 超节点：V4-Pro 单 token 解码时延约 **20ms**，单卡吞吐 **4700 TPS**
- **寒武纪** 同步完成 Day 0 适配，代码开源
- 全球首个在国产算力底座上完成训练与推理的 **万亿参数级模型**

---

## 短板

1. **无原生多模态**：仅支持文本，不支持图像/视频/音频理解
2. **非推理类创意任务偏弱**：头脑风暴、文艺创作等场景落后 Claude/GPT
3. **高难度 Agent 任务**：与 Opus 4.6 思考模式仍存在明显差距
4. **Pro 版当前吞吐有限**：受限于高端算力供给，需等昇腾 950 批量上市后缓解
5. **未披露训练硬件型号**：技术文件中未明确 GPU 型号（与 V3 技术报告做法不同）

---

## 接口变更

旧版 `deepseek-chat` 和 `deepseek-reasoner` 接口将于 **2026-07-24** 停用，用户需迁移至新接口。

---

## 行业评价

- **Omdia 首席分析师**："从基准测试结果看，DeepSeek V4 确实将与美国竞争对手非常具有竞争力"
- **Morningstar 分析师**："V4 是一个'合格的'后续产品，但不像 R1 发布时那样具有突破性"
- 总体定位：不是模型新物种，而是把开源模型任务底座提升到新高度，主打**效率工程**和 **Agent 基础设施**

---

## 关联

- [[entities/gpt-5-5]] — OpenAI 同期旗舰（2026-04-23）
- [[sources/frontier-models-2026-04.md]] — 原始调研摘要
- [[outputs/2026-04-24-frontier-models-report]] — 综合对比报告
