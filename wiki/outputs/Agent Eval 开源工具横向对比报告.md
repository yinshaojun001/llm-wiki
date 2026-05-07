  
> 调研时间：2026年4月 | 聚焦企业可用的开源 Agent 评估工具



---
## 一、工具概览

  

| 工具 | GitHub Stars | 许可证 | 维护方 | 定位 |

|------|-------------|--------|--------|------|

| **Langfuse** | ~20,000+ | MIT (核心) + 企业版 | Langfuse GmbH (YC W23) | LLM 工程平台 (可观测性 + 评估 + Prompt 管理) |

| **Arize Phoenix** | ~9,200 | Apache 2.0 | Arize AI | AI 可观测性 & 评估 |

| **Ragas** | ~7,000+ | Apache 2.0 | VibrantLabs | RAG 评估框架 (指标库) |

| **DeepEval** | ~15,000 | Apache 2.0 | Confident AI | LLM 评估框架 + 平台 |

| **Promptfoo** | ~20,700 | MIT | OpenAI (已收购) | LLM 安全测试 & 红队 |

| **Braintrust** | N/A (商业) | 部分开源 | Braintrust Inc. ($80M B轮) | AI 可观测性 & 评估平台 |

  

---

  

## 二、功能能力对比

  

### 2.1 支持的 Agent 类型

  

| 工具 | ReAct | Function Calling | Multi-Agent | RAG | 自定义 Agent |

|------|-------|-----------------|-------------|-----|-------------|

| Langfuse | ✅ | ✅ | ✅ | ✅ | ✅ (OTEL) |

| Arize Phoenix | ✅ | ✅ | ✅ | ✅ | ✅ (OTEL) |

| Ragas | ⚠️ 有限 | ⚠️ 有限 | ❌ | ✅ 强 | ⚠️ |

| DeepEval | ✅ | ✅ | ✅ | ✅ | ✅ |

| Promptfoo | ✅ | ✅ | ✅ | ✅ | ✅ |

| Braintrust | ✅ | ✅ | ✅ | ✅ | ✅ |

  

### 2.2 评估维度 & 指标

  

| 工具 | 准确性 | 延迟 | 成本 | 安全性 | 幻觉检测 | 自定义指标 | 回归测试 |

|------|--------|------|------|--------|----------|-----------|---------|

| Langfuse | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |

| Arize Phoenix | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |

| Ragas | ✅ | ❌ | ❌ | ❌ | ✅ 强 | ✅ | ⚠️ |

| DeepEval | ✅ | ✅ | ✅ | ✅ | ✅ (30+指标) | ✅ | ✅ |

| Promptfoo | ✅ | ⚠️ | ⚠️ | ✅ 强 | ✅ | ✅ | ✅ |

| Braintrust | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |

  

### 2.3 评估方法

  

| 工具 | LLM-as-Judge | 人工评估 | 基准测试 | 自动化评估 | 红队测试 |

|------|-------------|---------|---------|-----------|---------|

| Langfuse | ✅ | ✅ | ✅ | ✅ | ❌ |

| Arize Phoenix | ✅ | ✅ | ✅ | ✅ | ❌ |

| Ragas | ✅ | ❌ | ✅ | ✅ | ❌ |

| DeepEval | ✅ (30+ judges) | ✅ | ✅ | ✅ | ⚠️ |

| Promptfoo | ✅ | ⚠️ | ✅ | ✅ | ✅ 强 |

| Braintrust | ✅ | ✅ | ✅ | ✅ | ❌ |

  

---

  

## 三、技术特性对比

  

### 3.1 框架兼容性 & SDK

  

| 工具 | Python | JS/TS | REST API | LangChain | LlamaIndex | OpenAI | OTEL |

|------|--------|-------|----------|-----------|------------|--------|------|

| Langfuse | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ 原生 |

| Arize Phoenix | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ 原生 |

| Ragas | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |

| DeepEval | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ |

| Promptfoo | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

| Braintrust | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |

  

### 3.2 部署方式

  

| 工具 | 本地运行 | 自托管 | SaaS | Docker | K8s |

|------|---------|--------|------|--------|-----|

| Langfuse | ✅ | ✅ | ✅ (US/EU/HIPAA) | ✅ | ✅ |

| Arize Phoenix | ✅ | ✅ | ✅ (Arize AX) | ✅ | ⚠️ |

| Ragas | ✅ (库) | N/A | ❌ | N/A | N/A |

| DeepEval | ✅ | ✅ | ✅ (Confident AI) | ⚠️ | ⚠️ |

| Promptfoo | ✅ | ✅ | ✅ | ✅ | ✅ |

| Braintrust | ⚠️ | ✅ (混合) | ✅ | ⚠️ | ⚠️ |

  

### 3.3 数据存储 & 可观测性

  

| 工具 | Trace 可视化 | 日志 | 仪表盘 | 数据导出 | Prompt 版本管理 |

|------|-------------|------|--------|---------|----------------|

| Langfuse | ✅ 强 | ✅ | ✅ | ✅ | ✅ |

| Arize Phoenix | ✅ 强 | ✅ | ✅ | ✅ | ❌ |

| Ragas | ❌ | ❌ | ❌ | ⚠️ | ❌ |

| DeepEval | ✅ (Confident AI) | ✅ | ✅ | ✅ | ✅ |

| Promptfoo | ⚠️ | ✅ | ⚠️ | ✅ | ❌ |

| Braintrust | ✅ 强 | ✅ | ✅ | ✅ | ✅ |

  

---

  

## 四、企业就绪度对比

  

### 4.1 文档 & 社区

  

| 工具 | 文档质量 | GitHub Stars | 贡献者数 | 社区活跃度 |

|------|---------|-------------|---------|-----------|

| Langfuse | ⭐⭐⭐⭐⭐ | 20,000+ | 活跃 | 非常活跃 (Launch Weeks, Discord) |

| Arize Phoenix | ⭐⭐⭐⭐ | 9,200 | ~170 | 中等 (不接受外部功能贡献) |

| Ragas | ⭐⭐⭐ | 7,000+ | 活跃 | 中等 (Discord, 咨询服务) |

| DeepEval | ⭐⭐⭐⭐⭐ | 15,000 | 256 | 非常活跃 (Discussions) |

| Promptfoo | ⭐⭐⭐⭐⭐ | 20,700 | 活跃 | 非常活跃 (406 releases) |

| Braintrust | ⭐⭐⭐⭐ | N/A | 企业导向 | 中等 (企业客户为主) |

  

### 4.2 安全合规

  

| 工具 | SOC 2 | HIPAA | GDPR | SSO | RBAC | 审计日志 | 数据驻留 |

|------|-------|-------|------|-----|------|---------|---------|

| Langfuse | ✅ Type II | ✅ (区域) | ✅ | ✅ | ✅ | ✅ (企业版) | ✅ |

| Arize Phoenix | ✅ (AX) | ✅ (AX) | ⚠️ | ✅ (AX) | ✅ | ⚠️ | ✅ |

| Ragas | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | N/A |

| DeepEval | ✅ (CI平台) | ✅ (CI平台) | ⚠️ | ✅ | ✅ | ✅ | ✅ |

| Promptfoo | ✅ (企业) | ✅ (企业) | ⚠️ | ✅ | ✅ | ⚠️ | ✅ |

| Braintrust | ✅ Type II | ✅ | ✅ | ✅ (SAML) | ✅ 精细 | ✅ | ✅ |

  

### 4.3 商业支持

  

| 工具 | 企业版 | 定价 | 知名客户 |

|------|--------|------|---------|

| Langfuse | ✅ (自托管企业版) | 免费起, 企业版自定义 | Canva, Khan Academy, Merck |

| Arize Phoenix | ✅ (Arize AX) | 企业定价 | ML/生产 AI 监控领域 |

| Ragas | ❌ (仅咨询服务) | 免费 | LangChain/LlamaIndex 社区 |

| DeepEval | ✅ (Confident AI) | $19.99/人/月起 | 1,200+ 依赖仓库 |

| Promptfoo | ✅ | 企业定价 | 127 家 Fortune 500, OpenAI, Anthropic |

| Braintrust | ✅ | 企业定价 | Notion, Vercel, BILL, Navan |

  

---

  

## 五、集成能力对比

  

### 5.1 CI/CD 集成

  

| 工具 | GitHub Actions | Jenkins | pytest 集成 | CLI 工具 | 自动化程度 |

|------|---------------|---------|------------|---------|-----------|

| Langfuse | ✅ (Webhook) | ⚠️ | ⚠️ | ✅ | 高 |

| Arize Phoenix | ⚠️ | ⚠️ | ⚠️ | ✅ | 中 |

| Ragas | ⚠️ | ⚠️ | ✅ | ⚠️ | 中 |

| DeepEval | ✅ | ⚠️ | ✅ 原生 | ✅ 强 | 非常高 |

| Promptfoo | ✅ 原生 | ✅ | ⚠️ | ✅ 强 | 非常高 |

| Braintrust | ✅ (Action) | ⚠️ | ⚠️ | ✅ | 高 |

  

### 5.2 可观测性平台集成

  

| 工具 | LangSmith | Arize | Phoenix | 自有平台 | OTEL |

|------|-----------|-------|---------|---------|------|

| Langfuse | ❌ (竞品) | ❌ (竞品) | ❌ | ✅ 自有 | ✅ |

| Arize Phoenix | ❌ | ✅ 自有 | ✅ | ✅ Arize AX | ✅ |

| Ragas | ✅ | ✅ | ✅ | ❌ | ❌ |

| DeepEval | ⚠️ | ⚠️ | ⚠️ | ✅ Confident AI | ❌ |

| Promptfoo | ❌ | ❌ | ❌ | ⚠️ 有限 | ❌ |

| Braintrust | ❌ | ❌ | ❌ | ✅ 自有 | ⚠️ |

  

### 5.3 告警 & 通知

  

| 工具 | Slack | Email | PagerDuty | Teams | Webhook |

|------|-------|-------|-----------|-------|---------|

| Langfuse | ✅ | ⚠️ | ⚠️ (MCP) | ❌ | ✅ (HMAC) |

| Arize Phoenix | ⚠️ (AX) | ⚠️ | ⚠️ | ❌ | ⚠️ |

| Ragas | ❌ | ❌ | ❌ | ❌ | ❌ |

| DeepEval | ✅ | ⚠️ | ✅ | ✅ | ⚠️ |

| Promptfoo | ⚠️ | ⚠️ | ❌ | ❌ | ⚠️ |

| Braintrust | ⚠️ | ⚠️ | ❌ | ❌ | ⚠️ |

  

---

  

## 六、综合评级

  

| 维度 | Langfuse | Arize Phoenix | Ragas | DeepEval | Promptfoo | Braintrust |

|------|----------|---------------|-------|----------|-----------|------------|

| 功能完整度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

| 企业就绪度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

| 开发者体验 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

| 社区生态 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

| 安全合规 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

| CI/CD 集成 | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

  

---

  

## 七、选型建议

  

### Tier 1 - 企业生产就绪

  

**Langfuse** — 最全面的开源 LLM 工程平台

- 适合：需要可观测性 + 评估 + Prompt 管理一体化的团队

- 优势：MIT 许可、SOC2+ISO27001+HIPAA、20k+ stars、Canva/Khan Academy 等大客户

- 2025年6月已开源所有产品功能

  

**Braintrust** — 最强企业安全合规

- 适合：合规要求严格 (SOC2+HIPAA+GDPR)、需要混合部署的企业

- 优势：$80M B轮、Notion/Vercel/BILL 客户、精细 RBAC、审计日志

- 注意：非完全开源，商业模型为主

  

**Promptfoo** — AI 安全测试标杆

- 适合：重点关注 LLM 安全、红队测试、合规验证的团队

- 优势：127 家 Fortune 500、已被 OpenAI 收购、MIT 许可、406 releases

- 2025年被 OpenAI 收购，将集成进 OpenAI Frontier

  

### Tier 2 - 强劲且有企业路径

  

**DeepEval / Confident AI** — 评估优先、开发者体验最佳

- 适合：注重 CI/CD 集成、需要 30+ 评估指标的团队

- 优势：pytest 原生集成、15k stars、256 贡献者、SOC2+HIPAA (Confident AI)

- $19.99/人/月起步，企业版支持本地部署

  

**Arize Phoenix** — ML 可观测性基因

- 适合：已有 ML 基础设施、扩展到 LLM/Agent 应用的团队

- 优势：SOC2+PCI DSS+HIPAA (Arize AX)、原生 OTEL、强 Trace 能力

- 注意：不接受外部功能贡献

  

### Tier 3 - 库/框架 (非独立企业平台)

  

**Ragas** — RAG 评估指标库

- 适合：需要高质量 RAG 评估指标、嵌入到其他平台使用

- 优势：RAG 评估领域最专业、LangChain/LlamaIndex 官方推荐

- 注意：无平台层、无 RBAC/SSO/审计、需配合 Langfuse/Arize 等使用

  

---

  

## 八、决策矩阵

  

```

需求优先级 → 推荐工具

  

可观测性 + 评估一体化 → Langfuse

AI 安全 & 红队测试 → Promptfoo

严格合规 & 企业级部署 → Braintrust

CI/CD 深度集成 & 开发者体验 → DeepEval

ML 可观测性扩展 → Arize Phoenix

RAG 专项评估 → Ragas (搭配平台使用)

```

  

---

  

*报告基于 2026年4月公开信息整理，工具生态变化较快，建议定期更新。*