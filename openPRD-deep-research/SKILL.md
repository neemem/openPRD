---
name: openPRD-deep-research
description: Use for deep industry/market research with cited sources. Wraps parags/deep-research-pro to deliver professional reports. Triggers on "深度研究", "深度调研", "行业研究", "市场研究", "deep research", "cited report", "数据引用", "行业报告". Integrates 6-step research methodology into openPRD's 14-行业分析报告 generation.
---

# 深度研究（Deep Research）

## 概述

**目的**：通过已安装的 `parags/deep-research-pro`（6 步法：Goal→Plan→Search→Deep-Read→Synthesize→Save），为 14-行业分析报告 提供**带引用、数据来源可追溯**的深度研究支撑。

**前置条件**：
- 已完成 openPRD-user-research 或 openPRD-industry-analysis 基础调用
- 已确定研究主题（行业 / 市场 / 技术趋势）

**调用入口**：
```
# 作为子技能被 openPRD-industry-analysis 调用
Skill("openPRD-deep-research")
```

---

## 何时调用

| 场景 | 是否调用 | 原因 |
|------|----------|------|
| 14-行业分析报告 模板的 8 行业分析报告 | ✅ 必调 | 提升报告专业性 |
| 14-行业分析报告 模板的 6 行业标杆产品 | ✅ 必调 | 标杆数据需要引用 |
| 用户明确要求"带引用的报告" | ✅ 必调 | - |
| 用户只问"快速了解" 5 分钟内 | ❌ 不调 | 杀鸡用牛刀 |

---

## 工作流（5 步）

### Step 1：接收需求
- 主题：[如：跨境电商 VIP 客服行业]
- 行业边界：[如：限境内 / 限欧美 / 不限]
- 目标读者：[如：产品/研发/业务方]
- 深度：[浅：3-5 个来源 / 中：10-15 / 深：20-30]
- 输出位置：`{需求名称}-docs/14-行业分析报告.md`

### Step 2：调用 parags/deep-research-pro
读取 `~/.agents/skills/deep-research-pro/SKILL.md`，按其 6 步法执行：
1. **Understand the Goal** - 1-2 个澄清问题
2. **Plan the Research** - 拆 3-5 个子问题
3. **Execute Multi-Source Search** - DDG 搜索，15-30 来源
4. **Deep-Read Key Sources** - 抓 3-5 个关键来源全文
5. **Synthesize & Write Report** - 编写带引用报告
6. **Save & Deliver** - 存到指定路径

### Step 3：映射到 openPRD 14 模板
将 deep-research-pro 的输出**结构化映射**到 14-行业分析报告.md 的 9 大章节：
- 1 行业概况 ← Executive Summary
- 2 行业特点 ← Key Takeaways
- 3 典型业务流程 ← Case Studies with citations
- 4 行业术语表 ← Glossary
- 5 技术要点 ← Tech Trends with sources
- 6 行业标杆产品 ← Benchmark Products (cited)
- 7 对本项目的启示 ← Insights
- 8 参考资源 ← Sources (full list)
- 9 后续行动 ← Methodology Notes

### Step 4：质量门禁
- [ ] 每个数据/事实有 `[来源名](URL)` 内联引用
- [ ] 15+ 来源（深度模式）
- [ ] 来源覆盖：行业报告 + 官方数据 + 主流媒体
- [ ] 12 个月内来源 ≥ 60%
- [ ] 至少 1 个 GTM/政策类来源

### Step 5：交付
- 主报告：`{需求名称}-docs/14-行业分析报告.md`
- 来源清单：附录或独立 `14-sources.md`

---

## Gotchas (避坑指南)

### G-01: 6 步法对"众所周知的题目"也不能跳过(Agent Harness、RAG、LLM 评测)
- **症状**: "RAG 是什么"——agent 直接写一大段,跳到 Step 5(写报告),省了 1-2-3-4 步
- **原因**: 误以为"题目太熟",plan + search 没必要——但"熟"是 agent 训练时的,2026 年的最新进展可能相反
- **修正**: 6 步必走,即使是"RAG vs Long-Context""Agent Harness"等高频题。每步抓不同失败模式(plan 错会漏子问题 / search 错会漏最新数据)。在 methodology §9 标注"6 步全走 + 子步骤时长"。
- **参考**: openPRD-deep-research §Step 2(6 步法) + examples/01 §8 行业标杆产品

### G-02: 12 个月内来源 < 60% → 数据失效,必严格卡
- **症状**: 引 20 个来源,15 个是 2022-2023 旧数据,2024-2026 新数据只有 5 个
- **原因**: 旧文章 SEO 排名高,搜索结果靠前;新文章分散,容易被忽略
- **修正**: 8 来源强制刷新时间窗:必查 `published/modified date` + `archive.org` 历史快照。占比 < 60% 必返工补充;旧来源标"📜 历史参考,数据可能已变"。见 examples/01 §6 行业标杆产品(引用必带时间戳)。
- **参考**: examples/01 §14-行业分析报告 §8 参考资源

### G-03: "Agent Harness 是什么" 类 概念题 vs "Agent Harness 选哪家" 类 决策题,plan 阶段不区分就崩
- **症状**: plan 子问题全写成"What is..."概念题(5 个),但用户实际想了解"我们该选 LangChain / Dify / AutoGen 哪一家"
- **原因**: 没读懂用户真实问题,概念题是 agent 训练偏好
- **修正**: Step 1 必做"问题类型分类":(A)概念解释(What/Why) (B)方案对比(Which) (C)市场调研(Who/How big) (D)政策合规(法律风险)。plan 子问题按类型分配,例 B 必含 3+ 个候选方案横向对比。
- **参考**: openPRD-deep-research §Step 1 接收需求

### G-04: 引用 URL 失效/404,文档交付后用户点开全是死链
- **症状**: 报告引 30 个 URL,6 个月后 8 个变 404(链接腐烂)
- **原因**: 引用时未做可用性验证
- **修正**: Step 5 交付前必走 openPRD-chrome-devtools-integration 跑一次"链接验证清单"(批量 navigate + 检测 status code)。404/重定向当场替换或标"⚠️ 链接已失效,来源备份 archive.org"。
- **参考**: openPRD-chrome-devtools-integration §场景 5 文档产出验证

**跨子技能常见错误汇总**: 见 [reference/16-common-pitfalls.md](./../reference/16-common-pitfalls.md)

---

## 与其他 openPRD 子技能的关系

```
openPRD-user-research (基础调研)
         ↓ 用户明确要"行业分析"
openPRD-industry-analysis
         ↓ 调用
openPRD-deep-research (本技能)  ──→  parags/deep-research-pro
         ↓ 输出
14-行业分析报告.md (带引用)
```

---

## 完成后

1. 报告文件输出到 `{需求名称}-docs/14-行业分析报告.md`
2. 来源清单在 14-行业分析报告.md 第 8 章「参考资源」
3. 在 openPRD-industry-analysis 调用链中标记"已使用 deep-research-pro"
4. 最终汇总报告（Step 4）展示 14-行业分析报告.md 的来源数与置信度
