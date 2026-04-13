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
- [[concepts/agents-md]] — 项目级 AI 配置文件，正形成跨工具事实标准
- [[concepts/mcp]] — Model Context Protocol，已从差异化卖点变成准入门槛
- [[concepts/acp]] — Agent Communication Protocol，OpenClaw 调度外部 Agent 运行时的标准接口

### Agent 设计 & 工程
- [[concepts/agent-prompt-principles]] — ⭐ 从 Claude/Codex/Gemini system prompt 提炼的 12 条 Agent Prompt 设计原则
- [[concepts/agent-memory]] — AI Agent 记忆机制：短期/工作/长期，四层架构，5 篇核心论文
- [[concepts/skills-architecture]] — 元工具模式 + 三级渐进披露，解决工具列表爆炸问题
- [[concepts/managed-agents]] — Anthropic Managed Agents：Brain/Hands/Session 三组件解耦架构，meta-harness 设计哲学
- [[concepts/agent-session]] — Session 作为外部上下文存储，append-only 事件日志，getEvents() 按需检索，避免不可逆 context 决策

### 工程技术
- [[concepts/jdbctemplate-resource-management]] — Spring JdbcTemplate 统一管理资源，回调内不可手动关闭 Statement
- [[concepts/java-copy]] — 深拷贝完整复制引用字段，浅拷贝共享内存
- [[concepts/post-signature]] — 58 帖子 signature 字段含义表 + 查详情接口 + 查修改记录 SQL

---

## Entities（实体）

### AI 工具 / 平台
- [[entities/claude-code]] — Anthropic 出品，当下 Agent 能力上限最高的 CLI 工具
- [[entities/gemini-cli]] — Google 出品，ADK 架构迁移后最模块化，头部三强之一
- [[entities/openclaw]] — 个人 AI 助手平台，AI Agent 操作系统，运行在自有基础设施上
- [[entities/hermes-agent]] — Nous Research 出品，自我改进型 Agent，内建学习循环，Skill 自动创建/精炼，v0.7.0
- [[entities/pi-mono]] — 开源 AI Agent 工具套件，三层架构（pi-ai / pi-agent-core / pi-coding-agent）
- [[entities/memos]] — Agent 记忆管理服务，向量语义检索，已用于技能市场接入
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

---

## Outputs（查询产出）

- [[outputs/2026-04-12-hermes-agent-quickstart]] — Hermes Agent 部署快速上手 + OpenClaw 对比 + 5 大业务场景落地
