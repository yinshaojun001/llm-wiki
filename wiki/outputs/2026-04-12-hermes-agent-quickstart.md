---
title: Hermes Agent 部署快速上手 + OpenClaw 对比 + 业务场景
tags: [output, quickstart, hermes-agent, openclaw, deployment]
date: 2026-04-12
sources: [sources/hermes-agent.md]
---

# Hermes Agent 部署快速上手

> **参考版本**：v0.7.0 "The Resilience Release"（2026-04-03）  
> **适用平台**：Linux / macOS / WSL2 / Android (Termux)

---

## 一、5 分钟最小部署

### Step 1：安装

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

安装完成（约 60 秒）后，自动配置 `hermes` 命令到 PATH。

### Step 2：配置 LLM 后端

```bash
hermes model
```

交互式选择：

| 选项 | 说明 | 推荐场景 |
|------|------|----------|
| Nous Portal | 官方服务，直接访问 Hermes 系列微调模型 | 体验最佳默认选项 |
| OpenRouter | 200+ 模型一站接入 | 需要灵活切换模型 |
| OpenAI | GPT-4o / GPT-4.1 | 已有 OpenAI 账号 |
| Anthropic | Claude Sonnet / Opus | 生产级推理任务 |
| Custom endpoint | 任意 OpenAI 兼容 API | 私有/本地部署模型 |

### Step 3：开始对话

```bash
hermes
```

首次启动会引导你完成记忆初始化。

---

## 二、进阶部署选项

### 2.1 Docker 沙箱（推荐生产）

```bash
hermes config set terminal.backend docker
hermes config set terminal.docker.image hermes-sandbox:latest
hermes
```

适合：代码执行、文件操作、有隔离需求的自动化任务。

### 2.2 SSH 远程执行

```bash
hermes config set terminal.backend ssh
hermes config set terminal.ssh.host user@your-server.com
hermes
```

适合：在本地聊，任务跑在云服务器（$5/月 VPS 可满足基础需求）。

### 2.3 Serverless（Modal）

```bash
pip install modal
modal setup            # 一次性 OAuth 登录
hermes config set terminal.backend modal
hermes
```

适合：突发性重计算任务（数据处理、批量生成），按需付费，无需常驻服务器。

### 2.4 消息网关（Telegram 示例）

```bash
hermes gateway setup telegram
# 按提示输入 Telegram Bot Token
# 扫码完成绑定
hermes gateway start
```

绑定后，手机 Telegram 发消息即可触发 Agent，Agent 在服务器后台持续运行。

---

## 三、核心功能速览

### 3.1 技能系统（学习循环）

Hermes 完成复杂任务后会自动创建 Skill：

```
你：帮我写一份竞品分析报告，对比 A 和 B 产品
Hermes：[执行任务...]
Hermes：[任务完成] 我已将「竞品分析报告」workflow 保存为 skill，下次
         直接说「竞品分析 X vs Y」即可复用。
```

查看/管理已有技能：

```bash
hermes skills list
hermes skills show "竞品分析报告"
hermes skills delete "..."
```

### 3.2 定时任务

```bash
# 自然语言设定
hermes schedule "每天早上 9 点总结昨日 GitHub 新 Star 仓库"
hermes schedule "每周一生成本周工作计划草稿"

# 查看/删除
hermes schedule list
hermes schedule remove <id>
```

### 3.3 子代理并发

```
你：并发研究三个竞争对手：公司A、公司B、公司C，各出一份分析
Hermes：[派遣 3 个子代理并发执行...]
         [子代理1完成] ...
         [子代理2完成] ...
         [子代理3完成] ...
         [合并结果] ...
```

### 3.4 MCP 集成

```bash
hermes mcp add "github" npx @modelcontextprotocol/server-github
hermes mcp add "postgres" npx @modelcontextprotocol/server-postgres
hermes mcp list
```

---

## 四、与 OpenClaw 对比

### 4.1 架构对比

| 维度 | Hermes Agent | OpenClaw |
|------|-------------|----------|
| **语言栈** | Python + uv | Node.js 22+ |
| **GitHub Stars** | 33k（2026-04） | 247k（成熟生态） |
| **自我改进** | ✅ 核心特性，Skill 自动创建/精炼 | ❌ 不支持 |
| **记忆系统** | 3 层（短期 / 情节 / 过程）| Session SQLite |
| **用户建模** | Honcho 跨会话画像 | ❌ |
| **模型支持** | 400+ 模型 | 包装主流 API |
| **Token 效率** | 高（Skill 复用减少重复推理）| 标准 |
| **终端后端** | 6 种（local/Docker/SSH/Daytona/Singularity/Modal） | Docker / Local |
| **消息渠道** | TG/Discord/Slack/WA/Signal | 同 + 飞书/iMessage |
| **多智能体** | 原生子代理 | ACP（Claude Code / Codex / Gemini CLI） |
| **生态成熟度** | 成长期 | 成熟，社区大 |
| **一键迁移** | 支持从 OpenClaw 导入 | — |

### 4.2 选型建议

```
选 Hermes Agent，如果你：
├── 重复性任务多，希望 Agent 越用越快（Skill 学习）
├── 需要 Serverless/GPU 弹性（Modal）
├── 本身用 Python 技术栈，需要深度定制
└── 从 OpenClaw 迁移，想试试自学习能力

选 OpenClaw，如果你：
├── 需要稳定生产级部署（247k stars，Bug 少）
├── 重度依赖飞书/iMessage 渠道
├── 团队 Node.js 背景，维护成本低
└── 需要 ACP 协议对接 Claude Code 等工具
```

---

## 五、业务场景落地

### 场景 A：个人知识管理 + 研究助手

**痛点**：每次提问要重新解释背景，研究结果无法沉淀复用。

**Hermes 方案**：
1. 部署在 VPS（$5/月），通过 Telegram 全天交互
2. 三层记忆：`你喜欢的风格、常用框架` → 情节记忆；`如何写竞品分析` → Skill
3. 越用越懂你，同类任务 token 消耗递减

```
第1次：完整分析 OpenClaw vs Hermes（1200 tokens）
第5次：直接调 Skill，追加 diff（300 tokens）
```

---

### 场景 B：DevOps 自动化监控

**痛点**：告警来了需要手动查日志、分析根因，响应慢。

**Hermes 方案**：
1. Docker 后端 + SSH 接入生产环境
2. 配置 Webhook 触发：PagerDuty → Hermes Gateway
3. 告警触发后自动：拉日志 → 分析根因 → 生成处理建议 → 发 Slack

```yaml
# hermes webhook config
trigger: pagerduty_alert
action: |
  1. ssh prod-server 拉最近 500 行日志
  2. 分析 ERROR 模式
  3. 匹配已有 runbook skill
  4. 生成摘要发 #oncall 频道
```

---

### 场景 C：内容创作批量生产

**痛点**：同一模板的内容要反复生成，提示词每次都要重写。

**Hermes 方案**：
1. 第一次教 Hermes 你的写作风格 → 自动生成「小红书文案」Skill
2. 之后只需：`小红书文案：主题是XX产品`
3. 子代理并发：同时生成 5 个平台的不同版本

```
你：写 5 个平台的文案：产品是XX，目标用户是25-35岁都市白领
Hermes：[并发子代理] 小红书 / 微信 / 抖音 / LinkedIn / Twitter 各一份
         [合并] 30秒后输出全部
```

---

### 场景 D：代码审查 + 知识沉淀

**痛点**：代码审查标准在人脑里，新成员难以对齐，意见散落在 PR 里。

**Hermes 方案**：
1. 接入 GitHub MCP
2. PR 创建时触发 → Hermes 按团队规范 review
3. 每次 review 的新规则自动提炼为「代码规范 Skill」
4. 规范随时间迭代，新成员入职直接继承

---

### 场景 E：研究数据批量处理

**痛点**：大批量分析任务，普通 Agent 串行太慢，token 超限。

**Hermes 方案**：
- Modal 后端（Serverless GPU，只为任务付费）
- 子代理并发分片处理
- 批量轨迹生成（用于微调 / RL 数据集构建）

---

## 六、迁移自 OpenClaw

```bash
# 自动迁移（推荐）
hermes migrate --from openclaw

# 手动指定路径
hermes migrate --from openclaw --config ~/.openclaw/config.json
```

迁移内容：Settings、Memories、Skills（格式自动转换）。

---

## 参考资料

- [Hermes Agent GitHub](https://github.com/NousResearch/hermes-agent)
- [官方文档](https://hermes-agent.nousresearch.com/docs/)
- [Self-Evolution 研究](https://github.com/NousResearch/hermes-agent-self-evolution)（DSPy + GEPA，ICLR 2026）
- [[entities/hermes-agent]]
- [[entities/openclaw]]
- [[sources/hermes-agent.md]]
