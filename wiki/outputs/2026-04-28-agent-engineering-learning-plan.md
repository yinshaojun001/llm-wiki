---
title: Agent 工程一年转型学习计划
tags: [agent-engineering, learning-plan, career]
date: 2026-04-28
updated: 2026-04-28
---

## 适用人群

本科毕业七年 Java 工程师，无 ML 背景，目标是转型 Agent 开发工程师。

**核心定位**：Agent 工程师不是造模型的，是用模型的。你需要的是"发动机工作原理"级别而非"冶金学"级别。会用 Java 类比理解数据流，不需要手推梯度。

Agent 本质 = LLM + Memory + Planning + Tool Use。

---

## 一、不易变化的基础知识（贯穿全年）

这些是无论上层框架如何更迭都会用到的核心原理，优先级最高。

### 1.1 Transformer 与 Attention 机制

- **Self-Attention**：每个词根据与所有其他词的相关性，动态重新加权自己的表示。Java 类比——动态加权路由：每个请求（Query）根据与处理器（Key）的匹配度，聚合响应（Value）
- **Multi-Head**：多个并行的关注通道，就像同时从语法、性能、安全性多个维度理解代码
- **Residual Connection**：类似 try-catch 的 finally 块——原始信息总能绕过中间层传过去
- **Decoder-Only 架构**（GPT 系）：自回归生成，逐 token 出字
- **KV Cache**：缓存已算过的 Key/Value，空间换时间——类似 Redis 缓存数据库查询结果
- **Context Window 退化**：长上下文"IQ 衰减"，128K 窗口实际可靠的可能只有 32K

> 资源：3Blue1Brown "Attention in transformers"（26min 动画）→ Jay Alammar "The Illustrated Transformer" → Karpathy "Let's build GPT from scratch"（2h）

### 1.2 Prompt Engineering 基础

- **In-Context Learning**：为什么给几个例子模型就能照做——本质是 Attention 在示例和目标间建立了关联
- **Chain-of-Thought（CoT）**：让模型展示推理步骤，类似让你 code review 时说出思路
- **ReAct**：Reasoning + Acting，Agent 最核心的范式——思考 → 行动 → 观察 → 再思考
- **结构化输出**：JSON Mode、Function Calling 协议——让 LLM 返回机器可解析的结果

### 1.3 RAG（检索增强生成）原理

- **分块策略**：固定大小、语义分块、递归分块——就像数据库的分区策略
- **向量检索**：余弦相似度、ANN（近似最近邻）——空间换精度
- **混合检索**：关键词 BM25 + 向量检索 + 重排序——多路召回 + 精排，和搜索引擎一样
- **检索质量**：Recall（找全了吗）、Precision（找对了吗）、MRR（排对了吗）

### 1.4 Function Calling / Tool Use 协议

- OpenAI Function Calling 格式是事实标准
- MCP（Model Context Protocol）：工具网关协议，解耦 Agent 和工具
- 工具 schema 设计决定 Agent 的选择质量——描述写得不好，Agent 就不知道什么时候该用什么

### 1.5 Agent 评估方法

- **LLM-as-a-Judge**：用 LLM 评估 LLM 输出，不是玄学，是有量化标准的
- **行为测试**：不是测输出，是测推理路径和工具选择是否正确
- **Golden Test Set**：30-200 个精选用例，每次变更都跑
- **关键指标**：目标成功率、工具选择准确率、幻觉率、延迟 p95

---

## 二、学习计划：12 个月四阶段

---

### 第 1-3 个月：原理筑基

**目标**：理解 LLM 底层运行机制，能调用 API，能写高质量 Prompt，能搭简单 RAG。
**每周投入**：10-12h（工作日 3 天 × 1.5h + 周末 4h）

---

#### 第 1-2 周：Transformer 原理

**学什么**：文本进去 → token 化 → 向量 → 多层 Attention → 输出，这中间每一步发生了什么。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | 先看动画，别碰论文 | 3Blue1Brown "Attention in transformers"（B站/YouTube, 26min）→ Jay Alammar "The Illustrated Transformer"（每个步骤有图） |
| 3-4 | 跑代码，别手写 | `pip install transformers`，加载 gpt2，看 tokenization 到底做了什么，跑一个 forward pass |
| 5 | nanoGPT 实验 | Karpathy 的 nanoGPT，只读 `model.py` 里 `CausalSelfAttention` 这个类（~50 行），理解 `q @ k.transpose` 在做什么 |
| 6-7 | 用 Java 类比消化 | Self-Attention ≈ 动态加权路由；Multi-Head ≈ 多维度审查；Residual ≈ finally 块；Positional Encoding ≈ 数组索引 |

**Java 类比速查**：

| Transformer 概念 | Java 类比 |
|---|---|
| Self-Attention | 动态加权路由——每个请求（Q）与所有处理器（K）匹配，聚合响应（V） |
| Multi-Head Attention | 多个并行线程同时检查代码的不同方面（语法、性能、安全） |
| Residual Connection | try-catch 的 finally 块——原始信息总能传过去 |
| Layer Normalization | 数据归一化，类似把不同量纲的指标统一到同一尺度 |
| Positional Encoding | 数组索引——模型不知道顺序，需要手动注入位置信息 |
| KV Cache | Redis 缓存——算过的 Key/Value 不重复算 |
| Tokenization (BPE) | 类似字符串的 `split()`，但按常见子词模式切分 |

**产出**：一个 Jupyter Notebook，用 gpt2 加载、分词、生成文本，每个步骤有注释。

**过关标准**（能口头回答）：
1. 一段文本进 Transformer 经过了哪些步骤？
2. 为什么 GPT 是一个 token 一个 token 出字的？
3. Context Window 从 4K 涨到 128K，代价是什么？

**一定不要**：
- ❌ 读《Attention Is All You Need》原论文（写给研究者的）
- ❌ 手推 softmax 梯度（Agent 工程师不写反向传播）
- ❌ 从零实现完整 Transformer（放到以后有兴趣再说）
- ❌ 纠结"头数为什么是 8 不是 16"（炼丹师的事）

---

#### 第 3-4 周：LLM API 与 Prompt Engineering

**学什么**：调用 OpenAI/Anthropic API，写出能控制模型行为的 System Prompt，掌握 CoT 和 Few-shot。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | API 基础 | 注册 OpenAI/Anthropic，跑通第一个 API 调用。理解三个核心参数：`model`（用什么）、`temperature`（多大胆）、`max_tokens`（说多少） |
| 3-4 | System Prompt 设计 | 给模型设定角色、行为边界、输出格式。实验：同一个问题用不同 system prompt，对比输出差异 |
| 5 | Chain-of-Thought | 在 Prompt 里加一句"Let's think step by step"，观察推理质量的变化。理解为什么展示推理过程有效 |
| 6-7 | Few-shot + 结构化输出 | 给 2-3 个示例让模型模仿，用 JSON Mode 让模型返回可解析结果 |

**Java 类比**：
- System Prompt ≈ 接口规范/JavaDoc——定义契约，模型按契约输出
- Few-shot ≈ 单元测试的 Given-When-Then 示例——给几个样板，让模型照做
- Temperature ≈ 控制"创造力"的开关——0 = 严格按规范（生产代码），1 = 允许变体（创意命名）

**产出**：一个命令行聊天工具（Python ~100 行），支持 System Prompt 配置、对话历史、JSON 输出模式。

**过关标准**：
1. 能写出让模型"只返回 JSON，不废话"的 System Prompt
2. 能用 2-3 个 Few-shot 示例让模型完成特定格式输出
3. 知道 temperature=0 和 temperature=1 的区别和各自适用场景

**一定不要**：
- ❌ 花大量时间"调 Prompt 玩"（没有评估的调优是玄学）
- ❌ 学各种"Prompt 模板库"（模板会过时，理解为什么有效才持久）

---

#### 第 5-6 周：Embedding 与向量检索

**学什么**：文本怎么变成向量，向量怎么存怎么搜，为什么语义相近的文本在向量空间里也近。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | Embedding 原理 | 用 OpenAI `text-embedding-3-small` 把文本变成向量，观察"相似的句子 → 相似的向量" |
| 3-4 | Chroma 入门 | `pip install chromadb`，把 100 篇文档 embedding 后存进去，用自然语言搜索 |
| 5-6 | 语义相似度 | 余弦相似度计算、Top-K 检索、可视化（PCA 降维看 2D 聚类） |
| 7 | 理解局限 | 故意搜一些会被关键词误导的查询，体会"纯关键词搜索"和"语义搜索"的差异 |

**Java 类比**：
- Embedding ≈ 把一个 Java 对象序列化成 `double[768]`，相似对象的数组值也比较接近
- 向量检索 ≈ 给一个对象找最相似的 N 个对象——类比 `Stream.sorted(Comparator.comparing(Obj::similarity)).limit(K)`
- ANN ≈ HashMap 的 O(1) 近似版——用精度换速度

**产出**：一个命令行工具，把任意文件夹里的 txt/md 文件建索引，支持自然语言搜索，返回 Top-5 结果+相似度分数。

**过关标准**：
1. 能解释"向量检索"和"数据库 LIKE 查询"的本质区别
2. 知道余弦相似度怎么算（不要求手算，能描述就行）
3. 能说出 ANN 和精确 KNN 的取舍

**一定不要**：
- ❌ 纠结 Embedding 模型的训练原理（你用它，不训练它）
- ❌ 过早学 Milvus/Pinecone（Chroma 本地跑通再升级）

---

#### 第 7-8 周：RAG 基础

**学什么**：把向量检索接到 LLM 上，让模型能回答"它没学过"的知识。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | Naive RAG | 用户提问 → embedding → 检索 Top-K → 拼到 Prompt 里 → LLM 回答。跑通最小闭环 |
| 3-4 | 分块策略 | 同一份 PDF，用 128/256/512/1024 token 不同大小分块，对比检索质量。理解"块太大稀释精度，块太小丢失上下文" |
| 5-6 | 混合检索 + Reranking | BM25 关键词检索 + 向量语义检索 → 融合结果 → Cohere/Jina Reranker 精排 |
| 7 | 引用溯源 | 让 LLM 回答时注明信息来源（哪个文档的哪一段），不瞎编 |

**Java 类比**：
- RAG ≈ 给一个没参与项目的新同事一份代码库索引，他先搜再回答，而不是全靠记忆
- Chunking ≈ 数据库分页——太大一次查太多无关数据，太小需要多次 round-trip
- Reranking ≈ SQL 的 `ORDER BY relevance DESC` 但 relevance 由专门模型计算

**产出**：一个能回答 PDF/文档内容的 RAG 应用（命令行或 Gradio 界面），每一句回答带引用来源。

**过关标准**：
1. 能解释 RAG 和"直接把文档塞进 Context Window"的区别
2. 知道什么时候该用 RAG、什么时候该用长上下文模型
3. 能说出三种分块策略的适用场景

**一定不要**：
- ❌ 追求"完美分块"（没有银弹，取决于文档类型）
- ❌ 把 RAG 当万能药（大量文档 = 用 RAG，少量文档 = 直接放 context window）

---

#### 第 9-10 周：Function Calling

**学什么**：让 LLM 不只是"说"，还能"做"——调用外部 API、查数据库、执行代码。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | 第一个 Tool | 定义一个 `get_weather(city)` 工具，让 LLM 在用户问天气时自动调用 |
| 3-4 | 多工具选择 | 同时给 5 个工具（天气、搜索、计算器、时间、汇率），看 LLM 怎么选 |
| 5-6 | Schema 设计 | 同一功能写三版 tool description，对比 LLM 的选择准确率——理解 schema 质量决定工具调用质量 |
| 7 | 错误处理 | 工具调用失败时 LLM 怎么恢复——重试、换工具、告诉用户 |

**Java 类比**：
- Function Calling ≈ 接口定义——定义方法签名（name + parameters + description），LLM 决定何时调用哪个
- Tool Schema ≈ REST API 文档——写得好，调用方自然用对；写得差，调用方猜错
- 错误恢复 ≈ try-catch + fallback——调用失败不崩溃，换策略继续

**产出**：一个带 5+ 工具的 Agent，能查天气、搜索网页、计算、查时间、换算汇率。

**过关标准**：
1. 能写出让 LLM 准确选择正确工具的 tool description
2. 理解 tool calling 的完整流程：LLM 输出 tool_call → 你的代码执行 → 结果返回 LLM → LLM 继续推理
3. 处理过工具调用失败的情况

**一定不要**：
- ❌ 认为工具越多越好（工具越多，选错概率越大）

---

#### 第 11-12 周：Agent 基础范式 — ReAct

**学什么**：把 Prompt + RAG + Function Calling 串起来，跑通完整的 Agent 循环。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-3 | ReAct 循环 | 手写 ReAct 循环（不用框架）：Thought → Action → Observation → Thought... 直到 Final Answer |
| 4-5 | 用框架实现 | 同一个任务用 OpenAI Agents SDK 实现，对比手写版 |
| 6-7 | 综合 Demo | 做一个能"用户提一个复杂问题 → Agent 搜索信息 → 调用工具 → 多步推理 → 给出答案"的完整 Demo |

**Java 类比**：
- ReAct 循环 ≈ `while (!taskComplete) { think(); act(); observe(); }`——一个带反馈的 while 循环
- Agent 状态 ≈ 状态机——每个 Observation 都可能改变状态并决定下一个 Action

**产出**：一个完整的 ReAct Agent（命令行），能处理多步推理任务（如"查一下旧金山今天的天气，换算成摄氏度，和北京对比"）。

**过关标准**：
1. 能画出 ReAct 循环的完整流程图
2. 知道 Agent 在哪个步骤最容易出问题（工具调用失败）
3. 手写版和框架版都写过

**一定不要**：
- ❌ 上来就用 LangChain 全套（先手写理解本质，再上框架）

---

### 第 4-6 个月：组件深入

**目标**：掌握 Agent 四大核心组件的实现，能独立设计 Agent 系统。

---

#### 第 13-14 周：Memory 系统

**学什么**：让 Agent 记住对话历史、用户偏好、长期知识——不只是"刚才说了什么"。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | 短期记忆 | Context Window 管理——对话历史太长怎么办？滚动窗口 vs 摘要压缩 |
| 3-4 | 工作记忆 | 在当前任务中维护 scratchpad——Agent 边做边记中间结果 |
| 5-6 | 长期记忆 | 用 Chroma 存用户偏好和知识，下次对话自动检索相关记忆 |
| 7 | 记忆管理 | 不是无限堆积——实现简单的"遗忘"逻辑（按时间衰减、按重要性保留） |

**Java 类比**：
- 短期记忆 ≈ 本地变量（出了作用域就没了）
- 工作记忆 ≈ ThreadLocal（当前任务独享）
- 长期记忆 ≈ 数据库（持久化，按需查询）
- 记忆衰减 ≈ LRU Cache 淘汰策略

**产出**：一个带三层记忆的 Agent——记得当前对话、当前任务状态、历史偏好。

**过关标准**：
1. 能画出三层记忆的数据流图
2. 知道什么时候该压缩、什么时候该检索、什么时候该遗忘
3. 理解 Session 外部化（append-only event log）和 context window 管理是两件事

**一定不要**：
- ❌ 试图记住一切（记忆管理的核心是"选择性地忘"）

---

#### 第 15-16 周：Planning 策略

**学什么**：Agent 不只是"想一步做一步"，还能先制定完整计划再执行。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | ReAct 回顾 + Plan-and-Solve | 同一个任务，对比"边想边做"（ReAct）和"先列步骤再做"（P&S） |
| 3-4 | Tree-of-Thoughts | 每一步探索 2-3 种方案，选最优的继续——理解"搜索空间"概念 |
| 5-6 | Reflexion | Agent 执行出错后自我反思："我刚才哪里做错了？下次怎么避免？" |
| 7 | 策略对比 | 同一个复杂任务用三种策略跑，记录步骤数、准确率、耗时 |

**Java 类比**：
- Plan-and-Solve ≈ 先设计再编码（瀑布模型）
- ReAct ≈ 敏捷开发（迭代循环，边做边调整）
- Tree-of-Thoughts ≈ 每个技术决策建 POC，选最优方案推进
- Reflexion ≈ 事故复盘——出了 bug 写 postmortem，下次不犯同样的错

**产出**：一个能跑 ReAct / Plan-and-Solve / Reflexion 三种策略的实验框架 + 对比报告。

**过关标准**：
1. 知道什么时候用 ReAct（简单任务），什么时候用 Plan-and-Solve（多步任务）
2. 理解 Reflexion 和普通 retry 的区别（Reflexion 会改变策略，retry 只是重复）
3. 能说出 Planning 的主要代价（token 消耗、延迟）

**一定不要**：
- ❌ 所有任务都用 Plan-and-Solve（简单任务过度规划浪费 token）
- ❌ 认为 Planning 越复杂越好（实用 > 炫技）

---

#### 第 17-18 周：Tool Use 工程

**学什么**：工具系统的工程化——不只是定义 schema，还要考虑安全、可靠性、可扩展。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | 工具 Schema 设计规范 | 研究 OpenAI/Anthropic 官方工具示例，总结"好 schema"的共性 |
| 3-4 | 风险分级 | 只读（读文件/查数据库）→ 读取+过滤（搜索）→ 写入（创建文件）→ 高风险（发邮件/部署/支付） |
| 5-6 | MCP 协议 | 搭建一个 MCP Server，让 Agent 通过 MCP 调用工具——解耦 Agent 和工具 |
| 7 | 沙箱执行 | Docker 沙箱内执行 Agent 生成的代码，限制网络/文件系统/进程 |

**Java 类比**：
- 风险分级 ≈ 权限系统——读权限、写权限、管理员权限，每层有审批流程
- MCP ≈ Service Mesh——服务间通信标准化，工具提供方和消费方解耦
- 沙箱 ≈ JVM SecurityManager——限制代码的执行边界

**产出**：一个 8+ 工具的工具箱，含风险分级、MCP Server 接入、沙箱执行（简单代码）。

**过关标准**：
1. 能写出"让 LLM 高概率选对工具"的 schema
2. 理解工具安全分级模型
3. 跑通过 MCP Server + Agent 的端到端调用

---

#### 第 19-20 周：多 Agent 协作

**学什么**：多个 Agent 协同工作——一个 Agent 是细胞，多 Agent 才是组织。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | Orchestrator 模式 | 一个主 Agent 分派任务给 2-3 个子 Agent，收集结果，合并回答 |
| 3-4 | Handoff 模式 | Agent A 做完一部分，把上下文移交给 Agent B 继续——类似客服转接专家 |
| 5-6 | Debate 模式 | 两个 Agent 各出一个方案，第三个 Agent 评判选出更好的 |
| 7 | 设计你的多 Agent 系统 | 一个完整 Demo：研究员 Agent 收集信息 → 分析师 Agent 处理数据 → 写手 Agent 出报告 |

**Java 类比**：
- Orchestrator ≈ 微服务的 API Gateway——统一入口，路由分发，聚合响应
- Handoff ≈ 责任链模式——一个 Handler 做完交给下一个
- Debate ≈ Code Review 多人评审——多视角降低错误概率

**产出**：一个 3 Agent 协作的 Demo（研究员→分析师→写手）。

**过关标准**：
1. 知道什么时候用单 Agent，什么时候需要多 Agent
2. 理解多 Agent 的核心成本（token 消耗翻倍、协调开销、结果不一致）
3. 能设计 Agent 间的通信协议（传什么、不传什么）

**一定不要**：
- ❌ 简单任务用多 Agent（过度设计，token 消耗翻 3 倍效果没提升）
- ❌ 让子 Agent 有不受限的 session 管理权限

---

#### 第 21-22 周：框架对比实战

**学什么**：同一个任务用三个主流框架各实现一遍，建立技术选型判断力。

**怎么学**（10-12h）：

| 天 | 内容 |
|---|---|
| 1 | OpenAI Agents SDK 实现——感受"极简原语" |
| 2-3 | CrewAI 实现——感受"角色扮演 + kickoff()" |
| 4-6 | LangGraph 实现——感受"图 + 状态机 + 检查点" |
| 7 | 写对比报告：学习曲线、灵活性、调试体验、生产就绪度 |

**选型速查**：

| 场景 | 推荐 | 原因 |
|---|---|---|
| 快速 Demo，1 天出活 | CrewAI | `kickoff()` 一键跑 |
| OpenAI 全家桶，快速投产 | OpenAI Agents SDK | 零学习成本 |
| 复杂工作流，审计合规 | LangGraph | 检查点、回滚、人在回路 |
| 多 Agent 研究实验 | AutoGen | 对话驱动，灵活 |

**产出**：三份"同一个任务"的代码 + 一份框架对比笔记。

---

#### 第 23-24 周：安全与护栏

**学什么**：Agent 不只是要能干，还要不乱干——输入过滤、输出审查、人在回路。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | Input Guardrail | 实现 Prompt 注入检测——用户输入里藏"忽略之前的指令"，Agent 能被骗吗？ |
| 3-4 | Output Guardrail | LLM 输出后的内容审核——敏感信息、幻觉检测、格式校验 |
| 5-6 | Human-in-the-Loop | 实现"高危操作需要人工确认"——Agent 提议删文件，等用户确认后才执行 |
| 7 | 循环/超限检测 | Agent 陷入死循环（反复调同一个工具）→ 自动熔断 |

**Java 类比**：
- Input Guardrail ≈ Web 应用的 XSS/SQL 注入防护——用户输入不可信
- Output Guardrail ≈ 后端 API Response Validation——返回给前端前检查一遍
- Human-in-the-Loop ≈ 审批流程——高风险操作需要 manager approve
- 熔断 ≈ Hystrix/Sentinel——调用失败率达到阈值自动熔断

**产出**：一个带四层防护（输入→执行→输出→熔断）的 Agent 框架。

**过关标准**：
1. 能说出 Agent 安全的四道防线
2. 跑过一个 Prompt 注入攻击并成功拦截
3. 理解 Human-in-the-Loop 的工程开销和不可替代的价值

---

### 第 7-9 个月：应用开发

**目标**：能独立交付生产可用的 Agent 应用。每个月一个完整项目。

---

#### 第 25-26 周：Agent 评估体系

**学什么**：不是"感觉 Agent 变差了"，而是用数据量化——这是从 Demo 到生产的门槛。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | Golden Test Set | 手工创建 20-30 个典型用例，覆盖正常路径 + 边界情况 + 容易出错的 case |
| 3-4 | LLM-as-a-Judge | 用另一个 LLM 给 Agent 的回答打分（正确性、完整性、是否有幻觉） |
| 5-6 | Ragas 评估框架 | 用 Ragas 量化 RAG 质量：Faithfulness（忠于原文吗）、Answer Relevancy（答到点上了吗）、Context Precision（检索精准吗） |
| 7 | 持续回归 | 脚本化——每次改 Prompt/换模型/改分块策略后，自动跑全量评估，出对比报告 |

**Java 类比**：
- Golden Test Set ≈ 回归测试套件——每次提交跑一遍
- LLM-as-a-Judge ≈ Code Review——另一个"审查者"判断质量
- 评估 Pipeline ≈ CI/CD 流水线的 test stage——不通过不发版

**产出**：一套自动化评估 Pipeline，30+ 用例，每次变更一键出报告。

**过关标准**：
1. 能用 3 个以上维度（正确性、完整性、幻觉率）评估 Agent 输出
2. 理解 LLM-as-a-Judge 的局限性（Judge 也会有偏见）
3. 评估报告能说清楚"这次变更变好了还是变差了"

**一定不要**：
- ❌ 用 vibe check（"感觉还行"）代替量化评估
- ❌ 做太多评估维度（超过 5 个会疲劳，聚焦业务相关指标）

---

#### 第 27-28 周：可观测性

**学什么**：Agent 在做什么、花了多少钱、为什么出错——全链路可视化。

**怎么学**（10-12h）：

| 天 | 内容 | 方法 |
|---|---|---|
| 1-2 | OpenTelemetry 基础 | 理解 Trace / Span / Attribute——给 Agent 的每一步打上追踪标签 |
| 3-4 | Langfuse 接入 | 把 Agent 的所有 LLM 调用、工具调用、检索结果接入 Langfuse 面板 |
| 5-6 | 成本追踪 | 按任务/用户/session 拆分 Token 消耗，计算单次任务成本 |
| 7 | 告警规则 | 延迟超过阈值、Token 消耗异常飙升、工具调用失败率上升 → 自动告警 |

**Java 类比**：
- Trace ≈ 分布式链路追踪（一个请求经过多个微服务的完整路径）
- Span ≈ 链路中的一个步骤（一次 RPC 调用）
- Langfuse ≈ Grafana + Prometheus——仪表盘 + 监控 + 告警

**产出**：全链路追踪面板，能看到每次 Agent 调用的完整轨迹 + Token 消耗 + 工具调用链。

**过关标准**：
1. 能根据 Trace 定位 Agent 在哪一步出错
2. 能算出单次任务的成本
3. 知道 p50 和 p95 延迟的区别和各自意义

---

#### 第 29-30 周：项目 1 — 个人效率 Agent

**做什么**：一个集成日历 + 邮件 + 简单记忆的个人 AI 助理。

**关键功能**：
- 自然语言查询"下周二的会议"
- 自动发邮件、读新邮件摘要
- 记住你的偏好（"以后所有会议提醒提前 10 分钟"）

**技术栈**：OpenAI Agents SDK + Gmail API + Google Calendar API + Chroma 记忆

---

#### 第 31-32 周：项目 2 — 垂直领域 RAG Agent

**做什么**：一个面向特定行业的文档问答 Agent（客服/法律/技术文档）。

**关键功能**：
- 上传行业文档建知识库
- 自然语言提问，Agent 搜文档回答 + 引用原文出处
- 处理"我不确定"的情况——找不到相关信息时诚实地说不确定，不瞎编

**技术栈**：LangChain/LlamaIndex + Chroma/Milvus + Reranker + 引用溯源

---

#### 第 33-34 周：项目 3 — 代码 Agent

**做什么**：一个能读代码库、定位 Bug、提议修复的 Agent。

**关键功能**：
- 理解项目结构（读目录树和关键文件）
- 根据 Bug 描述定位相关代码
- 生成修复方案（diff 格式）
- （可选）Docker 沙箱里执行测试，验证修复

**技术栈**：LangGraph + Docker SDK + GitPython

---

#### 第 35-36 周：项目 4 — 复杂工作流 Agent

**做什么**：10+ 步骤、有分支和条件判断的业务流程 Agent——如电商订单处理（接单→验库存→计算运费→生成发票→通知仓库→追踪物流）。

**关键功能**：
- 条件分支（有库存 / 无库存处理逻辑不同）
- 断点恢复（执行到第 7 步挂了，重启后从第 7 步继续）
- 人在回路（超过 ¥10,000 的订单需人工审核）
- 并行执行（同时查库存和计算运费）

**技术栈**：LangGraph（状态机 + Checkpoint）+ FastAPI + Redis

---

### 第 10-12 个月：落地与生产化

**目标**：掌握从 POC 到 Production 的完整链路，建立求职 Portfolio。

---

#### 第 37-38 周：生产架构设计

| 天 | 内容 |
|---|---|
| 1-2 | 模型路由——多模型切换架构（大模型做推理、小模型做分类），不绑死一个供应商 |
| 3-4 | 服务化部署——FastAPI 封装 Agent，Docker 化，健康检查 + 优雅关闭 |
| 5-6 | 自动扩缩容——Agent 任务入队，Worker 按需扩容（K8s HPA 或 Serverless） |
| 7 | 画出你的生产架构图（用 draw.io 或 Excalidraw） |

**产出**：一张生产级 Agent 服务架构图 + Docker Compose 一键启动方案。

---

#### 第 39-40 周：渐进式发布

| 阶段 | 内容 |
|---|---|
| Sandbox | 内部测试，用历史 case + 合成数据验证 |
| Shadow Mode | Agent 静默跑在真实流量旁，不对外暴露，只收集 trace 和对比 |
| Canary | 1% 用户先体验，对比 Agent 处理结果和人工处理结果 |
| 渐进放量 | 5% → 25% → 100%，每个阶段所有质量门禁都绿才推进 |
| 回滚 | 每个阶段都有可执行的回滚方案，不只是一个文档 |

**产出**：一份可执行的渐进发布方案文档 + 回滚操作手册。

---

#### 第 41-42 周：成本优化

| 天 | 内容 |
|---|---|
| 1-2 | Token 预算——按任务复杂度分级设置 token 上限 |
| 3-4 | SLM 替代——简单任务（分类、摘要）用小模型（GPT-4o-mini / Claude Haiku），只有核心推理用大模型 |
| 5-6 | Prompt Caching——Anthropic/OpenAI 的 cache 机制，重复的 system prompt 不再重复计费 |
| 7 | 成本实验报告——同一个任务用不同策略，对比成本差异（预计可降 50-70%） |

**产出**：成本优化方案 + 50% 以上成本降低的实验数据。

---

#### 第 43-44 周：安全合规

| 天 | 内容 |
|---|---|
| 1-2 | PII 脱敏——用户输入里的手机号/身份证/银行卡号自动识别和脱敏 |
| 3-4 | 审计日志——谁、什么时候、触发 Agent 做了什么、结果如何，不可篡改 |
| 5-6 | 权限最小化——Agent 只有完成当前任务所需的最小权限，每次任务单独申请短期凭证 |
| 7 | Prompt 防火墙——部署专门的注入检测模型，拦截恶意 prompt |

**产出**：安全合规清单 + 审计日志实现 + PII 脱敏模块。

---

#### 第 45-46 周：多 Agent 生产系统

**做什么**：把之前的多 Agent Demo 升级为生产级——加入 session 管理、可观测性、渐进发布、熔断。

**产出**：一个企业级多 Agent 系统 Demo。

---

#### 第 47-48 周：综合 Portfolio 项目

**做什么**：自选一个真实业务场景，从 0 到生产交付完整 Agent 系统。建议选你熟悉的 58 业务场景。

**要求**：
- 含完整的评估体系（Golden Test Set + LLM-as-Judge）
- 含全链路可观测性
- 含安全护栏
- 有成本分析
- 有系统架构图
- 能 Demo 给面试官

**产出**：Portfolio 项目（GitHub 开源仓库 + 技术博客 + Demo 视频）。

---

#### 第 49-50 周：前沿追踪与补缺

| 天 | 内容 |
|---|---|
| 1-3 | 读 3-5 篇 2026 顶会/热门论文，写笔记 |
| 4-5 | 回顾 12 个月的学习笔记，标记还不扎实的部分补学 |
| 6-7 | 探索 1 个你感兴趣的前沿方向（Agentic RAG、Memory 新范式、多 Agent 协议） |

---

#### 第 51-52 周：面试准备

| 天 | 内容 |
|---|---|
| 1-2 | System Design — Agent 系统设计题（"设计一个 XX Agent 系统"） |
| 3-4 | Portfolio 打磨 — 代码仓库 README、架构图、Demo 视频 |
| 5-6 | 技术博客输出 — 把你最有心得的一个 topic 写成文章（效果比简历强 10 倍） |
| 7 | 模拟面试 |

---

## 三、核心技术栈一览

```
语言：Python（首选，>78% Agent 生态）+ TypeScript（前端/全栈 Agent）
API：OpenAI API / Anthropic API
框架：OpenAI Agents SDK → LangGraph（主力）
向量数据库：Chroma（入门）→ Milvus（生产）
RAG：LlamaIndex / LangChain
评估：Ragas / LangSmith / Braintrust
可观测性：Langfuse / OpenTelemetry
部署：FastAPI + Docker + K8s
协议：MCP（工具接入）/ A2A（Agent 间通信）
```

---

## 四、关键思维转变

| 传统开发 | Agent 开发 |
|---|---|
| 构建功能确定的程序 | 构建能自主规划与行动的系统 |
| 输入→处理→输出（确定性） | 感知→规划→行动→观察（动态循环） |
| 不确定性视为 Bug | 不确定性视为环境属性，用反思和纠错应对 |
| 开发者预定义逻辑 | 开发者定义目标和约束边界 |
| 测试输出是否正确 | 测试推理路径 + 工具选择 + 行为 |
| 一次性上线 | Shadow → Canary → 渐进放量 |
| 性能优化靠 Profile | 性能优化靠模型路由 + KV Cache + Token 预算 |

---

## 五、每周时间建议

- **学习时间**：每周 10-12 小时（工作日 3 天 × 1.5h + 周末一天 4h + 另一天自由）
- **每个产出**：可运行的代码仓库 + 一篇笔记总结
- **月度复盘**：对比月初目标，调整下月重点
- **时间分配**：60% 动手写代码，30% 读文档/看视频，10% 总结输出

---

## 六、推荐持续追踪的信息源

- **Newsletter**：The Sequence、Latent Space、Anthropic Research Blog
- **社区**：LangChain Discord、Hugging Face
- **论文追踪**：arXiv cs.AI / cs.CL
- **GitHub 项目**：llm-systems-engineering-roadmap、ai-engineering-bootcamp、agentic-frameworks

---

## 七、最重要的 3 条原则

1. **构建产出物，而非囤积观点**——每个阶段产出可演示的代码、评估报告或架构图
2. **评估一切**——不要相信单个 prompt、Demo 或 benchmark，用 evals、traces、失败分类来决策
3. **学机制，不学名字**——模型名和框架名会过时，机制（Attention、Memory、Planning）持续复利

---

## 八、每个阶段的"一定不要"

| 阶段 | 不要做的事 |
|---|---|
| 原理筑基 | 不要读原论文、不要手推梯度、不要纠结模型细节参数 |
| 组件深入 | 不要过早用复杂框架（先手写理解本质）、不要所有任务都用多 Agent |
| 应用开发 | 不要用 vibe check 代替量化评估、不要跳过可观测性 |
| 落地生产化 | 不要一次性上线、不要跳过审计日志、不要过度设计（先跑通再优化） |

---

> 一年后你的核心竞争力 = LLM 系统思维 × 工程化能力 × 业务场景理解。这个领域正在从"模型调优"转向"系统设计与业务融合"，你七年的 Java 工程经验恰恰是这个阶段最稀缺的——知道怎么做可靠的系统、怎么监控、怎么发布、怎么处理异常。这些在 Agent 时代全部复用。
