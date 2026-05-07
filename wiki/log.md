# Wiki 操作日志

> 格式：`## [YYYY-MM-DD] ingest/query/lint | 标题`

---

## [2026-05-07] query | 数据结构与算法课程

用户需求：在 wiki 中增加数据结构与算法课程，从入门到精通。
在 `wiki/dsa/` 下建立 11 页双链知识库：
- 中枢：00-总览（五阶段路线+学习原则）
- 5 阶段：01-基础数据结构 / 02-排序与搜索 / 03-树与图 / 04-高级数据结构 / 05-算法设计
- 3 知识参考：10-Java工程师算法指南 / 11-时间复杂度速查 / 12-LeetCode刷题指南
- 2 工具：20-每周模板 / 21-练习题清单（76 道 LeetCode，按阶段分类）
特点：面向 Java 工程师，含完整代码模板、复杂度速查表、LeetCode 按专题分类
更新：`index.md`（新增 dsa/00-总览 条目）

---

## [2026-05-07] query | Python 从基础到精通课程

用户需求：在 wiki 中增加 Python 基础入门课程，从基础到精通。
在 `wiki/python/` 下建立 11 页双链知识库：
- 中枢：00-总览（五阶段路线+学习原则）
- 5 阶段：01-基础语法 / 02-流程与函数 / 03-数据结构 / 04-面向对象 / 05-进阶精通
- 3 知识参考：10-Python与Java对比 / 11-常用标准库速查 / 12-第三方生态
- 2 工具：20-每周模板 / 21-练习项目清单
特点：面向 Java 工程师，每阶段含 Java 类比、代码示例、练习题、检验标准、练手项目
更新：`index.md`（新增 python/00-总览 条目）

---

## [2026-05-05] ingest | Claude Code 记忆系统源码分析（双链笔记版）

来源：claude-code 源码逐行分析（`src/memdir/`、`src/services/extractMemories/`、`src/services/SessionMemory/`、`src/services/autoDream/`、`src/services/teamMemorySync/`）
新建 9 页双链笔记：
- `concepts/claude-code-memory.md` — 中枢总览页（五层架构 + 源码文件索引 + 对比表）
- `concepts/claude-code-memory-principles.md` — 十大设计原则速查表
- `concepts/claude-code-memory-taxonomy.md` — 四种记忆类型 + "不存什么"反面清单
- `concepts/claude-code-memory-index-content-separation.md` — 索引-内容分离（MEMORY.md 200 行硬上限、截断逻辑、两步写入法）
- `concepts/claude-code-memory-write-paths.md` — 三条写入路径（前台/后台提取/Auto-dream）、互斥机制、权限沙箱、turn 预算
- `concepts/claude-code-memory-recall.md` — LLM 语义路由（Sonnet sideQuery 选记忆）、工具感知、去重、失败降级
- `concepts/claude-code-memory-staleness.md` — 过期管理（年龄标签、验证清单、eval 验证的位置效应）
- `concepts/claude-code-memory-session.md` — Session Memory 压缩缓冲 + Auto-dream 日志整合
- `concepts/claude-code-memory-system-prompt.md` — system prompt 记忆行为指令拆解、eval 验证
更新：`index.md`（新增 9 个 claude-code-memory-* 条目，树形缩进）

---

## [2026-04-29] query | Hermes Agent 手把手安装到应用教程

用户需求：查询 Hermes Agent 安装到应用的教程，写进 wiki。
来源：Hermes Agent 官方文档（quickstart、installation、messaging、security）+ GitHub README（v0.11.0，124k stars）
产出：`outputs/2026-04-29-hermes-agent-setup-guide.md`（9 步教程：安装→模型选择→首次聊天→会话保存→常用操作→Telegram 接入→其他渠道→安全配置→进阶功能，含 OpenClaw 迁移指南）
更新：`index.md`（新增 1 output 条目）

## [2026-04-29] query | OpenClaw 手把手安装到应用教程

用户需求：查找 OpenClaw 安装到应用的教程，写出手把手教学让普通人也能配置。
来源：OpenClaw 官方文档（quickstart、channels/telegram、gateway/security、providers、tools）
产出：`outputs/2026-04-29-openclaw-setup-guide.md`（8 步教程：准备环境→安装→初始化→Telegram 接入→飞书接入→模型配置→安全配置→进阶功能，含常见问题和快速参考卡）
更新：`index.md`（新增 1 output 条目）

## [2026-04-29] query | Claude Code Hooks 生命周期钩子

用户需求：理解 Claude Code /hooks 插件的作用。
新建：`concepts/claude-code-hooks.md`（小白视角解释：类比经理→员工→系统规则；生命周期事件一览；五种处理器；六个实用场景；Hooks vs CLAUDE.md 对比）
更新：`index.md`（新增 claude-code-hooks 条目）

## [2026-04-29] query | Eval 综合指南（团队分享用）

用户需求：全网搜索 eval 相关资料，用于团队分享。
来源：Anthropic 官方文档（成功标准定义 + 六类评估维度 + LLM 评分最佳实践）、DeepEval 官方文档（pytest 风格 + GEval 自定义指标 + Confident AI 平台）、Ragas 官方文档（四大核心指标 + 实验驱动 + 测试集生成）、Promptfoo 官方文档（YAML 配置 + 红队测试 + OpenAI 收购）、Langfuse 官方文档（Tracing + Agent Graph + Annotation Queues）、Braintrust 官方文档（六阶段工作流 + 生产数据驱动）。
产出：`outputs/2026-04-29-eval-comprehensive-guide.md`（为什么需要 Eval → Anthropic 官方方法论 → 6 工具详细对比 → ADD 评估驱动开发 → 选型决策树 → 参考链接）
更新：`index.md`（新增 1 output 条目）

## [2026-04-29] query | Eval 技术栈全景

用户需求：eval 常用的技术栈有哪些。
新建：`concepts/eval-tech-stack.md`（四层全景：题库 HELM/MMLU/GAIA → Tracing Langfuse/Arize/LangSmith → LLM 评估 DeepEval/Promptfoo → Agent 行为评估 Ragas/Braintrust/Agent-as-a-Judge，含选型决策树）
更新：`index.md`（新增 eval-tech-stack 条目）

## [2026-04-29] query | Eval 在 Agent 中的作用

用户需求：用小白视角解释 eval 在 agent 中的核心作用。
新建：`concepts/eval-in-agents.md`（从零解释：Agent 非确定性 → 必须靠"考试"验证 → 出题/考试/改错三件事 → 三层评估体系 → ADD 评估驱动开发 → Eval vs Observability）
更新：`index.md`（新增 eval-in-agents 条目）

---

## [2026-04-28] query | Agent 工程一年转型学习计划（v2 优化版）

用户需求从原理-组件-应用-落地四个层面制定 Agent 开发工程师转型计划。
研究来源：腾讯云开发者、百度开发者、阿里云开发者、GitHub（llm-systems-engineering-roadmap、ai-engineering-bootcamp、agentic-frameworks）、Galileo、Microsoft Multi-Agent Reference Architecture、Fiddler AI、Teradata AgentOps 等多源综合。
产出：`outputs/2026-04-28-agent-engineering-learning-plan.md`（v2 大幅优化：针对 Java 工程师背景，每阶段增加"怎么学/Java 类比/过关标准/一定不要"四层指导，全 52 周详细到天的学习安排，4 个完整项目，可执行的 Portfolio 路径）
更新：`index.md`（新增 1 output 条目）

## [2026-04-28] update | Agent 学习计划 v2 重写

用户要求优化计划使其更落地。从 v1（概述型）重写为 v2（执行型）：
- 每阶段从"学什么"扩展为"怎么学+Java 类比+过关标准+一定不要"
- 第 1 周 Transformer 给出"先动画→再代码→用 Java 类比消化"的实用路径
- 全 52 周每阶段拆到天级任务，时间预算 10-12h/周
- 新增"每个阶段的不要做"总表
- 强调 Agent 工程师不是造模型的，是用模型的；Java 工程经验（可靠性、监控、发布、异常处理）在 Agent 时代全部复用
更新：`outputs/2026-04-28-agent-engineering-learning-plan.md`

---

## [2026-04-28] query | Agent 平台能力模型

在完成学习计划+双链知识库后，综合 Managed Agents、OpenClaw、Claude Code 及行业实践，提炼 Agent 平台七层能力模型。
新建：`concepts/agent-platform-capabilities.md`（L0 Agent 运行时 → L1 工具系统 → L2 记忆 → L3 多 Agent 编排 → L4 安全护栏 → L5 可观测与评估 → L6 部署运维 → L7 平台开放性，每层含能力清单、参考来源、核心权衡）
核心论点：下层决定"能不能跑"，上层决定"敢不敢用"。Demo 停在 L0-L2，生产级需到 L5，企业级需到 L7。
更新：`index.md`

---

## [2026-04-28] query | Agent 工程双链知识库

用户要求将学习计划转为 Obsidian 双链笔记格式。在 `wiki/agent-engineering/` 下建立 11 页双链知识库：
- 中枢：00-总览（四阶段路线+知识参考+学习原则）
- 4 阶段：01-原理筑基 / 02-组件深入 / 03-应用开发（含 4 个项目详细 spec）/ 04-落地生产
- 5 知识参考：10-不易变化的基础 / 11-Agent核心组件 / 12-框架与技术栈 / 13-Java工程师视角（24 条 Java→Agent 概念类比表）/ 14-评估与可观测
- 2 工具：20-每周模板 / 21-每个阶段不要做的事（30+ 条反模式）
特点：每阶段拆到天级任务+Java 类比+过关标准+一定不要；与 concepts/ 中的 agent-memory、agent-session、skills-architecture、managed-agents、trust-infrastructure 等页面双链互联
新建：`wiki/agent-engineering/`（00-04、10-14、20-21 共 11 页）
更新：`index.md`

---

## [2026-04-28] update | 数学二全科详细教学化

用户要求数学二"能做到按着计划来就能学懂"。将数学二从章节列表展开为完整教学内容：
- `beihang-408/14-科目-数学二.md` 完全重写：高数9章+线代6章，每章含直观理解、核心概念与公式、常见题型与解法模板、工程直觉映射、学到什么程度算过关；必背公式卡片大幅扩展（导数表、积分表、微分方程通解）；避坑指南从5条扩至8条
- `01~05` 五个阶段文件的数学安排全部重写：从"5月：极限→6月：导数"展开为每周具体概念、练习量、检验标准（如"不定积分随机10道，8道以上正确"）
- `outputs/2026-04-28-beihang-408-study-plan.md` 同步更新数学部分，增加各阶段详细安排和交叉引用
更新：`beihang-408/14-科目-数学二.md`（重写）、`01~05`五个阶段文件、`outputs/...study-plan.md`

---

## [2026-04-28] update | 英语二午休背词方案细化

将 `beihang-408/15-科目-英语二.md` 的背词策略从"用App每天15min"扩展为完整的 5+12+3 方案（复习→真题语境记词→建卡），含工具选择（墨墨/不背单词，不用百词斩）、分阶段执行节奏。
更新：`beihang-408/15-科目-英语二.md`

---

## [2026-04-28] query | 北航408备考专项知识库

在 `wiki/beihang-408/` 下建立17页双链专项知识库：
- 中枢：00-总览（快速导航+目标分数）
- 5阶段：01-DS启动 → 02-计组攻坚 → 03-OS+计网 → 04-二轮融合 → 05-全科冲刺
- 7科目：10-数据结构 / 11-计组 / 12-OS / 13-计网 / 14-数学二 / 15-英语二 / 16-政治
- 4工具：20-每周模板 / 21-检验节点 / 22-资料清单 / 23-风险预案
特点：每个408科目都有"Java工程直觉→考试理论"映射表，数学二标注跟谁学+避坑指南
更新：`index.md`

---

## [2026-04-28] query | 北航408非全备考计划

个人咨询：30岁/7年Java/Agent平台开发/本科学历有执念 → 北京地区非全AI/CS/SE硕士调研
逐层筛选：北大MEM（28.8万超预算）→ 北交大（2026全改408）→ 北科大879自命题 → 拉长战线冲北航408
结论：北航985 软件工程/计算机技术非全，政治+英二+数二+408，学费4.5万
产出：`outputs/2026-04-28-beihang-408-study-plan.md`（20个月五阶段备考计划：DS→计组→OS+计网→二轮融合→冲刺）
更新：`index.md`（新增1 output条目）

---

## [2026-04-27] query | RAG 从入门到精通

来源：2020-2026 年 RAG 文献综述（Meta RAG 原论文、Modular RAG、Self-RAG、CRAG、Agentic RAG 等）+ Web 搜索
产出：`outputs/2026-04-27-rag-comprehensive-guide.md`（5 次范式演进、8 大核心技术、评估体系、技术选型决策、6 阶段学习路径）
更新：`index.md`（新增 1 output 条目）

---

## [2026-04-27] query | OpenViking 系统学习

来源：https://github.com/volcengine/OpenViking（字节火山引擎开源，23.1k stars）
新建：`entities/openviking.md`（实体页：架构、性能数据、技术栈）
新建：`concepts/context-database.md`（上下文数据库新范式：虚拟文件系统、分层加载、递归检索）
产出：`outputs/2026-04-27-openviking-learning-guide.md`（5 阶段学习路线：理解问题→核心概念→动手部署→集成实战→源码深潜，11-17h）
更新：`index.md`（新增 1 entity、1 concept、1 output 条目）

---

## [2026-04-24] query | DeepSeek V4 & GPT-5.5 更新——V4 正式发布

DeepSeek V4 于 2026-04-24 正式发布预览版并开源（MIT），两个版本：Pro（1.6T/49B active）和 Flash（284B/13B active）。
重写：`entities/deepseek-v4.md`（从发布前推测→官方发布数据：版本矩阵、四大架构创新、实际 Benchmarks、定价）
充实：`entities/gpt-5-5.md`（补充完整 Benchmark 表、效率创新、安全评估、NVIDIA 联合设计）
更新：`sources/frontier-models-2026-04.md`（更新为实际发布数据）

---

## [2026-04-24] query | DeepSeek V4 & GPT-5.5 前沿模型调研（初版）

来源：OpenAI 官方公告、The Decoder、nxcode.io、morphllm.com、新浪财经、腾讯新闻（网络实时搜索）
新建：`sources/frontier-models-2026-04.md`、`entities/gpt-5-5.md`、`entities/deepseek-v4.md`
产出：`outputs/2026-04-24-frontier-models-report.md`（DeepSeek V4 vs GPT-5.5 综合对比）
更新：`index.md`（新增 2 entity、1 source、1 output 条目）

---

## [2026-04-13] query | Java 内存模型、浅拷贝与深拷贝

新建：`concepts/java-memory-model.md`（JVM 堆/栈、引用 vs 指针、对象头、分代 GC、线程安全）
更新：`concepts/java-copy.md`（扩写为完整指南：Object.clone() 原理、浅拷贝 bug 示例、5 种深拷贝实现、对比表、常见陷阱）
更新：`index.md`（新增 java-memory-model 条目，更新 java-copy 描述）

---

## [2026-04-12] ingest | Hermes Agent — NousResearch 自我改进型 Agent

来源：https://github.com/NousResearch/hermes-agent（v0.7.0，2026-04-03）
新建：`sources/hermes-agent.md`、`entities/hermes-agent.md`
产出：`outputs/2026-04-12-hermes-agent-quickstart.md`（部署快速上手 + OpenClaw 对比 + 5 大业务场景）
更新：`index.md`（新增 1 entity、1 source、1 output 条目）

---

## [2026-04-10] lint | 健康检查 + 修复

破链 3 个（遗留）：`[[concepts/seo]]`（×2）、`[[concepts/structured-data]]`（×1）、`[[entities/gemini-cli]]`（×2）
待建页：concepts/seo、concepts/structured-data、entities/gemini-cli、Java LLM 框架梯队（低优先级）
index 描述不符：agent-memory 写"10 篇核心论文"，实际列出 5 篇（遗留）
新增页面检查：managed-agents、agent-session、post-signature 等 5 页均正常，无新破链
孤立页：无

修复：新建 `concepts/seo.md`、`concepts/structured-data.md`、`entities/gemini-cli.md`；修正 index.md 中 agent-memory 论文数（10→5）；index.md 补录 3 个新页面入口

---

## [2026-04-10] ingest | Claude Managed Agents 产品发布公告（2026-04-08）

来源：SiliconANGLE / The New Stack / The Decoder / 官方文档（网络搜索核实）
新建：`sources/managed-agents-launch-2026-04.md`
更新：`concepts/managed-agents.md`（补充定价、Sessions API、企业用例、竞争定位）、`index.md`

---



原文：https://www.anthropic.com/engineering/managed-agents（发布 2026-02-04，更新 2026-04-08）
新建：`sources/managed-agents.md`、`concepts/managed-agents.md`、`concepts/agent-session.md`
更新：`index.md`（新增 2 个 concept 条目、1 个 source 条目）

## [2026-04-09] ingest | 58 经验 — 查帖子详情 & 修改记录

从 `Obsidian Vault/58 经验/查帖子详情.md` 和 `查询帖子修改记录.md` 提炼。
更新：`sources/58-experience.md`（SOP 表新增两条）
新建：`concepts/post-signature.md`（signature 含义表 + 查询接口 + Hive SQL）

## [2026-04-09] ingest | AI研究 research — Agent Web 研究集群

从 `Obsidian Vault/AI研究 research/agent-web/` 提炼。
新建：`sources/agent-web-research.md`、`concepts/agentic-web.md`、`concepts/agent-first.md`、`concepts/aeo.md`、`concepts/browser-as-runtime.md`

## [2026-04-09] ingest | AI研究 research — OpenClaw 架构研究

从 `Obsidian Vault/AI研究 research/OpenClaw*.md` 提炼。
新建：`sources/openclaw-architecture.md`、`entities/openclaw.md`、`entities/qmd.md`

---

## [2026-04-09] lint | 健康检查

破链 3 个：`[[concepts/seo]]`（×2）、`[[concepts/structured-data]]`（×1）、`[[entities/gemini-cli]]`（×2）
待建页 3 个：concepts/seo、concepts/structured-data、entities/gemini-cli
未成页概念 1 个：Java LLM 框架梯队（内容在 sources/ai-research-2，无独立 concept 页）
index 描述不符 1 处：agent-memory 写"10 篇核心论文"，实际列出 5 篇
孤立页：无

---

## [2026-04-09] init | Wiki 系统初始化

创建目录结构：`raw/`、`wiki/concepts/`、`wiki/entities/`、`wiki/sources/`、`wiki/outputs/`，以及 `index.md`、`log.md`、`CLAUDE.md`。
