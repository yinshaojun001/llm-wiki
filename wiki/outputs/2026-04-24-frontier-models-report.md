---
title: "前沿模型调研：DeepSeek V4 & GPT-5.5（2026-04）"
tags: [output, llm, deepseek, openai, frontier-model]
date: 2026-04-24
sources: [sources/frontier-models-2026-04.md]
---

# 前沿模型调研：DeepSeek V4 & GPT-5.5

> 调研时间：2026-04-24  
> 背景：GPT-5.5 于 2026-04-23 发布；DeepSeek V4 预览版于 2026-04-24 发布并开源。

---

## DeepSeek V4（2026-04-24 发布，MIT 开源）

### 版本
| 规格 | V4-Pro | V4-Flash |
|------|--------|----------|
| 总参数 | 1.6T | 284B |
| 激活参数 | 49B | 13B |
| 上下文 | 1M tokens | 1M tokens |
| 推理模式 | Non-think / Think-High / Think-Max | 同左 |

### 核心架构
- **混合注意力（CSA + HCA）**：1M 上下文下 Pro 推理算力仅为 V3.2 的 27%，KV 缓存仅 10%
- **Engram 条件记忆**：O(1) DRAM 查表，长文检索准确率 97%
- **mHC 流形约束超连接**：稳定万亿参数训练
- **Muon 优化器**：加速收敛

### 关键 Benchmarks
- Agentic Coding：开源 SOTA，体验优于 Sonnet 4.5
- SWE Verified：80.6%
- LiveCodeBench：93.5
- Terminal-Bench 2.0：67.9%
- 世界知识：大幅领先所有开源模型，稍逊 Gemini-3.1-Pro
- 官方自评：落后 GPT-5.4 和 Gemini-3.1-Pro 约 3-6 个月

### 定价
| 计费项 | V4-Pro | V4-Flash |
|--------|--------|----------|
| 输入（缓存命中）| ¥1 | ¥0.2 |
| 输入（缓存未命中）| ¥12 | ¥1 |
| 输出 | ¥24 | ¥2 |

### 特色
- 全程华为昇腾训练推理，全球首个国产算力万亿参数模型
- 短板：无原生多模态、创意任务偏弱

---

## GPT-5.5（2026-04-23 发布，闭源）

### 规格
- 原生全模态（文本 + 图像 + 音频 + 视频），首次全量重训
- 上下文：1M tokens
- 定价：$5/M input、$30/M output（GPT-5.4 两倍）；Pro 版 $30/$180
- 推理硬件：NVIDIA GB200/GB300 NVL72 联合设计

### 关键 Benchmarks
- Terminal-Bench 2.0：82.7%（Agentic 编程 SOTA）
- OSWorld-Verified：78.7%（电脑操控 SOTA）
- MRCR v2（1M 长上下文）：74.0%（+102% vs GPT-5.4）
- FrontierMath Tier 4：35.4%
- BrowseComp：84.4%
- SWE-Bench Pro：58.6%（弱于 Claude Opus 4.7 的 64.3%）

### 创新
- Token 效率：以约一半 token 消耗达到前沿分数
- 自适应计算：匹配 GPT-5.4 延迟但用更少 token
- 安全：Preparedness Framework "高"级别，推出 Trusted Access for Cyber

---

## 参考资料

- [DeepSeek 官方 API 文档](https://api-docs.deepseek.com/news/news260424)
- [Introducing GPT-5.5 | OpenAI](https://openai.com/index/introducing-gpt-5-5/)
- [OpenAI unveils GPT-5.5 — The Decoder](https://the-decoder.com/openai-unveils-gpt-5-5-claims-a-new-class-of-intelligence-at-double-the-api-price/)
- [DeepSeek V4 发布 — 36氪](https://36kr.com/p/3780290045121801)
- [DeepSeek V4 开源 — 阿里云开发者社区](https://developer.aliyun.com/article/1730877)
