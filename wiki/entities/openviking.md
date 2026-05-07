---
title: OpenViking
tags: [entity, tool, context-database, memory, agent, byte-dance]
date: 2026-04-27
sources: [https://github.com/volcengine/OpenViking]
---

# OpenViking

**类型**：AI Agent 上下文数据库（Context Database）
**开发方**：字节跳动火山引擎（Volcengine）
**开源协议**：AGPL-3.0（CLI 和 examples 为 Apache 2.0）
**Stars**：23.1k | **Forks**：1.7k | **Commits**：901+
**官网**：[openviking.ai](https://openviking.ai)

> 用文件系统的方式管理 Agent 的记忆、资源和技能——像管理本地文件一样构建 Agent 的大脑。

## 核心价值

传统 RAG 用向量数据库做扁平存储，OpenViking 用**虚拟文件系统**重新定义上下文管理：

| 传统 RAG 痛点 | OpenViking 方案 |
|---|---|
| 记忆、资源、技能分散在不同系统 | `viking://` 统一 URI 协议，一个入口管理所有上下文 |
| 扁平向量搜索缺乏全局感知 | 目录递归检索：先定位目录，再语义搜索，精准且可解释 |
| 全量加载 Token 消耗巨大 | L0/L1/L2 分层加载，按需取用，实测节省 83-91% 输入 Token |
| 检索过程黑盒，难以调试 | 每一步浏览和定位轨迹可追溯，上下文可见 |
| 记忆只有对话级，无法沉淀 | Session 结束自动提取长期记忆，Agent 越用越聪明 |

## 架构

```
viking://
├── resources/         # 文档、代码仓库、网页
├── user/              # 偏好、习惯、用户记忆
└── agent/             # 技能、指令、任务记忆
```

### 三层上下文（L0/L1/L2）

| 层级 | 大小 | 用途 |
|---|---|---|
| L0 Abstract | ~100 tokens | 一句话摘要，快速相关性判断 |
| L1 Overview | ~2k tokens | 核心信息和使用场景，规划阶段决策 |
| L2 Details | 全量 | 原始数据，深度阅读时加载 |

### 目录递归检索

1. 意图分析 → 生成多个检索条件
2. 向量检索定位高分目录
3. 在目录内二次检索
4. 递归进入子目录
5. 聚合结果输出

## 性能数据

基于 LoCoMo10 长对话基准（1,540 个案例）：

| 配置 | 任务完成率 | 输入 Token 成本 |
|---|---|---|
| OpenClaw 原版 | 35.65% | 24.6M |
| OpenClaw + LanceDB | 44.55% | 51.6M |
| OpenClaw + OpenViking | **52.08%** | **4.3M** |
| OpenClaw + OpenViking + memory-core | **51.23%** | **2.1M** |

任务完成率提升 **46%**，Token 成本降低 **91%**。

## 技术栈

Python ≥ 3.10、Go ≥ 1.22（AGFS 组件）、GCC 9+/Clang 11+

## 关联概念

- [[concepts/context-database]] — OpenViking 代表的上下文数据库新范式
- [[concepts/agent-memory]] — Agent 记忆机制的总览
- [[entities/memos]] — 同为 Agent 记忆服务，MemOS 是向量数据库方案，OpenViking 是文件系统方案
- [[entities/openclaw]] — OpenViking 的基准测试对象，两者可集成
- [[concepts/managed-agents]] — Anthropic 的 Brain/Hands/Session 架构，与 OpenViking 的上下文管理思路有交集
