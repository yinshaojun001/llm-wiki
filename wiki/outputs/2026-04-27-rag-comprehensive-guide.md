---
title: RAG 从入门到精通
tags: [output, learning-guide, rag, llm, retrieval]
date: 2026-04-27
sources: [https://arxiv.org/abs/2005.11401, https://arxiv.org/abs/2312.10997, https://arxiv.org/abs/2412.13546]
---

# RAG 从入门到精通

> 检索增强生成（Retrieval-Augmented Generation）完整知识体系，从基础原理到 2026 年前沿范式。

---

## 一、什么是 RAG

### 一句话定义

RAG 是**给 LLM 外挂一个知识库**——收到问题后先去知识库里搜相关文档，把搜到的内容和问题一起喂给 LLM，让 LLM 基于这些"参考资料"生成答案。

### 为什么需要 RAG

LLM 的三个根本限制：

| 限制 | 说明 | RAG 如何解决 |
|---|---|---|
| **知识截止** | 训练数据有截止日期，不知道训练后的事 | 知识库可随时更新 |
| **幻觉** | 编造不存在的事实 | 答案被检索到的文档约束 |
| **私有知识** | 不知道你公司的内部文档 | 把内部文档放进知识库即可 |

RAG 的核心价值是**用外部知识弥补 LLM 内部知识的不足**，既不重新训练模型，又能让模型回答它不知道的事。

### 工作流程（简化版）

```
用户提问 → Embedding 向量化 → 向量数据库搜索 Top-K → 拼接 Prompt → LLM 生成答案
```

---

## 二、RAG 范式演进

RAG 从 2020 年到 2026 年经历了五次范式演进：

```
Naive RAG → Advanced RAG → Modular RAG → Graph RAG → Agentic RAG
  (2020)      (2021-2023)     (2024)       (2024)       (2024-2026)
```

### 2.1 Naive RAG（朴素 RAG，2020）

**来源**：Meta AI, Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (NeurIPS 2020)

**流程**：三阶段线性流水线

```
Indexing（建索引）→ Retrieval（检索）→ Generation（生成）
```

| 步骤 | 做什么 |
|---|---|
| Indexing | 把文档切成 chunk，用 Encoder 生成 Embedding，存入向量数据库 |
| Retrieval | 用户 query 转 Embedding，在向量库中搜 Top-K 相似 chunk |
| Generation | 把 query + 检索到的 chunk 拼进 prompt → LLM 生成答案 |

**核心缺陷**：
- 查询太短难匹配长文档（query-document mismatch）
- 检索噪声多，无关内容也塞进 prompt
- 无法处理复杂多跳问题
- 线性流程，不能动态调整

### 2.2 Advanced RAG（高级 RAG，2021-2023）

在 Naive RAG 基础上增加了**预检索处理**和**后检索处理**两个模块。

**Pre-Retrieval（检索前优化）**：
| 技术 | 说明 |
|---|---|
| Query Rewriting | 重写用户查询使其更精准 |
| Query Expansion | 扩展查询词，增加召回 |
| Query Decomposition | 把复杂问题拆成子问题 |
| HyDE | 先生成假设答案再用答案做检索 |

**Post-Retrieval（检索后优化）**：
| 技术 | 说明 |
|---|---|
| Reranking | 用交叉编码器对初检结果二次打分，提升相关性 20-40% |
| Prompt Compression | 裁切冗余，保留核心信息 |

> 核心进步：从被动检索升级为**主动优化**，但仍是线性流程。

### 2.3 Modular RAG（模块化 RAG，2024）

**来源**：Gao et al., "Modular RAG: Transforming RAG Systems into LEGO-like Reconfigurable Frameworks" (2024.07)

**核心思想**：把 RAG 拆解为**可插拔独立模块**，像乐高积木一样自由组合。

**六大模块类型 + 编排层**：

```
Module Type: Indexing | Pre-Retrieval | Retrieval | Post-Retrieval | Memory | Generation
Orchestration: 线性 / 条件 / 分支 / 循环
```

**编排模式**：
| 模式 | 说明 | 场景 |
|---|---|---|
| Linear | 模块顺序串联 | 简单问答 |
| Conditional | Router 条件分支 | 不同查询走不同检索路径 |
| Branching | 并行处理后合并 | 跨多源检索 |
| Loop | 迭代/递归/自适应检索 | 结果不够时回搜 |

**代表框架**：Haystack、LangFlow

### 2.4 Graph RAG（图 RAG，2024）

**核心思想**：用**知识图谱**替代或补充向量检索。实体和关系被建模为图的节点和边，检索变成图遍历。

**代表系统**：
| 系统 | 特点 |
|---|---|
| Microsoft GraphRAG | Local 模式（邻居遍历）+ Global 模式（社区摘要），全局主题合成能力强 |
| LightRAG | 双层图遍历，索引成本更低 |
| GraphRetriever (Meta) | 相比纯向量搜索减少幻觉约 30% |

**优势**：多跳推理、完整可追溯链条、全局主题摘要
**局限**：图构建成本高、实体解析噪声、图更新维护复杂

### 2.5 Agentic RAG（智能体 RAG，2024-2026）

**核心突破**：将**自主 Agent** 嵌入 RAG，从"检索→生成"的线性管道变成**智能体动态决策**。

**Agent 的四个核心能力**：
```
LLM（大脑）+ Memory（记忆）+ Planning（规划）+ Tools（工具调用）
```

**关键决策链**：
```
IF（要不要检索？）→ WHAT（检索什么？）→ WHERE（从哪里检索？）→ HOW（检索到了怎么用？）→ GENERATE（如何生成？）
```

**六大 Agentic RAG 子类型**：

| 类型 | 架构 | 适用场景 |
|---|---|---|
| Single-Agent RAG | 单一 Router Agent 决策 | 简单多源问答 |
| Multi-Agent RAG | 多个专业 Agent + 协调器 | 跨领域复杂查询 |
| Hierarchical Agentic RAG | 顶级 Agent → 子 Agent → 聚合 | 需要多级推理的任务 |
| Corrective Agentic RAG | 检索 → 评估 → 修正 → 重检 → 生成 | 高准确率要求的场景 |
| Adaptive Agentic RAG | 分类器评估查询复杂度，自适应策略 | 查询复杂度变化大 |
| Graph-Based Agentic RAG | 图知识库 + 文档 + Critic + 反馈循环 | 需要关系推理的场景 |

**代表框架**：LangGraph、CrewAI、AutoGen

### 2.6 In-Context Search（上下文内搜索，2026 前沿）

**最新范式**：不预先建索引，让 LLM 直接在上下文窗口内浏览和推理文档。

| 方案 | 方式 | 特点 |
|---|---|---|
| PageIndex | 自顶向下 | 层次语义树，Agent 递归导航 |
| Sirchmunk | 自底向上 | 蒙特卡洛采样 + 贪心级联，零索引 |

**优势**：零 ETL、实时数据、完全保真
**挑战**：Token 扩展性、PB 级 I/O 延迟、评估指标缺失

### 五阶段对比总表

| 维度 | Naive | Advanced | Modular | Graph | Agentic |
|---|---|---|---|---|---|
| **核心流程** | 检索→生成 | 预处理→检索→后处理→生成 | 可插拔模块编排 | 图+文本混合检索 | Agent 自主决策 |
| **决策能力** | 无 | 无 | 预设路由 | 图关系推理 | **自主规划** |
| **灵活性** | 极低 | 低 | 高 | 中 | **极高** |
| **推理深度** | 单跳 | 单跳增强 | 多跳（编排） | 多跳（图遍历） | **多步+反思** |
| **典型框架** | Meta RAG | LlamaIndex | Haystack, LangFlow | MS GraphRAG | LangGraph, CrewAI |

---

## 三、核心技术深度解析

### 3.1 分块策略（Chunking）

分块是 RAG 第一步也是最重要的一步——分得不好，后续全白费。

| 策略                | 做法                     | 适用场景           | 注意事项              |
| ----------------- | ---------------------- | -------------- | ----------------- |
| **固定大小分块**        | 按 token 数切分，重叠 10-20%  | 通用，baseline    | 可能在句子中间截断         |
| **递归字符分割**        | 按段落→句子→词的优先级逐级切        | 通用，推荐 baseline | LangChain 默认方案    |
| **语义分块**          | 在 Embedding 相似度骤降处切分   | 叙述性文档          | 阈值需要仔细调           |
| **命题分块**          | 拆成原子事实命题               | 法律/金融等高密度文本    | 索引膨胀，成本高          |
| **句子窗口检索**        | 按句子索引，检索时带上下文窗口        | 精确检索+上下文       | 窗口大小需调            |
| **上下文块头（CCH）**    | 每个 chunk 前加 LLM 生成的描述头 | 结构化文档          | 索引成本增加            |
| **层级索引（RAPTOR）**  | 建摘要树：叶=chunk，父=LLM摘要   | "大局观"查询        | 构建维护成本高           |
| **Late Chunking** | 先 Embed 全文，再切 chunk    | 跨引用多的文档        | 需要特定 Embedding 模型 |

**2025 共识 baseline**：递归字符分割 + 上下文窗口检索，先跑通再加优化。

### 3.2 Embedding 模型

| 模型 | 维度 | 特点 |
|---|---|---|
| OpenAI text-embedding-3-small | 512/1536 | 性价比高，通用 |
| OpenAI text-embedding-3-large | 256/1024/3072 | 质量最高，贵 |
| BGE-M3 (BAAI) | 1024 | 开源旗舰，多语言+稀疏+稠密 |
| Jina Embeddings v3 | 1024 | 支持 Late Chunking，多语言 |
| Cohere Embed v3 | 1024 | 企业级，分类/聚类/检索不同模式 |
| E5-Mistral-7B | 4096 | LLM-based，质量高但慢 |

**选型建议**：通用场景 text-embedding-3-small 够用；中文优先 BGE-M3；需要 Late Chunking 选 Jina v3。

### 3.3 检索策略

```
检索策略
├── 稀疏检索（Sparse）：BM25, SPLADE
├── 稠密检索（Dense）：向量相似度（Cosine/Inner Product）
└── 混合检索（Hybrid）：稀疏 + 稠密 → RRF 融合 → Reranker
```

**混合检索**是当前生产环境的最佳实践：

```
Query → BM25 检索（关键词匹配）→ Top-N1 ┐
                                          ├→ RRF 融合 → Reranker → Top-K
Query → 稠密向量检索（语义匹配）→ Top-N2 ┘
```

实测提升：混合检索 + Reranker 相比纯向量检索，MRR 提升 15-20%。

### 3.4 Reranking（重排序）

检索阶段用高效的 Bi-Encoder 粗筛，Reranker 用更精准的 Cross-Encoder 精排。

| Reranker | 特点 |
|---|---|
| Cohere Rerank | API 服务，效果好，付费 |
| BGE-Reranker-v2 | 开源，中英文都好 |
| Jina Reranker v2 | 开源，多语言 |
| ColBERT | Token 级交互，精度高 |

**实践经验**：初检 Top-20~50 → Reranker 精排 Top-5~10，效果提升 20-40% 相关性。

### 3.5 HyDE（假设文档嵌入）

**论文**：Gao et al., "Precise Zero-Shot Dense Retrieval without Relevance Labels" (2022)

**核心思路**：用户查询通常很短（5-15 词），要匹配的文档很长（几百词），Embedding 空间不对称。HyDE 的做法是**让 LLM 先生成一个假设答案，再把答案 Embed 后去检索**。

```
传统：query "什么是async/await" → embedding → 检索
HyDE：query → LLM生成假答案 "async/await是Python异步编程语法..." → embedding → 检索
```

**效果**：MRR 提升 15-25%，尤其适合开放性问题。
**成本**：多加一次 LLM 调用，约 300ms 延迟。

**最佳实践**：`include_original=True`，同时用原查询和 HyDE 结果搜索。

### 3.6 Query Rewriting（查询改写）

| 技术 | 做法 | 适用场景 |
|---|---|---|
| Multi-Query | 生成 3-5 个语义变体，各自搜索后 RRF 合并 | 通用提升召回 |
| Step-Back Prompting | 抽象化查询（具体→通用原理） | 事实/法规类 |
| Query Decomposition | 拆复杂问题为原子子问题 | 对比/多实体/推理型 |
| RAG-Fusion | Multi-Query + RRF 融合重排 | 综合提升 |

### 3.7 Self-RAG（自反思 RAG）

**论文**：Asai et al., "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection" (2023)

**核心思想**：不是每次都检索，而是让模型自己判断是否需要检索、检索到的内容是否相关。

```
Query → 需要检索吗？
  ├─ 不需要 → 直接用参数知识生成
  └─ 需要 → 检索 → Critic评判相关性
        ├─ 相关 → 用检索内容生成
        └─ 不相关 → 不依赖检索内容生成
```

**特点**：最高精度的 RAG 方案之一，适合金融、医疗、法律等高可靠性场景。
**代价**：增加约 400ms 延迟和 2 次额外 LLM 调用。

### 3.8 CRAG（纠错式 RAG）

**论文**：Yan et al., "Corrective Retrieval Augmented Generation" (2024)

**核心思想**：引入评估 Agent，对每个检索到的文档打分，不相关的触发纠错动作（改写查询、Web 回退搜索等）。

```
检索 → 对每个文档打分（relevant/irrelevant）
  ├─ 全部或大部分相关 → 生成
  └─ 不相关或低质量 → 改写查询 → Web搜索 → 追加结果 → 生成
```

**CRAG 评分 0.824**，是生产环境中**性价比最高的方案**之一。建议用 LangGraph 实现。

---

## 四、评估体系

### 4.1 检索评估

| 指标 | 含义 |
|---|---|
| Recall@K | Top-K 结果中包含相关文档的比例 |
| Precision@K | Top-K 结果中相关文档的比例 |
| MRR (Mean Reciprocal Rank) | 第一个相关文档排名的倒数均值 |
| MAP (Mean Average Precision) | 多个查询的平均精度 |
| NDCG (Normalized DCG) | 考虑排序位置的相关性得分 |

### 4.2 生成评估

| 指标 | 含义 |
|---|---|
| Faithfulness（忠实度） | 答案是否基于检索到的文档，有无编造 |
| Answer Relevance | 答案是否回答了问题 |
| Context Precision | 检索到的文档是否精准 |
| Context Recall | 相关文档是否都被检索到 |

### 4.3 评估工具

| 工具 | 特点 |
|---|---|
| RAGAS | 开源 RAG 评估框架，Faithfulness/Relevance/Precision/Recall |
| TruLens | 可观测 + 评估，支持反馈函数 |
| DeepEval | 单元测试风格，CI/CD 集成 |
| ARAGOG | 2025 年新基准，高级 RAG 输出评分 |

### 4.4 主流基准

| 基准 | 内容 |
|---|---|
| BEIR | 多领域检索基准，18 个数据集 |
| HotpotQA | 多跳推理 QA |
| MultiHop-RAG | 多跳 RAG 专项基准 |
| LoCoMo10 | 长对话记忆基准（1,540 条） |
| mTRAG | 多轮对话 RAG（SemEval-2026） |

---

## 五、技术选型决策框架

| 你的场景 | 推荐方案 | 关键配置 |
|---|---|---|
| 快速搭建 MVP | Naive RAG + LlamaIndex | 固定分块 + OpenAI Embedding |
| 通用生产级 | Advanced RAG + 混合检索 + Reranker | 递归分块 + BM25+Dense + Cohere Rerank |
| 准确率有要求 | CRAG + Reranker + HyDE | LangGraph 实现纠错流程 |
| 高可靠性领域 | Self-RAG + CRAG + 混合检索 | 金融/医疗/法律场景 |
| 需要多跳推理 | Graph RAG 或 Graph-Based Agentic RAG | 知识图谱 + 向量检索混合 |
| 复杂多源查询 | Agentic Multi-Agent RAG | LangGraph + 多个专业检索 Agent |
| 实时/零ETL | In-Context Search | PageIndex 或 Sirchmunk |
| 多模态 | Multimodal RAG | CLIP + 文本 Embedding 混合 |

---

## 六、推荐学习路径

```
阶段 1（1天）：搞懂 Naive RAG
  ├─ 读：Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"
  │     NeurIPS 2020 | https://arxiv.org/abs/2005.11401
  ├─ 用 LlamaIndex 搭一个最小 RAG
  └─ 理解 Indexing → Retrieval → Generation 三阶段

阶段 2（2天）：掌握 Advanced RAG 关键技术
  ├─ 学分块策略（递归分割、语义分块）
  ├─ 学混合检索（BM25 + 稠密向量 + RRF）
  ├─ 学 Reranking（BGE-Reranker, Cohere Rerank）
  ├─ 读：Gao et al., "Precise Zero-Shot Dense Retrieval without Relevance Labels"
  │     2022 | https://arxiv.org/abs/2212.10496 （HyDE）
  └─ 学 Query Rewriting（Multi-Query / Step-Back / Decomposition）

阶段 3（2天）：理解模块化与评估
  ├─ 读：Gao et al., "Modular RAG: Transforming RAG Systems into LEGO-like Reconfigurable Frameworks"
  │     2024 | https://arxiv.org/abs/2312.10997
  ├─ 搭建 RAGAS 评估 pipeline
  └─ 对前两阶段的系统做定量评估

阶段 4（3天）：上手 Agentic RAG
  ├─ 读：Asai et al., "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection"
  │     2023 | https://arxiv.org/abs/2310.11511
  ├─ 读：Yan et al., "Corrective Retrieval Augmented Generation"
  │     2024 | https://arxiv.org/abs/2401.15884
  ├─ 读：Agentic RAG 综述 | https://huggingface.co/papers/2507.09477
  ├─ 用 LangGraph 实现 CRAG
  └─ 尝试 Self-RAG 和 Adaptive RAG，对比评估

阶段 5（按需）：前沿探索
  ├─ Graph RAG：读 Microsoft, "GraphRAG: Unlocking LLM Discovery on Narrative Private Data"
  │    2024 | https://arxiv.org/abs/2404.16130
  ├─ In-Context Search：跟 PageIndex/Sirchmunk 进展
  └─ Causal RAG："Beyond the Parameters" survey | https://arxiv.org/abs/2604.03174
```

---

## 七、关键资源

### 必读论文

| 论文 | 年份 | 贡献 | 链接 |
|------|------|------|------|
| Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" | 2020 | RAG 开山之作，Naive RAG | [arxiv.org/abs/2005.11401](https://arxiv.org/abs/2005.11401) |
| Gao et al., "Precise Zero-Shot Dense Retrieval without Relevance Labels" | 2022 | HyDE | [arxiv.org/abs/2212.10496](https://arxiv.org/abs/2212.10496) |
| Asai et al., "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection" | 2023 | 自我反思检索 | [arxiv.org/abs/2310.11511](https://arxiv.org/abs/2310.11511) |
| Yan et al., "Corrective Retrieval Augmented Generation" | 2024 | 纠错式 RAG | [arxiv.org/abs/2401.15884](https://arxiv.org/abs/2401.15884) |
| Gao et al., "Modular RAG: Transforming RAG Systems into LEGO-like Reconfigurable Frameworks" | 2024 | 模块化 RAG 范式 | [arxiv.org/abs/2312.10997](https://arxiv.org/abs/2312.10997) |
| Microsoft, "GraphRAG: Unlocking LLM Discovery on Narrative Private Data" | 2024 | 图 RAG | [arxiv.org/abs/2404.16130](https://arxiv.org/abs/2404.16130) |
| Agentic RAG Survey (多篇综述汇总) | 2024-2025 | Agentic RAG 综述 | [huggingface.co/papers/2507.09477](https://huggingface.co/papers/2507.09477) |

### 框架与工具

| 框架 | 定位 |
|---|---|
| LlamaIndex | 数据索引 + RAG 全栈框架 |
| LangChain | RAG Chain 编排 |
| LangGraph | Agentic RAG 状态图编排 |
| Haystack | 模块化 RAG Pipeline |
| RAGAS | RAG 评估 |
| Chroma / Qdrant / Milvus | 向量数据库 |

### 相关概念

- [[concepts/context-database]] — 上下文数据库，RAG 的下一代进化
- [[concepts/agent-memory]] — Agent 记忆机制
- [[entities/openviking]] — OpenViking 上下文数据库
- [[entities/qmd]] — 本地混合搜索引擎

Sources:
- [Modular RAG Paper (Gao et al., 2024)](https://arxiv.org/abs/2312.10997)
- [Self-RAG Paper (Asai et al., 2023)](https://arxiv.org/abs/2310.11511)
- [CRAG Paper (Yan et al., 2024)](https://arxiv.org/abs/2401.15884)
- [HyDE Paper (Gao et al., 2022)](https://arxiv.org/abs/2212.10496)
- [From Vectors to Knowledge Graphs Survey (2026)](https://www.sciencedirect.com/science/article/abs/pii/S1574013726000341)
- [Beyond the Parameters Survey (arXiv, 2026)](https://arxiv.org/html/2604.03174v1)
- [Agentic RAG Survey (2025)](https://huggingface.co/papers/2507.09477)
