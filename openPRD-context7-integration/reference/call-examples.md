# context7 调用示例库

> **目的**：为 openPRD 各子技能提供 context7 工具的标准化调用模式，按"库/框架"分类组织。

---

## 1. 通用调用流程

```javascript
// 1. 解析库 ID（一次）
const libId = await mcp__context7__resolve_library_id({
  query: "<研究主题>",
  libraryName: "<库名>"
})

// 2. 查询文档（多次，每库最多 3 次）
const docs = await mcp__context7__query-docs({
  libraryId: libId,  // 如 "/vercel/next.js"
  query: "<具体问题>"
})
```

**最佳实践**：
- 每个问题最多 3 次 resolve-library-id + query-docs 调用
- 优先选 High reputation + 较高 benchmark score 的库
- query 包含具体场景和限制条件（避免泛问）

---

## 2. 库 ID 速查表（按场景）

### 2.1 前端框架

| 库 | Library ID | 适用场景 |
|----|-----------|----------|
| React | `/reactjs/react.dev` 或 `/facebook/react` | 通用 |
| Next.js | `/vercel/next.js` | SSR/SSG/全栈 |
| Vue 3 | `/vuejs/docs` 或 `/vuejs/vue` | 渐进式 |
| Nuxt 3 | `/nuxt/nuxt` | Vue 全栈 |
| Svelte | `/sveltejs/svelte` | 编译时 |
| Solid.js | `/solidjs/solid` | 性能优先 |
| Angular | `/angular/angular` | 大型政企 |
| Qwik | `/QwikDev/qwik` | 可恢复 |
| Astro | `/withastro/docs` | 内容站 |

### 2.2 UI 组件库

| 库 | Library ID | 特点 |
|----|-----------|------|
| Ant Design | `/ant-design/ant-design` | 企业级中文 |
| Material UI | `/mui/material-ui` | Google 风 |
| Chakra UI | `/chakra-ui/chakra-ui` | 可组合 |
| shadcn/ui | `/shadcn-ui/ui` | 复制粘贴 |
| Element Plus | `/element-plus/element-plus` | Vue 3 |
| TDesign | `/tencent/tdesign` | 腾讯 |
| Arco Design | `/arco-design/arco-design` | 字节 |

### 2.3 状态管理

| 库 | Library ID | 特点 |
|----|-----------|------|
| Zustand | `/pmndrs/zustand` | 轻量 |
| Redux Toolkit | `/reduxjs/redux-toolkit` | 标准 |
| Jotai | `/pmndrs/jotai` | 原子化 |
| Pinia | `/vuejs/pinia` | Vue 官方 |
| Recoil | `/facebookexperimental/Recoil` | Meta |

### 2.4 工具链

| 库 | Library ID | 用途 |
|----|-----------|------|
| Vite | `/vitejs/vite` | 构建 |
| Webpack | `/webpack/webpack` | 构建 |
| Turbopack | `/vercel/turbopack` | 新构建 |
| Rollup | `/rollup/rollup` | 库打包 |
| esbuild | `/evanw/esbuild` | Go 编写 |
| SWC | `/swc-project/swc` | Rust 编写 |

### 2.5 后端框架

| 库 | Library ID | 特点 |
|----|-----------|------|
| Express | `/expressjs/express` | 经典 |
| NestJS | `/nestjs/nest` | 企业级 |
| Fastify | `/fastify/fastify` | 高性能 |
| Koa | `/koajs/koa` | 极简 |
| Hono | `/honojs/hono` | 边缘 |
| Elysia | `/elysiajs/elysia` | Bun |
| FastAPI | `/tiangolo/fastapi` | Python |
| Spring Boot | `/spring-projects/spring-boot` | Java |
| Gin | `/gin-gonic/gin` | Go |
| Rails | `/rails/rails` | Ruby |

### 2.6 ORM / 数据库

| 库 | Library ID | 适用 |
|----|-----------|------|
| Prisma | `/prisma/prisma` | Node + TS |
| Drizzle | `/drizzle-team/drizzle-orm` | 轻量 |
| TypeORM | `/typeorm/typeorm` | 装饰器 |
| Sequelize | `/sequelize/sequelize` | 经典 |
| SQLAlchemy | `/sqlalchemy/sqlalchemy` | Python |
| GORM | `/go-gorm/gorm` | Go |
| MyBatis | `/mybatis/mybatis-3` | Java |

### 2.7 数据库

| 库 | Library ID | 用途 |
|----|-----------|------|
| PostgreSQL | `/postgres/postgres` | 文档 |
| Redis | `/redis/redis` | 文档 |
| ClickHouse | `/clickhouse/clickhouse-docs` | OLAP |
| MongoDB | `/mongodb/docs` | 文档 |
| Supabase | `/supabase/supabase` | BaaS |

### 2.8 验证 / 鉴权

| 库 | Library ID | 用途 |
|----|-----------|------|
| Zod | `/colinhacks/zod` | TS 验证 |
| Yup | `/jquense/yup` | 验证 |
| Joi | `/hapijs/joi` | 验证 |
| React Hook Form | `/react-hook-form/react-hook-form` | 表单 |
| NextAuth.js | `/nextauthjs/next-auth` | 鉴权 |
| Auth.js | `/auth0/auth0-docs` | 鉴权 |
| Lucia | `/lucia-auth/lucia` | 鉴权 |

### 2.9 测试

| 库 | Library ID | 用途 |
|----|-----------|------|
| Vitest | `/vitest-dev/vitest` | 单元 |
| Jest | `/jestjs/jest` | 单元 |
| Playwright | `/microsoft/playwright` | E2E |
| Cypress | `/cypress-io/cypress` | E2E |
| Testing Library | `/testing-library/react-testing-library` | 组件 |
| Pytest | `/pytest-dev/pytest` | Python |

### 2.10 AI / LLM

| 库 | Library ID | 用途 |
|----|-----------|------|
| LangChain | `/langchain-ai/langchain` | LLM 框架 |
| LlamaIndex | `/run-llama/llama_index` | RAG |
| Vercel AI SDK | `/vercel/ai` | AI 应用 |
| OpenAI Node | `/openai/openai-node` | OpenAI API |
| Anthropic SDK | `/anthropics/anthropic-sdk-typescript` | Claude API |
| Transformers | `/huggingface/transformers` | HF 模型 |
| MCP SDK | `/modelcontextprotocol/typescript-sdk` | MCP 协议 |

### 2.11 部署 / 运维

| 库 | Library ID | 用途 |
|----|-----------|------|
| Docker | `/docker/docs` | 容器 |
| Kubernetes | `/kubernetes/kubernetes` | 编排 |
| Terraform | `/hashicorp/terraform` | IaC |
| Pulumi | `/pulumi/pulumi` | IaC |
| Vercel | `/vercel/vercel` | 部署 |
| Cloudflare Workers | `/cloudflare/workers-sdk` | 边缘 |
| Wrangler | `/cloudflare/wrangler` | 部署 |

### 2.12 监控 / 日志

| 库 | Library ID | 用途 |
|----|-----------|------|
| Sentry | `/getsentry/sentry` | 错误监控 |
| OpenTelemetry | `/open-telemetry/opentelemetry` | 链路追踪 |
| Prometheus | `/prometheus/prometheus` | 监控 |
| Grafana | `/grafana/grafana` | 可视化 |
| Loki | `/grafana/loki` | 日志 |
| PostHog | `/posthog/posthog` | 产品分析 |
| Plausible | `/plausible/analytics` | 隐私分析 |

---

## 3. 各 openPRD 子技能的典型调用

### 3.1 行业分析（openPRD-industry-analysis）

```javascript
// 场景：研究 [行业] 的典型 SaaS 架构
const docs = await mcp__context7__query-docs({
  libraryId: "/nestjs/nest",
  query: "NestJS 企业级 SaaS 多租户架构，最佳实践"
})
```

### 3.2 技术趋势（openPRD-tech-trends）

```javascript
// 场景：验证 React 19 状态
const libId = await mcp__context7__resolve_library_id({
  query: "React 19 stable",
  libraryName: "react"
})

const docs = await mcp__context7__query-docs({
  libraryId: libId,
  query: "React 19 Server Components stable status, breaking changes, migration guide"
})
```

### 3.3 文档产出（openPRD-document-generation）

```javascript
// 场景：确认 Prisma 当前最佳实践
const docs = await mcp__context7__query-docs({
  libraryId: "/prisma/prisma",
  query: "Prisma 5 schema best practices, relations, indexes, soft delete pattern"
})
```

### 3.4 前端设计（openPRD-frontend-design）

```javascript
// 场景：调研 Ant Design 5 表单最佳实践
const docs = await mcp__context7__query-docs({
  libraryId: "/ant-design/ant-design",
  query: "Form.useForm best practices, performance, complex validation, async submit"
})
```

---

## 4. 常见错误与修正

| 错误 | 修正 |
|------|------|
| 不调用 context7 直接用训练数据 | 涉及具体库时必须调用 |
| 调用但不指定版本 | query 中明确版本（如"Next.js 15"）|
| 一次问 10 个问题 | 拆分多个 query |
| 用模糊 query | 具体到场景（如"中后台"非"前端"）|
| 不知道 libraryId | 先 resolve-library-id |
| 选错库 | 优先 High reputation |

---

## 5. 降级策略

```javascript
try {
  const result = await mcp__context7__query-docs({ ... });
} catch (error) {
  if (error.message.includes("timeout")) {
    // 降级 1：简化 query 重试
    const result = await mcp__context7__query-docs({
      libraryId,
      query: query.split(" ")[0]  // 取第一个词
    });
  } else if (error.message.includes("not found")) {
    // 降级 2：用训练数据 + 标注"未验证"
    return { source: "training_data", version: "unknown" };
  } else {
    throw error;
  }
}
```

---

**文档完成。** 版本：v1.0
