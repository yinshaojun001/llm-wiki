---
title: LLM 语义路由——用 Sonnet 选记忆而非向量搜索
tags: [claude-code, memory, agent, context-engineering, recall]
date: 2026-05-05
sources: [entities/claude-code]
---

# LLM 语义路由

> 源码：`src/memdir/findRelevantMemories.ts`、`src/memdir/memoryScan.ts`

[[concepts/claude-code-memory|← 记忆系统总览]]

---

## 传统做法 vs Claude Code 的做法

**传统做法**：向量相似度搜索
- 把记忆和查询都转成 embedding
- 算余弦相似度，返回 top-K
- 问题："语义相似" ≠ "对当前任务有用"

**Claude Code 的做法**：用 Sonnet 选哪些记忆对当前查询有用
- 不算向量，不做相似度
- 直接问 LLM："给定这个查询，哪些记忆有用？"
- LLM 能理解推理链："用户在调试数据库 → 需要之前关于数据库 mock 的教训"

---

## 完整流程

```
用户发消息
    │
    ▼
scanMemoryFiles()                    ← 1. 扫描所有 .md 文件
    │                                    只读 frontmatter（前 30 行）
    │                                    排除 MEMORY.md
    │                                    上限 200 个文件
    │
    ▼
filter(alreadySurfaced)              ← 2. 过滤已展示过的记忆
    │
    ▼
formatMemoryManifest()               ← 3. 格式化为清单
    │                                    "- [type] filename (ISO timestamp): description"
    │
    ▼
selectRelevantMemories()             ← 4. 调用 Sonnet sideQuery
    │                                    system: "选 ≤5 个有用的记忆"
    │                                    user: "查询 + 清单 + 最近使用的工具"
    │                                    output: JSON { selected_memories: string[] }
    │
    ▼
注入为 <system-reminder> 附件        ← 5. 被选中的记忆内容注入 context
    附带时间衰减警告
```

---

## 扫描阶段

`memoryScan.ts:35-77` 的 `scanMemoryFiles()`：

```typescript
export async function scanMemoryFiles(memoryDir, signal): Promise<MemoryHeader[]> {
  // 1. 递归读取目录下所有 .md 文件（排除 MEMORY.md）
  const entries = await readdir(memoryDir, { recursive: true })
  const mdFiles = entries.filter(f => f.endsWith('.md') && basename(f) !== 'MEMORY.md')

  // 2. 并行读取每个文件的前 30 行（只取 frontmatter）
  const headerResults = await Promise.allSettled(
    mdFiles.map(async (relativePath) => {
      const { content, mtimeMs } = await readFileInRange(filePath, 0, 30, ...)
      const { frontmatter } = parseFrontmatter(content, filePath)
      return {
        filename: relativePath,
        filePath,
        mtimeMs,
        description: frontmatter.description || null,
        type: parseMemoryType(frontmatter.type),
      }
    }),
  )

  // 3. 按修改时间倒序，取前 200 个
  return headerResults
    .sort((a, b) => b.mtimeMs - a.mtimeMs)
    .slice(0, MAX_MEMORY_FILES)  // 200
}
```

关键设计：
- **只读前 30 行**：只需要 frontmatter（name, description, type），不读正文 → 省 token
- **排除 MEMORY.md**：它已在 system prompt 中
- **上限 200 个**：控制 manifest 大小
- **Promise.allSettled**：单个文件读取失败不影响其他文件

---

## 清单格式

`memoryScan.ts:84-94` 的 `formatMemoryManifest()`：

```typescript
export function formatMemoryManifest(memories: MemoryHeader[]): string {
  return memories.map(m => {
    const tag = m.type ? `[${m.type}] ` : ''
    const ts = new Date(m.mtimeMs).toISOString()
    return m.description
      ? `- ${tag}${m.filename} (${ts}): ${m.description}`
      : `- ${tag}${m.filename} (${ts})`
  }).join('\n')
}
```

输出示例：

```
- [feedback] feedback_code_style.md (2026-05-03T10:00:00Z): 用户偏好函数式风格
- [user] user_role.md (2026-05-01T08:00:00Z): 7 年 Java，刚转前端
- [reference] ref_pipeline_bugs.md (2026-04-28T12:00:00Z): Pipeline bugs 在 Linear INGEST
```

---

## Sonnet 选择器

`findRelevantMemories.ts:18-24` 的 system prompt：

```typescript
const SELECT_MEMORIES_SYSTEM_PROMPT = `You are selecting memories that will be useful to Claude Code 
as it processes a user's query. You will be given the user's query and a list of available memory files 
with their filenames and descriptions.

Return a list of filenames for the memories that will clearly be useful (up to 5). 
Only include memories that you are certain will be helpful.
- If you are unsure, do not include it. Be selective and discerning.
- If there are no useful memories, return an empty list.
- If recently-used tools are provided, do not select usage reference docs for those tools 
  (Claude Code is already exercising them). DO still select warnings/gotchas about those tools.
`
```

### 工具感知

`findRelevantMemories.ts:92-95`：

```typescript
const toolsSection = recentTools.length > 0
  ? `\n\nRecently used tools: ${recentTools.join(', '})`
  : ''
```

把"最近使用的工具"传给选择器。效果：
- 用户正在用 `mcp__jira` → 不选 Jira 使用手册（已经在用了）
- 但**会选** Jira 的注意事项（"Jira 的 MCP 连接有时超时，需要重试"）

这是比纯语义匹配更聪明的策略：**知道用户正在做什么**，然后选"做这件事时需要知道的坑"。

### 结构化输出

`findRelevantMemories.ts:109-118`：

```typescript
output_format: {
  type: 'json_schema',
  schema: {
    type: 'object',
    properties: {
      selected_memories: { type: 'array', items: { type: 'string' } },
    },
    required: ['selected_memories'],
  },
},
max_tokens: 256,
```

强制 Sonnet 输出 JSON，最多 256 tokens。解析可靠，成本可控。

### 去重

`findRelevantMemories.ts:46-48`：

```typescript
const memories = (await scanMemoryFiles(memoryDir, signal)).filter(
  m => !alreadySurfaced.has(m.filePath),
)
```

已展示过的记忆被过滤。选择器的 5 个名额只花在新候选上。

### 失败降级

`findRelevantMemories.ts:131-140`：

```typescript
} catch (e) {
  if (signal.aborted) return []
  logForDebugging(`[memdir] selectRelevantMemories failed: ${errorMessage(e)}`)
  return []  // 失败返回空，不影响主流程
}
```

记忆召回失败不会阻塞主对话。这是 **graceful degradation**。

---

## 成本分析

每次记忆召回的成本：
- 扫描 200 个文件的前 30 行：~100ms I/O
- Sonnet sideQuery：~256 output tokens + ~2K input tokens（清单 + 指令）
- 读取 ≤5 个记忆文件：~1-5KB

总成本约 $0.001-0.003/次。比向量搜索的基础设施成本低得多（不需要向量数据库、embedding 模型）。

---

## 做 Agent 时如何借鉴

1. **用 LLM 做语义路由比向量搜索更精准**：如果预算允许
2. **只传 frontmatter 给选择器**：不传全文，省 token
3. **工具感知是关键**：知道用户正在做什么，才能选对记忆
4. **强制结构化输出**：JSON schema，不要让 LLM 自由发挥
5. **失败要降级**：记忆召回失败不能阻塞主流程
6. **去重**：同一会话内不要重复展示相同记忆

---

## 相关页面

- [[concepts/claude-code-memory|← 记忆系统总览]]
- [[concepts/claude-code-memory-index-content-separation|索引-内容分离]]
- [[concepts/claude-code-memory-staleness|过期管理]]
- [[concepts/claude-code-memory-principles|十大设计原则]]
