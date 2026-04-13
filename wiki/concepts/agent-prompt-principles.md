---
title: Agent Prompt 设计原则
tags: [concept, agent, prompt-engineering, coding-agent, evergreen]
date: 2026-04-09
sources: [sources/research-overview.md]
---

# Agent Prompt 设计原则

> 来源：对 Claude Code、OpenAI Codex、Gemini CLI 等 system prompt 的横向比较研究（2026-04-03）

判断标准：**这条如果不写，agent 是否更容易越权、漂移、失真或交付低质量结果？**

---

## 最高优先级（4 条）

### 1. 明确默认动作哲学
区分"分析请求"和"执行请求"。分析请求默认不改文件，歧义时明确何时假设、何时提问。

### 2. 过程可见性是硬约束
meaningful tool call 前先同步一句；长任务中途报进展；最终答复交代结果、验证和剩余风险。**静默工作五分钟突然扔结果 = 反模式。**

### 3. 复杂任务必须有计划
多步骤任务拆成可验证步骤，执行中更新状态，而不是只在开头列清单然后不回头。

### 4. 验证是完成定义的一部分
"改完了"不等于"完成了"。未验证 = 猜测。必须覆盖行为、测试、构建/lint、项目约束一致性。

---

## 执行边界（4 条）

5. **本地规则优先**：`AGENTS.md`/`GEMINI.md`/`CLAUDE.md` 等本地规则优先于默认行为，冲突时以本地为准
6. **文件修改策略收紧**：先读再改，优先最小必要变更，不顺手重构/重命名
7. **Git 安全规则具体化**：明确禁止 destructive git commands；未经要求不 commit、不 push
8. **安全边界具体到对象**：不打印/提交/扩散 key、token、`.env`；对越权写入、联网操作有明确策略

---

## 工程组织（4 条）

9. **工具选择系统化**：专用工具优先于 shell 拼接；项目已有 formatter/fixer 时优先复用
10. **用户意图显式分类**：至少区分"分析/执行/混合"，不同类型对应不同权限
11. **过程透明和表达克制平衡**：同步的是"状态、判断、下一步"，不是冗长自言自语
12. **Prompt 本质是流程编码**：不是人格文案，而是把团队流程、权限模型和质量门槛编码进去

---

## 最小可用版（8 条核心）

1. 明确区分分析请求和执行请求
2. 分析请求默认不改文件
3. meaningful tool call 前先同步一句
4. 复杂任务必须有计划或 todo
5. 修改前先读相关上下文
6. 优先最小必要改动，不顺手重构
7. 未经要求不 commit、不 push，禁止 destructive git
8. **未验证，不算完成；无法验证时必须明说**

---

## 关联

- [[concepts/trust-infrastructure]]（这 12 条原则是信任基础设施在 prompt 层的具体落地）
- [[entities/claude-code]]（研究对象之一）
- [[concepts/agents-md]]（本地规则优先级的载体）
