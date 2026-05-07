---
title: Java 工程师视角
tags: [agent-engineering, java, mindset]
date: 2026-04-28
---

# Java 工程师视角

> 你七年的 Java 工程经验在 Agent 时代不仅没有过时，很多恰好是这个阶段最稀缺的。

---

## 一、Java 概念 → Agent 概念速查

| Java 概念 | Agent 对应 | 相似度 |
|---|---|---|
| Self-Attention | 动态加权路由——Query 匹配 Key，聚合 Value | ⭐⭐⭐ |
| Multi-Head Attention | 多线程同时检查代码的语法/性能/安全 | ⭐⭐⭐ |
| Residual Connection | try-catch 的 finally 块——原始信息总能传过去 | ⭐⭐⭐⭐ |
| KV Cache | Redis 缓存——算过的不重复算 | ⭐⭐⭐⭐⭐ |
| RAG | 给新同事代码库索引让他搜了再回答 | ⭐⭐⭐⭐ |
| Chunking | 数据库分页——太大一次查太多，太小需要多次 round-trip | ⭐⭐⭐⭐ |
| Function Calling | 接口定义——方法签名 + 描述，LLM 决定何时调用 | ⭐⭐⭐⭐⭐ |
| Tool Schema | REST API 文档——写得好调用方自然用对 | ⭐⭐⭐⭐⭐ |
| ReAct 循环 | `while (!done) { think(); act(); observe(); }` | ⭐⭐⭐⭐⭐ |
| Plan-and-Solve | 瀑布模型——先设计再编码 | ⭐⭐⭐⭐ |
| Reflexion | 事故复盘 postmortem——出了 bug 写总结，下次避免 | ⭐⭐⭐⭐⭐ |
| Orchestrator | API Gateway——路由分发，聚合响应 | ⭐⭐⭐⭐⭐ |
| Agent Handoff | 责任链模式——一个 Handler 做完交给下一个 | ⭐⭐⭐⭐⭐ |
| 短期记忆 | 本地变量（作用域结束就没了） | ⭐⭐⭐⭐ |
| 工作记忆 | ThreadLocal（当前任务独享） | ⭐⭐⭐⭐ |
| 长期记忆 | 数据库（持久化，按需查询） | ⭐⭐⭐⭐⭐ |
| 记忆衰减 | LRU Cache 淘汰策略 | ⭐⭐⭐⭐ |
| Input Guardrail | XSS/SQL 注入防护——用户输入不可信 | ⭐⭐⭐⭐⭐ |
| 熔断 | Hystrix/Sentinel——失败率达阈值自动熔断 | ⭐⭐⭐⭐⭐ |
| Human-in-the-Loop | 审批流程——高风险操作需 manager approve | ⭐⭐⭐⭐⭐ |
| 审计日志 | 操作审计表——谁在什么时候做了什么 | ⭐⭐⭐⭐⭐ |
| Golden Test Set | 回归测试套件——每次提交都跑 | ⭐⭐⭐⭐⭐ |
| LLM-as-a-Judge | Code Review——另一个"审查者"判断质量 | ⭐⭐⭐⭐ |
| 评估 Pipeline | CI/CD 的 test stage——不通过不发版 | ⭐⭐⭐⭐⭐ |
| MCP | Service Mesh——服务间通信标准化 | ⭐⭐⭐ |
| Agent 渐进发布 | 金丝雀发布 / 灰度发布 | ⭐⭐⭐⭐⭐ |

---

## 二、关键思维转变

| 传统开发 | Agent 开发 |
|---|---|
| 构建功能确定的程序 | 构建能自主规划与行动的系统 |
| 输入→处理→输出（确定性） | 感知→规划→行动→观察（动态循环） |
| 不确定性视为 Bug，消除它 | 不确定性视为环境属性，用反思和纠错应对 |
| 开发者预定义所有逻辑 | 开发者定义目标和约束边界 |
| 测试输出是否正确 | 测试推理路径 + 工具选择 + 行为 |
| 一次性上线 | Shadow → Canary → 渐进放量 |
| 性能优化靠 Profiler | 性能优化靠模型路由 + KV Cache + Token 预算 |
| Bug 修复靠 Debugger | Bug 修复靠 Trace 回溯 + Reflexion 自我纠正 |

---

## 三、你已有的优势（Agent 行业极度稀缺）

| 你的经验 | 在 Agent 开发中的价值 |
|---|---|
| **系统可靠性设计** | Agent 最缺的就是可靠性——熔断、降级、重试、超时，全是你的日常 |
| **监控与告警** | 大部分 Agent 开发者不懂可观测性，你天天跟 Prometheus/Grafana 打交道 |
| **发布与回滚** | 渐进式发布（金丝雀→灰度→全量）你已经在做了，Agent 完全一样 |
| **异常处理** | Agent 的执行路径不确定，异常处理比传统系统更重要——这是你的强项 |
| **API 设计** | Tool Schema 就是 API 设计——命名、参数、错误码，一模一样 |
| **数据库与缓存** | Memory 系统的底层就是存储+检索，向量数据库只是新存储引擎 |
| **分布式系统思维** | 多 Agent 协作本质是分布式系统——通信协议、超时、一致性、故障隔离 |

---

## 四、你需要补的（但比想象中少）

| 需要补的 | 深度 | 时间 |
|---|---|---|
| Transformer 数据流理解 | "发动机原理"级别 | 2 周 |
| Python 基础（你大概率已经有） | 足够写 Agent 应用 | 边做边学 |
| Prompt 设计思维 | 理解原理而非记模板 | 2 周 |
| 评估方法论 | LLM-as-Judge + Golden Test Set | 2 周 |
| 非确定性系统的思维方式 | 接受"同一个输入可能得到不同输出" | 持续 |

---

## 关联

- [[00-总览]]
- [[10-不易变化的基础]]
- [[11-Agent核心组件]]
