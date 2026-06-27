# chrome-devtools 调用示例库

> **目的**：为 openPRD 各子技能提供 chrome-devtools 工具的标准化调用模式，按"场景"分类组织。

---

## 1. 通用调用流程

### 1.1 打开新标签 + 导航

```javascript
// 打开新标签
mcp__chrome-devtools__new_page({ url: "https://example.com" })

// 在已有标签中导航
mcp__chrome-devtools__navigate_page({
  type: "url",
  url: "https://example.com/pricing"
})
```

### 1.2 提取页面结构

```javascript
// a11y 快照（推荐，比 screenshot 更有结构）
mcp__chrome-devtools__take_snapshot({})

// 详细模式
mcp__chrome-devtools__take_snapshot({ verbose: true })
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

### 1.3 截图（视觉记录）

```javascript
mcp__chrome-devtools__take_screenshot({
  format: "png",  // png, jpeg, webp
  quality: 90,  // jpeg/webp 0-100
  fullPage: true,  // 是否全页
  filePath: "<项目目录>/assets/screenshots/home.png"
})
```

### 1.4 提取数据（执行 JS）

```javascript
mcp__chrome-devtools__evaluate_script({
  function: "() => {
    return {
      title: document.title,
      prices: Array.from(document.querySelectorAll('.price')).map(el => el.textContent),
      features: Array.from(document.querySelectorAll('.feature')).map(el => el.textContent)
    };
  }"
})
```

### 1.5 网络请求分析

```javascript
// 列出所有请求
mcp__chrome-devtools__list_network_requests({})

// 查看特定请求
mcp__chrome-devtools__get_network_request({ reqid: 123 })

// 过滤 XHR/fetch
mcp__chrome-devtools__list_network_requests({
  resourceTypes: ["xhr", "fetch"]
})
```

### 1.6 Lighthouse 性能审计

```javascript
mcp__chrome-devtools__lighthouse_audit({
  mode: "navigation",  // navigation, snapshot
  device: "desktop",  // desktop, mobile
  outputDirPath: "<项目目录>/assets/lighthouse/"
})
```

### 1.7 模拟设备/网络

```javascript
// 移动端模拟
mcp__chrome-devtools__emulate({
  viewport: "390x844,mobile,touch"  // iPhone 14 Pro
})

// 弱网模拟
mcp__chrome-devtools__emulate({
  networkConditions: "Slow 3G"  // Offline, Slow 3G, Fast 3G, Slow 4G, Fast 4G
})

// CPU 限速
mcp__chrome-devtools__emulate({
  cpuThrottlingRate: 4  // 1-20
})
```

### 1.8 调整窗口

```javascript
mcp__chrome-devtools__resize_page({ width: 1280, height: 720 })
mcp__chrome-devtools__resize_page({ width: 390, height: 844 })  // iPhone
```

### 1.9 监听控制台

```javascript
mcp__chrome-devtools__list_console_messages({})
mcp__chrome-devtools__list_console_messages({ types: ["error", "warn"] })
```

---

## 2. 各 openPRD 子技能的典型调用

### 2.1 竞品分析（openPRD-competitor-analysis）

#### 场景 1：竞品官网 5 分钟档案

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
      ctaButtons: Array.from(document.querySelectorAll('button, a.btn'))
        .map(el => el.textContent.trim())
        .filter(t => t)
        .slice(0, 5),
      features: Array.from(document.querySelectorAll('h2, h3'))
        .map(el => el.textContent.trim())
        .filter(t => t)
        .slice(0, 10),
      techStack: {
        framework: window.__NEXT_DATA__ ? 'Next.js' : 
                   (window.__NUXT__ ? 'Nuxt' : 'Unknown'),
        analytics: Array.from(document.querySelectorAll('script'))
          .some(s => s.src.includes('ga.js')) ? 'GA' : null
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

// 调用
const salesforce = await competitorProfile("https://salesforce.com", "salesforce");
```

#### 场景 2：竞品定价页

```javascript
async function competitorPricing(url) {
  await mcp__chrome-devtools__navigate_page({ type: "url", url });
  await mcp__chrome-devtools__wait_for({ 
    text: ["Pricing", "价格"], 
    timeout: 5000 
  });
  
  const pricing = await mcp__chrome-devtools__evaluate_script({
    function: `() => {
      const plans = Array.from(document.querySelectorAll('.plan, .pricing-card, [data-plan]'));
      return plans.map(plan => ({
        name: plan.querySelector('h2, h3, .plan-name')?.textContent?.trim(),
        price: plan.querySelector('.price, [data-price]')?.textContent?.trim(),
        features: Array.from(plan.querySelectorAll('li, .feature'))
          .map(li => li.textContent.trim())
          .filter(t => t)
      }));
    }`
  });
  
  return pricing;
}
```

#### 场景 3：竞品移动端体验

```javascript
async function competitorMobile(url, name) {
  await mcp__chrome-devtools__new_page({ url });
  await mcp__chrome-devtools__emulate({
    viewport: "390x844,mobile,touch"
  });
  
  await mcp__chrome-devtools__take_screenshot({
    fullPage: true,
    filePath: `./assets/competitors/${name}-mobile.png`
  });
  
  const mobile = await mcp__chrome-devtools__lighthouse_audit({
    mode: "navigation",
    device: "mobile",
    outputDirPath: `./assets/competitors/${name}-lighthouse-mobile/`
  });
  
  return mobile;
}
```

### 2.2 行业分析（openPRD-industry-analysis）

#### 场景 1：抓取行业协会数据

```javascript
async function fetchIndustryReport(url) {
  await mcp__chrome-devtools__new_page({ url });
  await mcp__chrome-devtools__take_snapshot({});
  
  const report = await mcp__chrome-devtools__evaluate_script({
    function: `() => {
      // 提取文章正文
      const article = document.querySelector('article, .article, main');
      return {
        title: document.title,
        date: document.querySelector('time, .date')?.textContent,
        author: document.querySelector('.author')?.textContent,
        content: article?.textContent?.trim().slice(0, 5000)
      };
    }`
  });
  
  return report;
}
```

#### 场景 2：监管机构网站

```javascript
// 验证法规版本
await mcp__chrome-devtools__new_page({ 
  url: "https://flk.npc.gov.cn/detail2.html?MmM5MDlmZGQ2NzhiZjE3OTAxNjc4YmY4NWQ3MzAwMDc" 
});
const law = await mcp__chrome-devtools__evaluate_script({
  function: `() => ({
    title: document.querySelector('h1, .law-title')?.textContent,
    effectiveDate: document.querySelector('.effective-date, .publish-date')?.textContent,
    version: document.querySelector('.version, .amend-count')?.textContent
  })`
});
```

### 2.3 技术趋势（openPRD-tech-trends）

```javascript
// GitHub Trending
await mcp__chrome-devtools__new_page({ 
  url: "https://github.com/trending" 
});
const repos = await mcp__chrome-devtools__evaluate_script({
  function: `() => Array.from(document.querySelectorAll('article.Box-row'))
    .slice(0, 10)
    .map(article => ({
      name: article.querySelector('h2 a')?.textContent?.trim(),
      description: article.querySelector('p')?.textContent?.trim(),
      stars: article.querySelector('.text-sm')?.textContent?.trim()
    }))`
});
```

### 2.4 文档产出（openPRD-document-generation）

```javascript
// 验证文档中所有 URL
async function validateUrls(urls) {
  const results = [];
  for (const url of urls) {
    try {
      await mcp__chrome-devtools__navigate_page({ type: "url", url });
      const status = await mcp__chrome-devtools__evaluate_script({
        function: `() => ({
          title: document.title,
          status: document.readyState
        })`
      });
      results.push({ url, valid: true, ...status });
    } catch (e) {
      results.push({ url, valid: false, error: e.message });
    }
  }
  return results;
}
```

### 2.5 用户研究（openPRD-user-research）

```javascript
// 展示竞品给用户
await mcp__chrome-devtools__new_page({ url: "https://competitor.com" });
await mcp__chrome-devtools__take_screenshot({ fullPage: true });
// 然后让用户对比
```

### 2.6 前端设计（openPRD-frontend-design）

```javascript
// 验证设计稿还原
await mcp__chrome-devtools__new_page({ url: "https://staging.example.com" });
const perf = await mcp__chrome-devtools__lighthouse_audit({
  mode: "navigation",
  device: "desktop"
});
// 对比设计稿与实现
```

---

## 3. 实战模板汇总

### 3.1 完整竞品调研流程（15 分钟）

```javascript
async function fullCompetitorResearch(competitors) {
  const results = {};
  
  for (const c of competitors) {
    // 1. 桌面端
    await mcp__chrome-devtools__new_page({ url: c.url });
    await mcp__chrome-devtools__resize_page({ width: 1920, height: 1080 });
    const desktopSnapshot = await mcp__chrome-devtools__take_snapshot({});
    await mcp__chrome-devtools__take_screenshot({ 
      fullPage: true, 
      filePath: `./assets/${c.name}-desktop.png` 
    });
    
    // 2. 移动端
    await mcp__chrome-devtools__emulate({ 
      viewport: "390x844,mobile,touch" 
    });
    await mcp__chrome-devtools__take_screenshot({ 
      fullPage: true, 
      filePath: `./assets/${c.name}-mobile.png` 
    });
    
    // 3. 性能
    const perf = await mcp__chrome-devtools__lighthouse_audit({
      mode: "navigation",
      device: "mobile",
      outputDirPath: `./assets/${c.name}-lighthouse/`
    });
    
    // 4. 提取信息
    const info = await mcp__chrome-devtools__evaluate_script({
      function: "() => ({ title: document.title, h1: document.querySelector('h1')?.textContent })"
    });
    
    results[c.name] = { desktopSnapshot, perf, info };
    
    // 5. 关闭
    await mcp__chrome-devtools__close_page({ pageId: c.pageId });
  }
  
  return results;
}
```

### 3.2 URL 批量验证

```javascript
async function batchValidateUrls(urls) {
  const report = {
    total: urls.length,
    valid: 0,
    invalid: 0,
    details: []
  };
  
  for (const url of urls) {
    try {
      await mcp__chrome-devtools__navigate_page({ 
        type: "url", 
        url, 
        timeout: 10000 
      });
      const ok = await mcp__chrome-devtools__evaluate_script({
        function: "() => document.title.length > 0"
      });
      report.valid++;
      report.details.push({ url, status: "valid" });
    } catch (e) {
      report.invalid++;
      report.details.push({ url, status: "invalid", error: e.message });
    }
  }
  
  return report;
}
```

---

## 4. 错误处理

### 4.1 常见错误

| 错误 | 原因 | 修正 |
|------|------|------|
| 404 | URL 不存在 | 标注"URL 已失效"，建议替换 |
| timeout | 页面加载慢 | 增大 timeout 或 wait_for |
| 截图失败 | 页面太长 | 改用 fullPage: false |
| evaluate_script 超时 | JS 太复杂 | 简化逻辑，分多次调用 |
| Lighthouse 失败 | 页面有问题 | 手动评估关键指标 |

### 4.2 降级策略

```javascript
try {
  const result = await mcp__chrome-devtools__take_screenshot({ ... });
} catch (error) {
  if (error.message.includes("timeout")) {
    // 降级 1：不用 fullPage
    return await mcp__chrome-devtools__take_screenshot({ fullPage: false });
  } else if (error.message.includes("navigation")) {
    // 降级 2：用 WebFetch 替代
    return await WebFetch({ url, prompt: "提取页面关键信息" });
  } else {
    throw error;
  }
}
```

---

## 5. 资源管理

### 5.1 标签管理

- **每次任务最多打开 5 个标签**（避免资源耗尽）
- **任务结束关闭标签**（避免资源泄漏）
- **使用 list_pages 查看所有标签**

```javascript
// 列出所有标签
const pages = await mcp__chrome-devtools__list_pages({});

// 切换标签
await mcp__chrome-devtools__select_page({ pageId: 0, bringToFront: true });

// 关闭标签
await mcp__chrome-devtools__close_page({ pageId: 1 });
```

### 5.2 资产保存

```
<项目目录>/
├── assets/
│   ├── competitors/         # 竞品截图
│   │   ├── salesforce-desktop.png
│   │   ├── salesforce-mobile.png
│   │   └── salesforce-lighthouse/
│   ├── industry-reports/    # 行业数据
│   ├── law-versions/        # 法规版本验证
│   └── lighthouse/          # 性能审计
```

---

## 6. 最佳实践

1. **先快照后截图**（a11y 快照更结构化）
2. **保存资产到 `assets/` 目录**（避免污染项目）
3. **性能审计用 desktop + mobile 双模式**
4. **提取数据前等待页面加载完成**（用 wait_for）
5. **每次任务结束关闭标签**
6. **需要用户授权才能访问第三方网站**

---

## 7. 避免事项

- ❌ 不要在没用户授权时抓取
- ❌ 不要在循环中打开大量标签
- ❌ 不要抓取登录后的页面（凭据问题）
- ❌ 不要把抓取的数据当作"权威数据"（需二次确认）
- ❌ 不要抓取付费墙内容（法律风险）

---

**文档完成。** 版本：v1.0
