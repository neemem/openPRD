---
name: openPRD-chrome-devtools-integration
description: Use when any openPRD subagent needs to interact with web pages in real-time, extract data from live websites, verify URLs, or capture screenshots of competitor products. Triggers on "抓取网页", "实时数据", "竞品官网", "验证 URL", "看网站", "实际页面", "chrome-devtools", "playwright". Wraps the chrome-devtools MCP server (navigate, snapshot, take_screenshot, list_network_requests, evaluate_script, etc.) into reusable call patterns for openPRD subagents. **所有需要实时网页数据、竞品官网分析、URL 验证的场景调用本 skill。**
---

# openPRD - chrome-devtools 能力集成

## 概述

**目的**：把 **chrome-devtools MCP**（浏览器自动化）封装为 openPRD 内部可调用的 subagent，**让所有子技能在需要实时网页数据时调用浏览器能力**。

**重要性**：
- 竞品分析不能只看文档（过时），要看真实网站
- 行业研究需要抓取最新数据（财报、新闻、监管公告）
- 文档中的 URL 必须实际可访问
- 用户研究时能展示真实页面给用户确认

**协作位置**：被 competitor-analysis、industry-analysis、regulation-compliance、tech-trends、document-generation 等 subagent 调用。

---

## 工具映射

| 工具 | 用途 | 典型场景 |
|------|------|----------|
| `mcp__chrome-devtools__new_page` | 打开新标签页 | 打开竞品官网 |
| `mcp__chrome-devtools__navigate_page` | 导航 URL | 跳转页面 |
| `mcp__chrome-devtools__take_snapshot` | 页面 a11y 快照 | 提取页面结构 |
| `mcp__chrome-devtools__take_screenshot` | 页面截图 | 视觉记录 |
| `mcp__chrome-devtools__list_pages` | 列出所有标签 | 多页对比 |
| `mcp__chrome-devtools__select_page` | 切换标签 | 多任务 |
| `mcp__chrome-devtools__close_page` | 关闭标签 | 清理 |
| `mcp__chrome-devtools__list_console_messages` | 控制台日志 | 调试 |
| `mcp__chrome-devtools__list_network_requests` | 网络请求 | API 分析 |
| `mcp__chrome-devtools__evaluate_script` | 执行 JS | 数据提取 |
| `mcp__chrome-devtools__emulate` | 模拟设备/网络 | 移动端/弱网测试 |
| `mcp__chrome-devtools__resize_page` | 调整窗口 | 响应式测试 |
| `mcp__chrome-devtools__lighthouse_audit` | 性能审计 | 性能基准 |
| `mcp__playwright__browser_navigate` | Playwright 导航（备选）| 复杂交互 |

---

## 标准调用模式

### 1. 打开新标签 + 导航

```javascript
// 打开新标签
mcp__chrome-devtools__new_page({ url: "https://competitor.com" })

// 在已有标签中导航
mcp__chrome-devtools__navigate_page({
  type: "url",
  url: "https://competitor.com/pricing"
})

// 模拟移动端
mcp__chrome-devtools__emulate({
  viewport: "390x844,mobile,touch"
})
```

### 2. 提取页面结构（a11y 快照）

```javascript
mcp__chrome-devtools__take_snapshot({
  // 默认返回 a11y 树，比 screenshot 更有结构
  // verbose: true 时返回更多信息
})
```

**返回内容示例**：
```
- banner
  - link "Logo" [ref=1]
  - navigation
    - link "产品" [ref=2]
    - link "价格" [ref=3]
- main
  - heading "革命性 CRM 平台" [level=1] [ref=4]
  - paragraph "..." [ref=5]
  - button "免费试用" [ref=6]
```

### 3. 截图（视觉记录）

```javascript
mcp__chrome-devtools__take_screenshot({
  format: "png",  // png, jpeg, webp
  fullPage: true,  // 是否全页
  filePath: "<项目目录>/assets/competitor-screenshots/home.png"
})
```

### 4. 提取数据（执行 JS）

```javascript
mcp__chrome-devtools__evaluate_script({
  function: "() => {
    // 提取页面标题、所有价格、关键数据
    return {
      title: document.title,
      prices: Array.from(document.querySelectorAll('.price')).map(el => el.textContent),
      features: Array.from(document.querySelectorAll('.feature')).map(el => el.textContent)
    };
  }"
})
```

### 5. 网络请求分析

```javascript
// 列出所有请求
mcp__chrome-devtools__list_network_requests({})

// 查看特定请求的响应
mcp__chrome-devtools__get_network_request({
  reqid: 123  // 来自 list_network_requests 的 ID
})
```

### 6. Lighthouse 性能审计

```javascript
mcp__chrome-devtools__lighthouse_audit({
  mode: "navigation",  // navigation, snapshot
  device: "desktop",  // desktop, mobile
  outputDirPath: "<项目目录>/assets/lighthouse/"
})
```

---

## openPRD 各 subagent 的调用场景

### 场景 1：竞品分析（`openPRD-competitor-analysis`）

```yaml
流程:
  1. 打开竞品官网
  2. 抓取首页 a11y 快照
  3. 截图首页
  4. 提取关键信息（标题、CTA、特性、价格）
  5. 跳转到定价页
  6. 抓取定价表
  7. 跳转到产品功能页
  8. 评估性能（Lighthouse）
  9. 模拟移动端
  10. 整理为竞品档案
```

**代码示例**：
```javascript
// 1. 打开竞品
mcp__chrome-devtools__new_page({ url: "https://salesforce.com" })

// 2. 抓 a11y 快照
mcp__chrome-devtools__take_snapshot({})

// 3. 截图
mcp__chrome-devtools__take_screenshot({
  fullPage: true,
  filePath: "./assets/salesforce-home.png"
})

// 4. 提取价格
mcp__chrome-devtools__evaluate_script({
  function: "() => Array.from(document.querySelectorAll('[data-price]')).map(el => el.dataset.price)"
})

// 5. 性能审计
mcp__chrome-devtools__lighthouse_audit({
  mode: "navigation",
  device: "desktop",
  outputDirPath: "./assets/salesforce-lighthouse/"
})
```

### 场景 2：行业研究（`openPRD-industry-analysis`）

```yaml
流程:
  1. 打开行业协会网站
  2. 抓取最新报告/数据
  3. 打开监管机构网站（如网信办）
  4. 抓取最新政策
  5. 抓取行业新闻 3-5 篇
  6. 整理为行业洞察
```

### 场景 3：法规合规（`openPRD-regulation-compliance`）

```yaml
流程:
  1. 打开国家法律法规数据库
  2. 搜索具体法规（如《个人信息保护法》）
  3. 提取关键条款
  4. 验证法规版本时效性
  5. 整理为合规 Checklist
```

### 场景 4：技术趋势（`openPRD-tech-trends`）

```yaml
流程:
  1. 打开 GitHub Trending
  2. 抓取本周热门仓库
  3. 打开 npm/Stack Overflow Trends
  4. 抓取技术使用率
  5. 整理为技术趋势报告
```

### 场景 5：文档产出验证（`openPRD-document-generation`）

```yaml
流程:
  1. 文档中所有 URL 提取
  2. 逐个验证可访问性
  3. 验证 404/重定向
  4. 替换失效链接
  5. 标注未验证链接
```

### 场景 6：用户研究（`openPRD-user-research`）

```yaml
流程:
  1. 用户提到某竞品
  2. 打开竞品官网展示
  3. 让用户确认/对比
  4. 抓取 a11y 快照作为参考
```

---

## 实战模板：竞品官网 5 分钟档案

```javascript
async function competitorProfile(url, name) {
  // 1. 打开
  await mcp__chrome-devtools__new_page({ url });
  
  // 2. a11y 快照
  const snapshot = await mcp__chrome-devtools__take_snapshot({});
  
  // 3. 截图
  await mcp__chrome-devtools__take_screenshot({
    fullPage: true,
    filePath: `./assets/competitors/${name}-home.png`
  });
  
  // 4. 提取关键信息
  const info = await mcp__chrome-devtools__evaluate_script({
    function: `() => ({
      title: document.title,
      description: document.querySelector('meta[name="description"]')?.content,
      ctaButtons: Array.from(document.querySelectorAll('button, a.btn')).map(el => el.textContent.trim()).filter(t => t).slice(0, 5),
      features: Array.from(document.querySelectorAll('h2, h3')).map(el => el.textContent.trim()).filter(t => t).slice(0, 10),
      techStack: {
        framework: window.__NEXT_DATA__ ? 'Next.js' : (window.__NUXT__ ? 'Nuxt' : 'Unknown'),
        analytics: Array.from(document.querySelectorAll('script')).some(s => s.src.includes('ga.js')) ? 'GA' : null
      }
    })`
  });
  
  // 5. 性能审计
  const perf = await mcp__chrome-devtools__lighthouse_audit({
    mode: "navigation",
    device: "desktop",
    outputDirPath: `./assets/competitors/${name}-lighthouse/`
  });
  
  return { snapshot, info, perf };
}
```

---

## 使用约束

### ⚠️ 限制

- **每次任务最多打开 5 个标签**（避免资源耗尽）
- **需要用户授权**才能访问第三方网站（隐私/法律）
- **动态渲染内容可能抓不到**（需配合 evaluate_script 等待）
- **付费墙后内容抓不到**（需用户登录）

### ✅ 最佳实践

- **先快照后截图**（a11y 快照更结构化）
- **保存资产到 `assets/` 目录**（避免污染项目）
- **性能审计用 desktop + mobile 双模式**
- **提取数据前等待页面加载完成**（用 wait_for）
- **每次任务结束关闭标签**（避免资源泄漏）

### ❌ 避免

- 不要在没用户授权时抓取
- 不要在循环中打开大量标签
- 不要抓取登录后的页面（凭据问题）
- 不要把抓取的数据当作"权威数据"（需二次确认）

---

## 错误处理

```javascript
try {
  const result = await mcp__chrome-devtools__new_page({ url });
} catch (error) {
  if (error.message.includes("404")) {
    console.warn(`URL 不存在：${url}`);
  } else if (error.message.includes("timeout")) {
    console.warn("页面加载超时，可能需要等待");
  } else {
    throw error;
  }
}
```

**降级策略**：
| 失败 | 降级方案 |
|------|----------|
| 页面无法访问 | 用 WebFetch 替代 |
| 截图失败 | 仅用 a11y 快照 |
| evaluate_script 超时 | 简化 JS 逻辑 |
| Lighthouse 失败 | 手动评估关键指标 |

---

## 与主 openPRD 的集成

```yaml
# 在主 SKILL.md 中描述
子技能:
  - openPRD-chrome-devtools-integration: 浏览器自动化（chrome-devtools MCP 封装）
```

```yaml
# 在各 subagent 的 SKILL.md "外部能力集成" 章节
外部能力集成:
  - chrome-devtools:
      navigate: 打开竞品/行业网站
      take_snapshot: 提取页面结构
      take_screenshot: 视觉记录
      evaluate_script: 数据提取
      lighthouse_audit: 性能基准
      emulate: 移动端/弱网模拟
```

---

## Gotchas (避坑指南)

### G-01: take_snapshot 在 SPA 异步加载时只拿到初始 state
- **症状**: 打开竞品 SPA 首页,立即 take_snapshot,只拿到骨架(loading / spinner),实际页面 3 秒后才出来
- **原因**: SPA 用 React/Vue 异步 mount,首屏 HTML 几乎是空壳
- **修正**: **必先 wait_for 关键文本**再 snapshot。3 步模板:(1) navigate_page (2) wait_for `text: ["登录", "免费试用"]`(关键 CTA 文本) (3) take_snapshot。绝不在 navigate 后立即 snapshot。参考 openPRD-chrome-devtools-integration §✅ 最佳实践"提取数据前等待页面加载完成"。
- **参考**: openPRD-chrome-devtools-integration §✅ 最佳实践

### G-02: lighthouse_audit 默认 desktop,移动端得分天差地别
- **症状**: 跑 lighthouse 看 B2C 营销页性能,得分 95,但实际移动端用户(70%+)只有 35
- **原因**: 默认 device=desktop,模拟的是 1350x940 桌面,与 390x844 移动端差异巨大
- **修正**: **B2C / C 端项目必双跑**——lighthouse_audit({device: "desktop"}) + lighthouse_audit({device: "mobile"})。如果不做移动端模拟,Lighthouse 报告无价值(B 端则 desktop 即可)。参考 openPRD-chrome-devtools-integration §6 Lighthouse 性能审计。
- **参考**: openPRD-chrome-devtools-integration §6 Lighthouse 性能审计

### G-03: evaluate_script 不能直接 await 复杂 Promise,执行静默失败
- **症状**: evaluate_script 写 `async () => { const data = await fetch('/api/x'); return data; }`,返回值是 undefined,没报错
- **原因**: MCP 工具期望同步返回 JSON,async/Promise 不能直接 top-level await
- **修正**: **IIFE 包装 await**——`() => { return (async () => { const data = await fetch('/api/x'); return { data }; })(); }`。或用 `.then(r => r.json())` 链。复杂异步必先在 Chrome DevTools console 测试再嵌入 MCP 调用。参考 openPRD-chrome-devtools-integration §4 提取数据。
- **参考**: openPRD-chrome-devtools-integration §4 提取数据

### G-04: 抓取登录后内容(用户授权问题)误以为"不抓就够"
- **症状**: 抓到登录页后,snapshot 显示"请输入账号密码",agent 没标"需登录"就当竞品"功能简单"
- **原因**: 漏标"证据不完整"的状态
- **修正**: **3 类状态显式标注**:(1) **完整证据**(已登录 + 走完核心流程) (2) **部分证据**(仅 Landing Page) (3) **无法验证**(需登录 / 付费墙)。证据等级必标在竞品档案开头,见 openPRD-competitor-analysis §G-01 Battle Card 调研深度。
- **参考**: openPRD-competitor-analysis §Gotchas G-01

### G-05: 每次任务结束不关闭标签,内存累积直至 MCP 崩溃
- **症状**: 跑了 10 个竞品档案,每个开 1 个标签,最后 navigate 报"too many open pages"
- **原因**: 缺资源释放机制
- **修正**: 必在每次 profile 抓取完调用 **close_page**(最后 1 个不能关)。3 步收尾:(1) 抓数据(2) 保存 assets/(3) close_page。如果并行多个,用 list_pages 监控标签数(≤ 5)。参考 openPRD-chrome-devtools-integration §✅ 最佳实践"任务结束关闭标签"。
- **参考**: openPRD-chrome-devtools-integration §✅ 最佳实践

**跨子技能常见错误汇总**: 见 [reference/16-common-pitfalls.md](./../reference/16-common-pitfalls.md)