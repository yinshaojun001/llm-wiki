---
title: OpenClaw 手把手安装到应用教程
tags: [output, openclaw, tutorial, setup, guide]
date: 2026-04-29
sources: [entities/openclaw.md, sources/openclaw-architecture.md]
---

# OpenClaw 手把手安装到应用教程

> 面向零基础用户，从安装到跑通第一个 AI 助手，30 分钟搞定。

---

## OpenClaw 是什么？

一句话：**一个跑在你自己电脑上的 AI 助手平台。**

你平时用 ChatGPT / Claude，是在人家的网页上聊天。OpenClaw 是把 AI 的"脑子"（大模型 API）和"身体"（执行环境）装在你自己的机器上，然后通过 Telegram、飞书、Discord 等各种渠道和它对话。

它能做到普通聊天机器人做不到的事：
- 帮你跑命令、读写文件
- 浏览网页、搜索信息
- 定时执行任务（比如每天早上发天气）
- 记住你之前说过的话
- 通过多个渠道（Telegram、飞书、微信等）和你对话

---

## 第一步：安装前准备

### 1.1 安装 Node.js

OpenClaw 需要 Node.js 24（推荐）或 22.14+。

**检查是否已安装：**
```bash
node --version
```

如果显示 `v24.x.x` 或 `v22.14+`，跳到下一步。

**没有安装的话：**

macOS（用 Homebrew）：
```bash
brew install node@24
```

Linux（用 nvm）：
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install 24
```

Windows：去 https://nodejs.org 下载安装包，或用 WSL2（推荐）。

### 1.2 准备一个 AI 模型的 API Key

OpenClaw 本身不是大模型，它需要调用大模型的 API。你需要至少一个：

| 提供商 | 获取地址 | 费用 |
|--------|---------|------|
| **Anthropic（Claude）** | https://console.anthropic.com | 按量付费 |
| **OpenAI（GPT）** | https://platform.openai.com | 按量付费 |
| **Google（Gemini）** | https://aistudio.google.com | 有免费额度 |
| **DeepSeek** | https://platform.deepseek.com | 很便宜 |

> 建议先用 Google Gemini，有免费额度，够测试用。

---

## 第二步：安装 OpenClaw

### macOS / Linux

一行命令：
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

### Windows（PowerShell）

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

### 验证安装

```bash
openclaw --version
```

看到版本号就说明装好了。

---

## 第三步：初始化配置（2 分钟）

运行引导程序：
```bash
openclaw onboard --install-daemon
```

这个命令会启动一个交互式向导，问你三个问题：

1. **选模型提供商**：选你有 API Key 的那个（比如 Anthropic / OpenAI / Google）
2. **输入 API Key**：粘贴你准备好的 Key
3. **Gateway 配置**：一般保持默认就行

完成后，OpenClaw 会在 `~/.openclaw/` 下生成配置文件。

### 验证 Gateway 启动

```bash
openclaw gateway status
```

应该显示 "listening on port 18789"。

### 打开控制面板

```bash
openclaw dashboard
```

浏览器会自动打开 OpenClaw 的控制台界面。在里面发一条消息，如果收到 AI 回复，说明基本功能跑通了。

---

## 第四步：连接聊天渠道

控制台能用了，但你肯定想在手机上随时聊。下面以 **Telegram** 为例（最快配置，5 分钟搞定）。

### 4.1 创建 Telegram Bot

1. 打开 Telegram，搜索 **@BotFather**
2. 发送 `/newbot`
3. 按提示起个名字（比如 "我的AI助手"）
4. BotFather 会给你一个 **Bot Token**，格式像 `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`
5. **保存好这个 Token**

### 4.2 配置 OpenClaw

编辑配置文件 `~/.openclaw/config.json5`（或用命令 `openclaw config edit`），加入 Telegram 配置：

```json5
{
  // ... 已有配置 ...

  channels: {
    telegram: {
      enabled: true,
      botToken: "你刚才拿到的Token",
      dmPolicy: "pairing",
      groups: {
        "*": { requireMention: true }
      }
    }
  }
}
```

**配置说明：**
- `botToken`：BotFather 给你的 Token
- `dmPolicy: "pairing"`：陌生人发消息需要配对码确认（安全）
- `groups` + `requireMention`：群聊里需要 @机器人 才回复

### 4.3 启动并测试

```bash
# 启动 Gateway
openclaw gateway

# 在 Telegram 里给你的 Bot 发一条消息
# Bot 会回复一个配对码

# 查看待配对请求
openclaw pairing list telegram

# 批准配对（用实际的配对码替换 <CODE>）
openclaw pairing approve telegram <CODE>
```

配对成功后，在 Telegram 里给 Bot 发消息，它就会回复了。

> 配对码 1 小时过期，每个频道最多 3 个待处理请求。

---

## 第五步：连接飞书（可选）

如果你用飞书：

1. 在飞书开放平台创建一个机器人应用
2. 获取 App ID 和 App Secret
3. 在配置文件中添加：

```json5
{
  channels: {
    feishu: {
      enabled: true,
      appId: "你的AppID",
      appSecret: "你的AppSecret"
    }
  }
}
```

飞书用 WebSocket 连接，不需要公网 IP。

---

## 第六步：配置模型（可选）

如果你想换模型或添加备用模型：

```json5
{
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-opus-4-6"  // 主模型
      }
    }
  }
}
```

模型格式是 `提供商/模型名`，常见选项：

| 值 | 模型 |
|---|---|
| `anthropic/claude-opus-4-6` | Claude Opus（最强） |
| `anthropic/claude-sonnet-4-6` | Claude Sonnet（性价比） |
| `openai/gpt-4o` | GPT-4o |
| `google/gemini-2.5-pro` | Gemini Pro |
| `deepseek/deepseek-chat` | DeepSeek（便宜） |
| `ollama/llama3` | 本地模型（免费） |

---

## 第七步：安全配置（重要）

### 7.1 DM 策略

控制谁能给你 Bot 发私信：

| 策略 | 效果 |
|------|------|
| `pairing`（默认） | 陌生人需要配对码，你审批后才能聊 |
| `allowlist` | 陌生人直接被屏蔽，无配对流程 |
| `open` | 任何人都能聊（不推荐） |

### 7.2 工具权限

默认情况下，Bot 能跑命令、读写文件。如果你担心安全：

```json5
{
  tools: {
    deny: ["gateway", "cron", "sessions_spawn"]
  }
}
```

### 7.3 安全审计

运行安全检查：
```bash
openclaw security audit
```

自动修复常见问题：
```bash
openclaw security audit --fix
```

---

## 第八步：进阶功能

### 8.1 定时任务

让 Bot 每天早上 8 点给你发天气：

在对话中告诉 Bot："每天早上 8 点给我发北京天气预报"。Bot 会自动创建一个 cron 任务。

### 8.2 浏览器控制

让 Bot 帮你浏览网页、截图：

```json5
{
  tools: {
    alsoAllow: ["browser"]
  }
}
```

### 8.3 记忆系统

Bot 默认会记住对话历史。记忆存储在 `~/.openclaw/memory/` 下，是 Markdown 格式，你可以直接查看和编辑。

### 8.4 子 Agent

Bot 可以 spawn 子 Agent 来并行处理任务。比如你说"帮我调研这三个框架"，Bot 会派出三个子 Agent 同时工作。

---

## 常见问题

### Q: Gateway 启动失败？

检查端口是否被占用：
```bash
lsof -i :18789
```

### Q: Telegram Bot 不回复？

1. 检查 Bot Token 是否正确
2. 检查 Gateway 是否在运行：`openclaw gateway status`
3. 查看日志：`openclaw logs --follow`

### Q: 怎么查看日志？

```bash
openclaw logs --follow
```

### Q: 怎么更新 OpenClaw？

```bash
openclaw update
```

### Q: 配置文件在哪里？

- 主配置：`~/.openclaw/config.json5`
- 凭证：`~/.openclaw/credentials/`
- 记忆：`~/.openclaw/memory/`
- 日志：`~/.openclaw/logs/`

---

## 快速参考卡

```bash
# 安装
curl -fsSL https://openclaw.ai/install.sh | bash

# 初始化
openclaw onboard --install-daemon

# 启动/停止
openclaw gateway              # 前台启动
openclaw gateway status       # 查看状态
openclaw gateway restart      # 重启

# 控制面板
openclaw dashboard

# 配对管理
openclaw pairing list telegram
openclaw pairing approve telegram <CODE>

# 日志
openclaw logs --follow

# 安全
openclaw security audit
openclaw security audit --fix

# 更新
openclaw update
```

---

## 参考链接

| 资源 | 链接 |
|------|------|
| OpenClaw 官方文档 | https://docs.openclaw.ai |
| 快速开始 | https://docs.openclaw.ai/quickstart |
| Telegram 频道配置 | https://docs.openclaw.ai/channels/telegram |
| 安全指南 | https://docs.openclaw.ai/gateway/security |
| 模型提供商 | https://docs.openclaw.ai/providers |
| GitHub | https://github.com/NousResearch/openclaw |

---

## 关联

- [[entities/openclaw]] — OpenClaw 工具概述
- [[sources/openclaw-architecture]] — 架构深度研究
- [[concepts/trust-infrastructure]] — 信任基础设施
