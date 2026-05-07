---
title: "前沿模型调研：DeepSeek V4 & GPT-5.5（2026-04）"
tags: [source, llm, deepseek, openai, frontier-model]
date: 2026-04-24
---

# 前沿模型调研：DeepSeek V4 & GPT-5.5

> 调研时间：2026-04-24  
> 信息来源：官方文档、36氪、腾讯新闻、阿里云开发者社区、The Decoder、CNBC、Les Numeriques 等

---

## GPT-5.5（2026-04-23 发布）

- **发布时间**：2026-04-23，代号 "Spud"，距 GPT-5.4 仅 6 周
- **定位**：面向真实工作与 Agent 的新智能等级，首次从预训练阶段全量重训
- 来源：[OpenAI 官方公告](https://openai.com/index/introducing-gpt-5-5/)、[The Decoder](https://the-decoder.com/openai-unveils-gpt-5-5-claims-a-new-class-of-intelligence-at-double-the-api-price/)、[CNBC](https://www.cnbc.com/2026/04/23/openai-announces-latest-artificial-intelligence-model.html)

### 关键规格
- 架构：原生全模态（文本 + 图像 + 音频 + 视频）
- 上下文窗口：1M tokens（Codex 版 400K）
- 推理硬件：NVIDIA GB200 / GB300 NVL72 联合设计
- 定价：$5/M input、$30/M output（GPT-5.4 的两倍）
- Pro 版：$30/M input、$180/M output

### 相对 GPT-5.4 的改进
| 维度 | GPT-5.4 | GPT-5.5 |
|------|---------|---------|
| MRCR v2（长上下文）| 36.6% | 74.0% |
| Terminal-Bench 2.0（编程）| 75.1% | 82.7% |
| FrontierMath Tier 4（数学）| 27.1% | 35.4% |
| GDPval（真实职业任务）| 83.0% | 84.9% |
| OSWorld-Verified（电脑操控）| 75.0% | 78.7% |
| CyberGym（安全攻防）| 79.0% | 81.8% |

### 与竞品对比
| Benchmark | GPT-5.5 | Claude Opus 4.7 | Gemini 3.1 Pro |
|-----------|---------|-----------------|----------------|
| Terminal-Bench 2.0 | **82.7%** | 69.4% | 68.5% |
| OSWorld-Verified | **78.7%** | 78.0% | — |
| FrontierMath Tier 4 | **35.4%** | 22.9% | 16.7% |
| SWE-Bench Pro | 58.6% | **64.3%** | — |
| MCP Atlas | 75.3% | **79.1%** | 78.2% |
| HLE（无工具）| 41.4% | **46.9%** | — |
| GPQA Diamond | 93.6% | **94.2%** | — |
| BrowseComp | **84.4%** | 79.3% | — |

### 创新点
- Token 效率：以约一半 token 消耗达到前沿分数
- 自适应计算：根据任务复杂度动态分配算力
- 安全：Preparedness Framework "高"级别，推出 "Trusted Access for Cyber" 计划

---

## DeepSeek V4（2026-04-24 发布）

- **发布时间**：2026-04-24（预览版），同步开源（MIT 协议）
- 来源：[DeepSeek 官方 API 文档](https://api-docs.deepseek.com/news/news260424)、[36氪](https://36kr.com/p/3780290045121801)、[阿里云开发者社区](https://developer.aliyun.com/article/1730877)、[腾讯新闻](https://news.qq.com/rain/a/20260424A041YF00)

### 版本矩阵
| 规格 | V4-Pro | V4-Flash |
|------|--------|----------|
| 总参数 | 1.6T | 284B |
| 激活参数 | 49B | 13B |
| 上下文 | 1M tokens | 1M tokens |
| 预训练数据 | 33T tokens | 32T tokens |
| 开源协议 | MIT | MIT |

### 四大架构创新
- **混合注意力（CSA + HCA）**：1M 上下文下，V4-Pro 推理算力仅 V3.2 的 27%，KV 缓存仅 10%；Flash 压到 10% 和 7%
- **Engram 条件记忆**：O(1) DRAM 查表，长文检索准确率 97%
- **mHC（流形约束超连接）**：替代传统残差，稳定万亿参数训练
- **Muon 优化器**：提升收敛速度

### Benchmarks（Pro 版）
- Agentic Coding：开源 SOTA，使用体验优于 Sonnet 4.5
- SWE Verified：80.6%（与顶级闭源打平）
- Apex Shortlist：90.2%
- LiveCodeBench：93.5%
- Terminal-Bench 2.0：67.9%
- 世界知识：大幅领先所有开源模型，仅稍逊 Gemini-3.1-Pro
- 官方自评：落后 GPT-5.4 和 Gemini-3.1-Pro 约 3-6 个月

### 定价（每百万 token）
| 计费项 | V4-Pro | V4-Flash |
|--------|--------|----------|
| 输入（缓存命中）| ¥1 | ¥0.2 |
| 输入（缓存未命中）| ¥12 | ¥1 |
| 输出 | ¥24 | ¥2 |

### 国产算力
- 全程华为昇腾（950/A3/A2）训练推理
- 昇腾 950 单卡吞吐 V4-Pro 达 4700 TPS
- 寒武纪 Day 0 适配
- 全球首个在国产算力上完成训练推理的万亿参数模型

### 短板
- 无原生多模态（仅文本）
- 创意类任务偏"干"，落后 Claude/GPT
- 高难度 Agent 任务与 Opus 4.6 思考模式有明显差距
