---
name: openPRD-context7-integration
description: Use when any openPRD subagent needs to query the latest library/framework documentation. Triggers on "查文档", "查 API", "最新版本", "React 19", "Next.js 15", "库版本", "技术选型". Wraps the context7 MCP server (resolve-library-id + query-docs) into reusable call patterns for openPRD subagents. **所有涉及具体技术栈/库引用的产出文档都应该调用本 skill。**
---

# openPRD - context7 能力集成

## 概述

**目的**：把 **context7 MCP**（最新库文档查询）封装为 openPRD 内部可调用的 subagent，**让所有子技能在生成代码/接口/架构时自动查询最新库文档**，避免使用过时 API。

**重要性**：
- LLM 训练数据有截止日期（2025 年初），但库版本演进快
- 使用过时 API 会导致：报错 / 安全漏洞 / 性能问题
- 2026 年的库 API（如 React 19 RSC、Tailwind 4）与 2024 年差异巨大

**协作位置**：被所有 openPRD subagent 调用（特别是 document-generation、frontend-design、tech-trends）。

---

## 工具映射

| 工具 | 用途 | 调用模式 |
|------|------|----------|
| `mcp__context7__resolve-library-id` | 解析库名 → Context7 ID | 必先调用 |
| `mcp__context7__query-docs` | 查询指定库的最新文档/代码示例 | 主调用 |

---

## 标准调用流程

### 步骤 1：解析库 ID

```javascript
mcp__context7__resolve-library-id({
  query: "<具体使用场景描述>",
  libraryName: "<库官方名称，如 React、Next.js、Vue>"
})
```

**返回**：
```json
{
  "results": [
    {
      "id": "/vercel/next.js/v14.3.0-canary.87",
      "name": "Next.js",
      "codeSnippets": 5000,
      "sourceReputation": "High"
    }
  ]
}
```

**选择策略**：
1. **优先 High reputation** + **高 codeSnippets** 的库
2. **指定版本**时使用 `/{org}/{project}/{version}` 格式
3. **避免 Low/Unknown reputation** 的库

### 步骤 2：查询文档

```javascript
mcp__context7__query-docs({
  libraryId: "/vercel/next.js",
  query: "<具体问题描述，避免过于宽泛>"
})
```

**查询质量要点**：
- ✅ 具体问题："How to implement React Server Components in Next.js 15 with App Router"
- ❌ 宽泛问题："React hooks"
- ❌ 模糊问题："How to use React"

---

## openPRD 各 subagent 的调用场景

### 场景 1：技术选型时（`openPRD-tech-trends`）

```
需求：选择前端框架

调用 1: resolve-library-id({ query: "React Server Components", libraryName: "React" })
调用 2: resolve-library-id({ query: "Vue Composition API", libraryName: "Vue" })
调用 3: resolve-library-id({ query: "SvelteKit", libraryName: "SvelteKit" })

对比三者后，给出建议
```

### 场景 2：编写代码时（`openPRD-document-generation`）

```
需求：写一个 Next.js 15 的 API Route

调用: query-docs({
  libraryId: "/vercel/next.js",
  query: "Next.js 15 App Router API Route handler with TypeScript"
})
```

### 场景 3：引用库 API 时（`openPRD-frontend-design`、`openPRD-document-generation`）

```
需求：设计 Ant Design 表单

调用 1: resolve-library-id({ query: "Ant Design Form component", libraryName: "Ant Design" })
调用 2: query-docs({
  libraryId: "/ant-design/ant-design",
  query: "Form.useForm validation rules 2026"
})
```

### 场景 4：对比竞品库时（`openPRD-competitor-analysis`、`openPRD-tech-trends`）

```
需求：对比 Pinia vs Redux vs Zustand

调用 1: resolve-library-id({ query: "Pinia state management", libraryName: "Pinia" })
调用 2: resolve-library-id({ query: "Zustand state management", libraryName: "Zustand" })
调用 3: resolve-library-id({ query: "Redux Toolkit", libraryName: "Redux Toolkit" })
```

---

## 库查询常用清单

### 前端框架

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| React | `/facebook/react` |
| Next.js | `/vercel/next.js` |
| Vue | `/vuejs/core` |
| Nuxt | `/nuxt/nuxt` |
| SvelteKit | `/sveltejs/kit` |
| Angular | `/angular/angular` |
| Astro | `/withastro/astro` |

### UI 组件库

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| Ant Design | `/ant-design/ant-design` |
| Element Plus | `/element-plus/element-plus` |
| Material UI | `/mui/material-ui` |
| Chakra UI | `/chakra-ui/chakra-ui` |
| shadcn/ui | `/shadcn-ui/ui` |
| Tailwind CSS | `/tailwindlabs/tailwindcss.com` |

### 后端框架

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| Express | `/expressjs/express` |
| NestJS | `/nestjs/nest` |
| Fastify | `/fastify/fastify` |
| Spring Boot | `/spring-projects/spring-boot` |
| Django | `/django/django` |
| FastAPI | `/tiangolo/fastapi` |
| Gin | `/gin-gonic/gin` |
| Koa | `/koajs/koa` |

### 数据库

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| Prisma | `/prisma/prisma` |
| TypeORM | `/typeorm/typeorm` |
| Drizzle | `/drizzle-team/drizzle-orm` |
| Mongoose | `/Automattic/mongoose` |
| Sequelize | `/sequelize/sequelize` |
| Supabase | `/supabase/supabase` |

### 工具库

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| Zod | `/colinhacks/zod` |
| Lodash | `/lodash/lodash` |
| date-fns | `/date-fns/date-fns` |
| Day.js | `/iamkun/dayjs` |
| Axios | `/axios/axios` |
| TanStack Query | `/tanstack/query` |

### AI / 数据

| 库 | Context7 模式 ID 示例 |
|----|---------------------|
| LangChain | `/langchain-ai/langchain` |
| LlamaIndex | `/run-llama/llama_index` |
| Vector DBs | `/milvus-io/milvus`、`/qdrant/qdrant` |
| OpenAI | `/openai/openai-node` |
| Anthropic SDK | `/anthropics/anthropic-sdk-typescript` |

---

## 使用约束

### ⚠️ 限制

- **每日查询限额**：context7 有调用频率限制
- **库覆盖率**：仅收录知名库，小众库可能没有
- **代码示例可能简化**：需要根据实际项目调整

### ✅ 最佳实践

- **每个 subagent 至少调用 1 次 context7**（如果有具体技术栈）
- **优先使用 High reputation** 的库 ID
- **查询要具体**：具体 API + 具体版本
- **结果交叉验证**：与官方文档对比

### ❌ 避免

- 不要为简单问题调用 context7（浪费查询）
- 不要在用户没确认技术栈前就调用
- 不要把 context7 查询结果直接复制粘贴（要消化 + 适配）

---

## 与主 openPRD 的集成

```yaml
# 在主 SKILL.md 中描述
子技能:
  - openPRD-context7-integration: 库文档查询（context7 MCP 封装）
```

```yaml
# 在各 subagent 的 SKILL.md "外部能力集成" 章节
外部能力集成:
  - context7: mcp__context7__resolve-library-id + mcp__context7__query-docs
```

---

## Gotchas (避坑指南)

### G-01: 库不存在/不收录时静默 fallback 到 WebSearch,版本不对应
- **症状**: 查 `enterprise-magic-sdk`(小众内部库),context7 返回空,agent 静默用 WebSearch 补充,但 WebSearch 结果可能是 2023 年的旧文档
- **原因**: WebSearch 不带版本号,默认返回"近期 + 热门"内容,而小众库更新慢
- **修正**: context7 查询返回空时,显式标 **"⚠️ 未验证版本"** + 调用时间戳。绝不能假装"已验证"。3 步策略:(1) context7 resolve-library-id 失败(2) 立即改用项目 README 实际版本(3) 标注"参考社区资料,非库官方文档"。例:examples/02 §关键章节节选 §2.2 库版本一致性。
- **参考**: openPRD-context7-integration §使用约束 ⚠️ 限制

### G-02: "react" vs "react-native" 等同名库,resolve-library-id 选错
- **症状**: 想查 React(网页端),context7 返回 React Native 文档(混淆同名)
- **原因**: resolve-library-id 按"关键词相似度"排序,可能把 React Native 排前面
- **修正**: resolve-library-id 返回多个结果时,**手动选 `id` 包含 `react` 但**不**含 `-native` / `-dom` 的**。3 字段确认:(1) sourceReputation=High (2) codeSnippets 高 (3) id 路径与目标库一致(例:`/facebook/react` ≠ `/react-native/react-native`)。
- **参考**: openPRD-context7-integration §选择策略

### G-03: query-docs 问题太宽泛("How to use React"),返回无关内容
- **症状**: 问"React",返回 5000 字符通用教程,但实际要"React 19 RSC + Server Actions 怎么写"
- **原因**: query 太宽 → 模型自由发挥
- **修正**: 3 字段精准查询:**库名 + 版本 + 具体 API 名 + 场景**。例:"React 19 useFormStatus with Server Action" 优于 "React hooks"。查询模板:**"[库名] [版本] [具体 API/方法] in [场景]"**。参考 §查询质量要点。
- **参考**: openPRD-context7-integration §查询质量要点

### G-04: 不指定版本,拿到的是 main 分支(可能是 breaking change 草稿)
- **症状**: 查 `/vercel/next.js`,拿到的是开发中 main 分支,API 跟生产 15.x 完全不同
- **原因**: 不带版本 → 默认最新
- **修正**: 必带版本号:`/vercel/next.js/v15.0.0`。生产项目用 LTS 版本,尝鲜项目用 latest + 标注"实验性"。3 字段库 ID 模板:**"/{org}/{project}" 默认开发版 / "/{org}/{project}/v{version}" 指定版本**。
- **参考**: openPRD-context7-integration §库查询常用清单

### G-05: 直接复制粘贴 context7 例子,与项目实际类型/版本不一致
- **症状**: 复制 React 18 `useState` 例子,但项目用 React 19 + TypeScript strict,例子中类型定义不全
- **原因**: context7 例子是"通用模板",不针对项目栈
- **修正**: 复制后必做 3 步:(1) 类型补全(TypeScript strict) (2) 错误处理(try-catch) (3) 项目命名空间调整。context7 例子是"骨架",不是"即用代码"。参考 §✅ 最佳实践"结果交叉验证"。
- **参考**: openPRD-context7-integration §✅ 最佳实践

**跨子技能常见错误汇总**: 见 [reference/16-common-pitfalls.md](./../reference/16-common-pitfalls.md)