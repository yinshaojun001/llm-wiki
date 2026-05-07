# Wiki Index

> 所有页面的目录，每次摄入后更新。

---

## Concepts（概念）

### AI Agent & Web
- [[concepts/seo]] — 传统搜索引擎优化，Agent 时代之前 Web 可发现性的主导范式
- [[concepts/agentic-web]] — Agent 成为 Web 原生参与者，不只是"使用"Web
- [[concepts/agent-first]] — 网站同时为人类和 AI agent 设计的策略
- [[concepts/structured-data]] — Schema.org / JSON-LD 机器可读标注，Agent-First 核心实践手段
- [[concepts/aeo]] — Agent Experience Optimization，让 agent 愿意选择你
- [[concepts/browser-as-runtime]] — 浏览器不只显示结果，也能承载 agent 行为

### AI 工具生态 & 协议
- [[concepts/trust-infrastructure]] — AI 工具竞争从能力转向"可交付、可追责、可观测"的信任体系
- [[concepts/claude-code-hooks]] — Claude Code 生命周期钩子：系统级自动规则，拦截危险操作/自动格式化/审计日志
- [[concepts/agents-md]] — 项目级 AI 配置文件，正形成跨工具事实标准
- [[concepts/mcp]] — Model Context Protocol，已从差异化卖点变成准入门槛
- [[concepts/acp]] — Agent Communication Protocol，OpenClaw 调度外部 Agent 运行时的标准接口

### Agent 设计 & 工程
- [[concepts/agent-prompt-principles]] — ⭐ 从 Claude/Codex/Gemini system prompt 提炼的 12 条 Agent Prompt 设计原则
- [[concepts/agent-memory]] — AI Agent 记忆机制：短期/工作/长期，四层架构，5 篇核心论文
- [[concepts/context-database]] — 上下文数据库新范式：虚拟文件系统 + 分层加载，RAG 的下一代进化
- [[concepts/skills-architecture]] — 元工具模式 + 三级渐进披露，解决工具列表爆炸问题
- [[concepts/agent-platform-capabilities]] — Agent 平台七层能力模型（L0 运行时 → L7 开放性），综合 Managed Agents/OpenClaw/Claude Code 提炼
- [[concepts/claude-code-memory]] — ⭐ Claude Code 记忆系统源码分析：五层架构、LLM 自治管理、索引-内容分离
  - [[concepts/claude-code-memory-principles]] — 十大设计原则速查表
  - [[concepts/claude-code-memory-taxonomy]] — 四种记忆类型与"不存什么"
  - [[concepts/claude-code-memory-index-content-separation]] — 索引-内容分离架构
  - [[concepts/claude-code-memory-write-paths]] — 三条写入路径与互斥机制
  - [[concepts/claude-code-memory-recall]] — LLM 语义路由（Sonnet 选记忆）
  - [[concepts/claude-code-memory-staleness]] — 过期管理与信任机制
  - [[concepts/claude-code-memory-session]] — Session Memory 与 Auto-dream
  - [[concepts/claude-code-memory-system-prompt]] — 记忆行为指令与 eval 验证
- [[concepts/managed-agents]] — Anthropic Managed Agents：Brain/Hands/Session 三组件解耦架构，meta-harness 设计哲学
- [[concepts/agent-session]] — Session 作为外部上下文存储，append-only 事件日志，getEvents() 按需检索，避免不可逆 context 决策
- [[concepts/eval-in-agents]] — Eval 是给 Agent 出考题看分数，非确定性系统唯一可信的质量手段，评估驱动开发（ADD）
- [[concepts/eval-tech-stack]] — Eval 技术栈四层全景：题库→Tracing→LLM 评估→Agent 行为评估，含选型决策树

### 工程技术
- [[concepts/jdbctemplate-resource-management]] — Spring JdbcTemplate 统一管理资源，回调内不可手动关闭 Statement
- [[concepts/java-memory-model]] — JVM 堆/栈/引用原理、对象头结构、分代 GC（Eden/Survivor/Old）、线程安全与拷贝
- [[concepts/java-copy]] — 浅拷贝 vs 深拷贝完整指南：Object.clone()、拷贝构造器、序列化、Kryo，含内存图和常见陷阱
- [[concepts/post-signature]] — 58 帖子 signature 字段含义表 + 查详情接口 + 查修改记录 SQL

---

## Entities（实体）

### 前沿大模型
- [[entities/gpt-5-5]] — OpenAI 旗舰，2026-04-23 发布，原生全模态，Agentic 编程 SOTA，$5/M input
- [[entities/deepseek-v4]] — 深度求索 2026-04-24 发布，Pro（1.6T）/ Flash（284B）双版本，MIT 开源，华为昇腾训练

### AI 工具 / 平台
- [[entities/claude-code]] — Anthropic 出品，当下 Agent 能力上限最高的 CLI 工具
- [[entities/gemini-cli]] — Google 出品，ADK 架构迁移后最模块化，头部三强之一
- [[entities/openclaw]] — 个人 AI 助手平台，AI Agent 操作系统，运行在自有基础设施上
- [[entities/hermes-agent]] — Nous Research 出品，自我改进型 Agent，内建学习循环，Skill 自动创建/精炼，v0.7.0
- [[entities/pi-mono]] — 开源 AI Agent 工具套件，三层架构（pi-ai / pi-agent-core / pi-coding-agent）
- [[entities/memos]] — Agent 记忆管理服务，向量语义检索，已用于技能市场接入
- [[entities/openviking]] — 字节火山引擎开源，AI Agent 上下文数据库，虚拟文件系统 + L0/L1/L2 分层加载，23.1k stars
- [[entities/qmd]] — 本地混合搜索引擎（BM25 + 向量 + LLM 重排），本机已安装 v2.1.0
- [[entities/next-ai-draw-io]] — AI 驱动的 draw.io 图表工具，自然语言→可编辑图结构，18k stars

---

## Sources（原始资料摘要）

- [[sources/hermes-agent]] — Hermes Agent 架构深度调研：学习循环、三层记忆、六种终端后端、OpenClaw 迁移
- [[sources/agent-web-research]] — Agent Web 研究集群：SEO→AEO→Agent-First→Agentic Web 演化链
- [[sources/openclaw-architecture]] — OpenClaw 架构深度研究：Hub-and-Spoke、多智能体、记忆系统
- [[sources/58-experience]] — 58 工作经验：工程操作 SOP、JdbcTemplate 陷阱、AI 工具调研
- [[sources/monthly-ai-radar-2026-03]] — 2026-03 AI 工具月报：信任基础设施成新护城河，头部三强格局分析
- [[sources/daily-2026-technical]] — 2026 技术日志精华：pi-mono、MemOS×技能市场、AI 增强开发工作流
- [[sources/ai-research-2]] — AI研究research 集群：ACP 协议、Skills 架构、Java LLM 框架梯队
- [[sources/research-overview]] — Research 深度研究集：Agent Prompt 原则、记忆机制论文、System Prompt 横向比较
- [[sources/managed-agents]] — Anthropic 工程博客：Managed Agents 架构设计，Brain/Hands/Session 解耦，TTFT p95 降低 90%
- [[sources/managed-agents-launch-2026-04]] — Managed Agents 产品发布公告（2026-04-08）：定价、Sessions API、企业用例、竞争定位
- [[sources/frontier-models-2026-04]] — 前沿模型调研：DeepSeek V4 & GPT-5.5 规格、Benchmarks、架构对比（2026-04-24）

---

## Outputs（查询产出）

- [[outputs/2026-04-12-hermes-agent-quickstart]] — Hermes Agent 部署快速上手 + OpenClaw 对比 + 5 大业务场景落地
- [[outputs/2026-04-24-frontier-models-report]] — DeepSeek V4 vs GPT-5.5 综合对比报告：规格、Benchmarks、场景推荐、不确定性分析
- [[outputs/2026-04-27-openviking-learning-guide]] — OpenViking 系统学习指南：5 阶段从零到源码深潜，11-17h 学习路线
- [[outputs/2026-04-27-rag-comprehensive-guide]] — RAG 从入门到精通：5 次范式演进、核心技术解析、评估体系、技术选型决策框架
- [[outputs/2026-04-28-agent-engineering-learning-plan]] — Agent 工程一年转型学习计划：原理→组件→应用→落地四阶段，每周任务+产出+资源
- [[outputs/2026-04-28-beihang-408-study-plan]] — 北航408非全20个月备考计划（2026.5-2027.12）：五阶段、周时间表、检验节点、风险预案
- [[outputs/2026-04-29-eval-comprehensive-guide]] — Eval 综合指南：原理→Anthropic 方法论→6 工具对比→ADD 方法→选型决策树（团队分享用）
- [[outputs/2026-04-29-openclaw-setup-guide]] — OpenClaw 手把手安装教程：准备→安装→配置→Telegram/飞书接入→安全→进阶功能
- [[outputs/2026-04-29-hermes-agent-setup-guide]] — Hermes Agent 手把手安装教程：安装→模型选择→Telegram 接入→安全→技能系统→语音/MCP/沙箱
- [[beihang-408/00-总览]] — 🎯 北航软件工程非全408备考：17页双链知识库，每周具体任务+408真实考纲+必背公式+检验节点
- [[agent-engineering/00-总览]] — 🤖 Agent 工程一年转型：11页双链知识库，四阶段52周+Java类比+知识参考+反模式速查
- [[python/00-总览]] — 🐍 Python 从基础到精通：11页双链知识库，五阶段12周+Java工程师类比+标准库速查+第三方生态+练手项目
- [[dsa/00-总览]] — 📊 数据结构与算法：11页双链知识库，五阶段16周+LeetCode 76题+Java模板+复杂度速查+刷题指南
