# 深度研究方法论参考

## parags/deep-research-pro 6 步法详解

### Step 1: Understand the Goal
1-2 个澄清问题：
- "What's your goal — learning, making a decision, or writing something?"
- "Any specific angle or depth you want?"

如果用户说"just research it" → 跳过澄清，使用默认值。

### Step 2: Plan the Research
拆 3-5 个子问题。模板：
- What are the main [X] in [Y] today?
- What [outcomes] have been measured?
- What are the [regulatory/technical] challenges?
- What companies are leading this space?
- What's the market size and growth trajectory?

### Step 3: Execute Multi-Source Search
```bash
# 实际不可用，仅示意
ddg "<sub-question keywords>" --max 8
ddg news "<topic>" --max 5
```

策略：
- 每个子问题 2-3 个关键词变体
- web + news 混合
- 目标 15-30 个独立来源
- 优先级：学术 > 官方 > 主流媒体 > 博客 > 论坛

### Step 4: Deep-Read Key Sources
抓 3-5 个关键来源全文（不只是 snippet），用 curl + python 解析。

### Step 5: Synthesize & Write Report
输出结构（必须按此）：
1. Executive Summary（3-5 句话）
2. N 个 Major Theme（带内联引用）
3. Key Takeaways（3-5 个 actionable insight）
4. Sources（完整列表）
5. Methodology（搜索了多少 query，分析了多少源）

### Step 6: Save & Deliver
- 短主题：完整报告贴到对话
- 长报告：Executive Summary + Key Takeaways 贴到对话，完整报告存文件

---

## openPRD 14 模板映射表

| 14-行业分析报告.md 章节 | parags/deep-research-pro 输出 | 转换规则 |
|------------------------|------------------------------|----------|
| 1 行业概况 | Executive Summary | 直接复用 + 补充数据 |
| 2 行业特点 | Key Takeaways | 拆解为 2.1-2.4 子章节 |
| 3 典型业务流程 | Case Studies with citations | 选 1-2 个最相关案例 |
| 4 行业术语表 | Glossary | 从 4 大维度补全 |
| 5 技术要点 | Tech Trends with sources | 加 ⭐ 高亮核心 |
| 6 行业标杆产品 | Benchmark Products (cited) | 每个产品 3+ 引用 |
| 7 对本项目的启示 | Insights | 提炼 5-7 条 |
| 8 参考资源 | Sources | 完整复制 + URL |
| 9 后续行动 | Methodology Notes | 标注置信度 |

---

## 质量自检 5 项

1. 每个数据点有来源标注
2. 至少 15 个独立来源
3. 60%+ 来源在 12 个月内
4. 至少 1 个 PEST 政治/政策类来源
5. 至少 1 个市场规模量化数据（带数据源）

---

## 报告专业性提升技巧

| 技巧 | 示例 |
|------|------|
| 用具体数字代替"很多" | "市场规模 500 亿美元（IDC 2025）" 而非 "市场规模巨大" |
| 用对比增强说服力 | "同比增长 23%，远超行业平均 8%" |
| 用时间锚定新鲜度 | "截至 2025 Q4，..." 而非 "近期" |
| 标注数据置信度 | 高（3+ 来源一致）/ 中（1-2 来源）/ 低（仅 1 来源） |
| 区分事实与预测 | "已发生: X / 预测: Y（来源: Z）" |
