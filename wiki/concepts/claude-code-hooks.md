---
title: Claude Code Hooks（生命周期钩子）
tags: [concept, claude-code, hooks, automation, security]
date: 2026-04-29
---

# Claude Code Hooks

> Hooks 是你给 Claude Code 装的"自动规则"——系统级强制执行，不依赖 Claude 自觉。

---

## 一句话理解

你可以在 Claude 做事的特定时刻，自动执行你自己的脚本。不需要每次手动提醒 Claude"别删这个文件"、"写完代码要格式化"——hook 会自动帮你拦住或处理。

---

## 类比

你是一个经理，Claude 是你的员工。

**没有 hooks**：你每天跟员工说"记得写完代码要跑 lint"、"别动生产配置"。员工有时候记得，有时候忘了。

**有 hooks**：你在公司流程系统里设了自动规则——"每次提交前自动跑 lint"、"生产配置编辑自动拦截"。员工想忘都忘不了。

**Hooks 就是这个"系统自动规则"。**

---

## 核心生命周期事件

Claude Code 的工作流程有几个关键节点，hook 可以挂在这些节点上：

```
用户发消息
  ↓
[Claude 思考]
  ↓
Claude 决定用某个工具（写文件、跑命令...）
  ↓
  ├─ ← PreToolUse：工具执行之前（可以拦截）
  │
  [工具执行]
  │
  └─ ← PostToolUse：工具执行之后（可以善后）
  ↓
Claude 回复完成
  ↓
← Stop：回复结束
```

### 全部事件一览

| 事件 | 触发时机 | 常见用途 |
|------|---------|---------|
| **SessionStart** | 会话开始 | 设置环境变量、初始化状态 |
| **PreToolUse** | 工具执行之前 | 拦截危险操作、权限控制 |
| **PostToolUse** | 工具执行之后 | 自动格式化、lint、记日志 |
| **Stop** | Claude 回复完成 | 流程控制、收尾处理 |
| **UserPromptSubmit** | 用户发消息后 | 预处理用户输入 |
| **PermissionRequest** | 权限弹窗时 | 自动审批/拒绝权限 |
| **SubagentStart/Stop** | 子 Agent 生命周期 | 监控子 Agent 行为 |

---

## 五种 Hook 处理器

### 1. Command（Shell 命令）—— 最常用

执行一个 shell 脚本。

```json
{
  "type": "command",
  "command": "/path/to/my-script.sh"
}
```

### 2. HTTP（HTTP POST）

向指定 URL 发送请求，适合集成外部服务。

```json
{
  "type": "http",
  "url": "http://localhost:8080/hooks/pre-tool-use"
}
```

### 3. MCP Tool（调用 MCP 工具）

直接调用已连接的 MCP 服务器上的工具。

```json
{
  "type": "mcp_tool",
  "server": "my_server",
  "tool": "security_scan"
}
```

### 4. Prompt（LLM 判断）

让 Claude 做 yes/no 判断，适合需要语义理解的场景。

```json
{
  "type": "prompt",
  "prompt": "这段代码里有没有硬编码的密钥？回答 yes 或 no。",
  "model": "claude-sonnet-4-20250514"
}
```

### 5. Agent（子 Agent 验证）

生成一个子 Agent 来验证条件（实验性）。

```json
{
  "type": "agent",
  "prompt": "检查所有 TypeScript 文件是否符合命名规范。"
}
```

---

## 配置方式

### 配置文件位置

| 位置 | 作用域 | 提交到 Git |
|------|--------|-----------|
| `~/.claude/settings.json` | 全局（所有项目） | 否 |
| `.claude/settings.local.json` | 当前项目（私有） | 否 |
| `.claude/settings.json` | 当前项目 | 是 |

### 三级结构

```json
{
  "hooks": {
    "事件类型": [
      {
        "matcher": "匹配哪些工具",
        "hooks": [
          { "type": "command", "command": "要执行的脚本" }
        ]
      }
    ]
  }
}
```

### Matcher 规则

| 值 | 含义 |
|----|------|
| `"*"` 或省略 | 匹配所有工具 |
| `"Bash"` | 精确匹配 Bash |
| `"Edit\|Write"` | 匹配 Edit 或 Write |
| 含特殊字符 | 当作正则表达式 |

---

## 输入输出机制

### 输入

Hook 通过 stdin 收到 JSON，包含工具名、参数等信息：

```json
{
  "tool_name": "Bash",
  "tool_input": { "command": "rm -rf /tmp/old-data" }
}
```

### 输出（exit code 决定行为）

| 退出码 | 含义 |
|--------|------|
| **0** | 成功，stdout 解析为 JSON |
| **2** | 阻断性错误，**拦截当前操作** |
| **其他** | 非阻断性错误，显示警告 |

### PreToolUse 的四种决策

通过 JSON 输出的 `permissionDecision` 字段控制：

| 决策 | 效果 |
|------|------|
| **allow** | 允许执行 |
| **deny** | 拒绝执行（Claude 收到拒绝原因） |
| **ask** | 弹出权限对话框问用户 |
| **defer** | 暂停等外部处理 |

优先级：`deny` > `defer` > `ask` > `allow`

---

## 六个实用场景

### 1. 写完文件自动格式化

```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "bash -c 'FILE=$(jq -r .tool_input.file_path); case \"$FILE\" in *.ts|*.tsx) npx prettier --write \"$FILE\" ;; *.py) black \"$FILE\" ;; esac'"
    }]
  }]
}
```

### 2. 阻止危险的 Bash 命令

```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "bash -c 'CMD=$(jq -r .tool_input.command); echo \"$CMD\" | grep -qE \"rm -rf /|drop table\" && echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"PreToolUse\\\",\\\"permissionDecision\\\":\\\"deny\\\",\\\"permissionDecisionReason\\\":\\\"Destructive command blocked\\\"}}\" || exit 0'"
    }]
  }]
}
```

### 3. 阻止编辑生产配置文件

```json
{
  "PreToolUse": [{
    "matcher": "Edit|Write",
    "hooks": [{
      "type": "command",
      "if": "Edit(*config_prod*)",
      "command": "bash -c 'echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"PreToolUse\\\",\\\"permissionDecision\\\":\\\"deny\\\",\\\"permissionDecisionReason\\\":\\\"Production config is read-only\\\"}}\"'"
    }]
  }]
}
```

### 4. 记录所有工具调用（审计日志）

```json
{
  "PostToolUse": [{
    "matcher": "*",
    "hooks": [{
      "type": "command",
      "command": "bash -c 'echo \"$(date +%Y-%m-%dT%H:%M:%S) | $(jq -r .tool_name) | $(jq -r .tool_input)\" >> ~/claude-audit.log'"
    }]
  }]
}
```

### 5. 用 LLM 检测代码中的硬编码密钥

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "prompt",
      "prompt": "这段写入内容里有没有硬编码的 API Key、密码或密钥？回答 yes 或 no。",
      "model": "claude-sonnet-4-20250514"
    }]
  }]
}
```

### 6. 会话启动时自动设置环境

```json
{
  "SessionStart": [{
    "matcher": "*",
    "hooks": [{
      "type": "command",
      "command": "bash -c 'echo \"export NODE_ENV=development\" >> \"$CLAUDE_ENV_FILE\"'"
    }]
  }]
}
```

---

## Hooks vs CLAUDE.md

| | CLAUDE.md | Hooks |
|---|---|---|
| **本质** | 写给 Claude 看的"规则" | 系统自动执行的"规则" |
| **执行者** | Claude 自己（可能忘） | 系统（一定执行） |
| **可靠性** | 软约束 | 硬约束 |
| **举例** | "请不要删除生产文件" | 拦截所有对 prod 文件的编辑 |

CLAUDE.md 是"请你遵守"，Hooks 是"你必须遵守"。

---

## 其他实用信息

- `/hooks` 命令可查看所有已配置的 hooks
- `$CLAUDE_PROJECT_DIR` 可在脚本中引用项目根目录
- Hook 输出注入上下文最多 10,000 字符
- `"disableAllHooks": true` 可禁用所有 hooks

---

## 关联

- [[entities/claude-code]] — Claude Code 工具概述
- [[concepts/agents-md]] — 项目级 AI 配置文件
- [[concepts/trust-infrastructure]] — Hooks 是信任基础设施的一部分
