---
title: Hermes Agent 手把手安装到应用教程
tags: [output, hermes-agent, tutorial, setup, guide]
date: 2026-04-29
sources: [entities/hermes-agent.md, sources/hermes-agent.md]
---

# Hermes Agent 手把手安装到应用教程

> 面向零基础用户，从安装到跑通第一个会自我学习的 AI 助手。

---

## Hermes Agent 是什么？

一句话：**一个会自己学习、自己长技能的 AI 助手。**

普通 AI 助手每次对话都是从零开始。Hermes 不一样——它有一个"学习循环"：

```
观察 → 计划 → 执行 → 学习
```

每次完成复杂任务后，它会自动把经验提炼成 Skill（技能），下次遇到类似任务直接复用，越用越聪明。

**和 OpenClaw 的区别**：OpenClaw 是"执行环境"，Hermes 是"会成长的员工"。Hermes 用 Python 写的，OpenClaw 用 Node.js。

---

## 第一步：安装

### 前提条件

只需要一个：**Git**。其他所有依赖（Python、Node.js、ffmpeg 等）安装脚本会自动搞定。

检查 Git：
```bash
git --version
```

没有 Git 的话：
- macOS：`xcode-select --install`
- Linux：`sudo apt install git` 或 `sudo dnf install git`

### 一行命令安装

**Linux / macOS / WSL2：**
```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

**Windows：** 不支持原生安装，必须先装 WSL2，然后在 WSL2 里执行上面的命令。

**Android（Termux）：**
同一个命令，安装脚本会自动检测 Termux 环境并切换到 Android 流程。

### 安装完成后

```bash
# 重新加载 shell 配置
source ~/.bashrc    # 或 source ~/.zshrc

# 验证安装
hermes --version
```

看到版本号就说明装好了。

---

## 第二步：选择模型

```bash
hermes model
```

这是一个交互式向导，用方向键选择你的 LLM 提供商。

### 可选的提供商

| 提供商 | 认证方式 | 推荐度 |
|--------|---------|-------|
| **OpenRouter** | API Key（一个 Key 用 200+ 模型） | 最推荐入门 |
| **Anthropic** | API Key 或 Claude Code 认证 | 质量最高 |
| **OpenAI** | API Key | 最主流 |
| **DeepSeek** | API Key | 最便宜 |
| **Nous Portal** | OAuth 登录 | 官方原生 |
| **自定义端点** | Base URL + API Key | 本地模型 / 私有部署 |

### 设置 API Key

```bash
# 以 OpenRouter 为例
hermes config set OPENROUTER_API_KEY sk-or-你的key

# 或 Anthropic
hermes config set ANTHROPIC_API_KEY sk-ant-你的key

# 或 OpenAI
hermes config set OPENAI_API_KEY sk-你的key
```

> 配置会自动存到正确位置：密钥存 `~/.hermes/.env`，普通设置存 `~/.hermes/config.yaml`。

### 重要：模型上下文要求

Hermes 要求模型至少有 **64,000 tokens** 的上下文窗口。低于这个的模型会被拒绝。现在主流模型都满足这个要求。

---

## 第三步：第一次聊天

```bash
hermes          # 经典 CLI 界面
hermes --tui    # 现代 TUI 界面（推荐）
```

启动后会显示欢迎横幅，包括你选的模型、可用工具和技能。

### 试试这些对话

- "帮我看看当前目录下有什么文件"
- "查一下我的磁盘使用情况，列出最大的 5 个目录"
- "帮我写一个 Python 脚本，计算斐波那契数列前 20 项"

### 成功的标志

- 横幅显示你选的提供商
- Hermes 能正常回复
- 能调用工具（执行命令、读文件、搜索网页）
- 对话能持续多轮

---

## 第四步：验证会话保存

```bash
hermes --continue    # 恢复上次对话
hermes -c            # 简写
```

如果能恢复上次对话，说明会话保存正常。

---

## 第五步：常用操作

### 斜杠命令

在对话中输入 `/` 会弹出自动补全菜单：

| 命令 | 作用 |
|------|------|
| `/help` | 查看所有可用命令 |
| `/tools` | 列出可用工具 |
| `/model` | 切换模型 |
| `/new` 或 `/reset` | 开始新对话 |
| `/retry` | 重试上一个回答 |
| `/undo` | 撤销上一步 |
| `/compress` | 压缩上下文 |
| `/skills` | 浏览技能库 |
| `/personality pirate` | 切换人格（比如海盗风格） |
| `/save` | 保存对话 |

### 多行输入

`Alt+Enter` 或 `Ctrl+J` 换行，适合粘贴代码或长 prompt。

### 中断 Agent

输入新消息按 Enter 中断，或 `Ctrl+C`。

---

## 第六步：连接聊天渠道（Telegram 为例）

### 启动设置向导

```bash
hermes gateway setup
```

交互式向导，方向键选择要配置的平台。选 Telegram。

### 创建 Telegram Bot

1. 打开 Telegram，搜索 **@BotFather**
2. 发送 `/newbot`
3. 按提示起名字
4. 拿到 **Bot Token**

### 配置 Token

```bash
hermes config set TELEGRAM_BOT_TOKEN 你拿到的Token
```

或者在 `~/.hermes/.env` 中添加：
```
TELEGRAM_BOT_TOKEN=你拿到的Token
```

### 启动 Gateway

```bash
hermes gateway          # 前台运行（调试用）
hermes gateway start    # 后台服务
```

### 配对你的账号

在 Telegram 给 Bot 发消息，Bot 会回复一个配对码。然后：

```bash
hermes pairing approve telegram 配对码
```

配对成功后就能正常对话了。

### 安装为系统服务（可选）

```bash
# 用户级服务（推荐）
hermes gateway install

# Linux 系统级服务
sudo hermes gateway install --system
```

这样重启电脑后 Gateway 会自动启动。

---

## 第七步：其他聊天渠道

`hermes gateway setup` 支持的平台：

| 平台 | 特点 |
|------|------|
| **Telegram** | 最快配置，语音/图片/文件全支持 |
| **Discord** | 服务器+频道+私信，支持 Thread |
| **Slack** | 工作区应用，多人 DM |
| **WhatsApp** | 需要 QR 配对，状态存在本地 |
| **Signal** | 隐私优先 |
| **飞书 / 钉钉 / 企业微信** | 国内办公场景 |
| **Email / SMS** | 传统渠道 |

所有平台通过同一个 Gateway 进程管理。

---

## 第八步：安全配置

### 危险命令审批

Hermes 默认会拦截危险命令（`rm -rf`、`chmod 777`、`DROP TABLE` 等），需要你确认才执行。

审批模式配置：

```bash
hermes config set approvals.mode manual    # 默认，总是询问
hermes config set approvals.mode smart     # AI 自动判断风险
hermes config set approvals.mode off       # 不检查（不推荐）
```

审批时的选择：
- **once**：只这一次允许
- **session**：本次会话允许
- **always**：永久允许（加入白名单）
- **deny**：拒绝（默认，60 秒超时自动拒绝）

### YOLO 模式

跳过所有审批（慎用）：

```bash
hermes --yolo          # 启动时开启
/yolo                  # 在对话中切换
```

### 用户访问控制

```bash
# 只允许特定用户
hermes config set TELEGRAM_ALLOWED_USERS 123456789,987654321
```

默认策略：**不在白名单中的一律拒绝**。

---

## 第九步：进阶功能

### 技能系统（Skill）

Hermes 最独特的能力——它会自动从任务中学习，生成可复用的 Skill。

```bash
hermes skills                       # 浏览已有技能
hermes skills search kubernetes     # 搜索技能
hermes skills install openai/skills/k8s   # 安装社区技能
```

技能存储在 `~/.hermes/skills/` 下，是 Markdown 格式，你可以直接查看和编辑。

### 定时任务

在对话中用自然语言描述：

> "每天早上 8 点给我发北京天气预报"

Hermes 会自动创建一个 cron 任务，按时执行。

### 沙箱终端

让 Agent 在隔离环境中执行命令：

```bash
hermes config set terminal.backend docker      # Docker 隔离
hermes config set terminal.backend ssh         # 远程服务器
hermes config set terminal.backend modal       # Serverless
```

### 语音模式

```bash
pip install "hermes-agent[voice]"
```

在对话中 `/voice on` 开启，`Ctrl+B` 录音。支持 CLI、Telegram、Discord。

### MCP 服务器集成

在 `~/.hermes/config.yaml` 中添加 MCP 服务器配置：

```yaml
mcp:
  servers:
    my-server:
      command: npx
      args: ["-y", "@my/mcp-server"]
      env:
        API_KEY: "your-key"
```

### 从 OpenClaw 迁移

Hermes 支持一键从 OpenClaw 迁移：

```bash
hermes claw migrate              # 交互式迁移
hermes claw migrate --dry-run    # 预览迁移内容
```

自动导入：设置、记忆、技能、API Key、消息平台配置。

---

## 常见问题

| 症状 | 原因 | 解决 |
|------|------|------|
| `hermes: command not found` | Shell 没重新加载 | `source ~/.bashrc` 或重新打开终端 |
| API key not set | 没配置 Key | `hermes model` 或 `hermes config set` |
| 回复内容空白或错误 | 模型认证问题 | 重新运行 `hermes model` |
| Gateway 启动但收不到消息 | Bot Token 不对或没配对 | 重新 `hermes gateway setup` |
| `--continue` 找不到会话 | Profile 不对 | `hermes sessions list` 查看 |

### 诊断工具

```bash
hermes doctor       # 全面诊断，告诉你缺什么、怎么修
hermes config check # 检查配置完整性
```

---

## 快速参考卡

```bash
# 安装
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 基础
hermes                    # 开始聊天
hermes --tui              # TUI 界面（推荐）
hermes --continue         # 恢复上次对话
hermes model              # 选择模型
hermes setup              # 完整设置向导

# Gateway
hermes gateway setup      # 配置消息平台
hermes gateway            # 前台启动
hermes gateway start      # 后台服务
hermes gateway status     # 查看状态
hermes gateway install    # 安装为系统服务

# 配对
hermes pairing approve telegram <CODE>

# 技能
hermes skills             # 浏览技能
hermes skills search <关键词>

# 诊断
hermes doctor             # 全面诊断
hermes update             # 更新到最新版
```

---

## 参考链接

| 资源 | 链接 |
|------|------|
| 官方文档 | https://hermes-agent.nousresearch.com/docs/ |
| GitHub | https://github.com/NousResearch/hermes-agent |
| 快速开始 | https://hermes-agent.nousresearch.com/docs/getting-started/quickstart |
| 安装指南 | https://hermes-agent.nousresearch.com/docs/getting-started/installation |
| 安全指南 | https://hermes-agent.nousresearch.com/docs/user-guide/security |
| Discord 社区 | https://discord.gg/NousResearch |
| 技能市场 | https://agentskills.io |

---

## 关联

- [[entities/hermes-agent]] — Hermes Agent 工具概述
- [[sources/hermes-agent]] — 架构深度调研
- [[outputs/2026-04-12-hermes-agent-quickstart]] — 部署快速上手 + OpenClaw 对比
- [[concepts/skills-architecture]] — 技能系统原理
- [[concepts/agent-memory]] — 三层记忆架构
- [[outputs/2026-04-29-openclaw-setup-guide]] — OpenClaw 安装教程（可对比）
