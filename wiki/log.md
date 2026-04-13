# Wiki 操作日志

> 格式：`## [YYYY-MM-DD] ingest/query/lint | 标题`

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
