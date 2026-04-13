---
title: 帖子签名值（signature）
tags: [58, post, reference]
date: 2026-04-09
sources: [sources/58-experience.md]
---

# 帖子签名值（signature）

帖子的 `signature` 字段标识帖子的来源类型，常见于 `QueryBasicInfoProcess` 接口返回值。

| signature | 中文含义 | 说明 |
|---|---|---|
| `ai_post` | AI 贴（老版） | 老版本 AI 自动生成帖子 |
| `ai_post_new` | 新 AI 贴 | 新版 AI 自动生成帖子 |
| `virtual_post` | 虚拟发帖 | 系统/虚拟账号发帖 |
| `expert_mode` | 专家模式 | 专家身份发帖或专家模式触发 |
| `feed_post` | 首页 Feed 电商贴 | 首页 Feed 接入电商场景 |
| `discover_vip` | 会员自己来 | HY-2234 会员自主发帖 |
| `smart_vip` | 智能客服 | 智能客服触发的发帖 |
| `self_clue_post` | 自建线索发帖（一期） | 商家自建线索发布 |
| `self_clue_post_v2` | 自建线索发帖（二期） | 自建线索发布 2.0 |
| `ka_post` | 大客户发帖（KA） | Key Account 大客户发帖 |

## 查帖子详情接口

```
# 基础信息
https://hyai.58.com/api/QueryBasicInfoProcess?infoid=<帖子ID>

# 详情数据
https://api.58.com/info/id-<帖子ID>/?api_id=20&api_type=data
```

## 查帖子修改记录

```sql
SELECT * FROM hdp_teu_spat_defaultdb.info_imcwrite
WHERE infoid = <帖子ID> AND dt >= 'YYYYMMDD';
```

相关：[[sources/58-experience]]
