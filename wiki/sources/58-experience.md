---
title: "源：58 工作经验集"
tags: [source, 58, engineering, java, operations]
date: 2026-04-09
sources: [58 经验/]
---

# 源：58 工作经验集

**原始位置**：`Obsidian Vault/58 经验/`（18 篇）
**内容性质**：工作中积累的操作 SOP、技术深度笔记、AI 工具调研

---

## 业务背景

商家端核心链路：**商家 → 充值/购买 → 权益/曝光 → 线索 → 成交 → 续费**

技术栈：Java Spring、JdbcTemplate、SCF（服务框架）、ESB（消息总线）、Hive、云平台

---

## 三类内容

### 1. 工程操作 SOP

| 场景 | 关键点 |
|---|---|
| 上线 | 提完代码需**重新构建 release 分支** |
| 集群下线 | 删除部署 → 观察两天 → 删除集群 → 截图机器 IP 留存 |
| 服务下线 | 解除调用方绑定 → 删除云存储 |
| 排查调用方 | 云平台 → 服务集群 → 查调用关系 |
| 本地调线上 | scf.config 配置指向线上集群 |
| 查帖子详情 | `hyai.58.com/api/QueryBasicInfoProcess?infoid=<ID>` 或 `api.58.com/info/id-<ID>/?api_id=20&api_type=data` |
| 查帖子修改记录 | Hive 表 `hdp_teu_spat_defaultdb.info_imcwrite`，按 infoid + dt 过滤 |

### 2. 技术深度笔记

- [[concepts/jdbctemplate-resource-management]]：Spring JdbcTemplate 统一管理 Connection/Statement 生命周期，不需要手动关闭，Sonar AI 修复建议会误导

### 3. AI 工具调研

- [[entities/next-ai-draw-io]]：AI 驱动的 draw.io 图表工具，18k stars，支持自然语言→可编辑图结构
