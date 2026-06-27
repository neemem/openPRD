---
name: openPRD-user-research-enhancement
description: Use for deep user research, user interviews, JTBD analysis, affinity mapping, usability testing, surveys. Wraps anthropics/user-research (6 official methods) and extends with 4 openPRD proprietary templates. Triggers on "用户访谈", "深度调研", "用户深访", "亲和图", "JTBD", "可用性测试", "问卷调查", "卡片分类", "日记研究", "A/B 测试". Understand user needs, motivations, and pain points for requirement analysis.
---

# 用户深度研究

## 上游依赖

本技能在以下 skill 之上扩展：

| 上游 skill | 路径 | 关系 |
|-----------|------|------|
| `anthropics/user-research` | `~/.agents/skills/user-research/SKILL.md` | **方法论权威源**：提供 6 种官方调研方法定义与适用场景。本技能的所有方法定义必须与之一致。 |
| `openPRD-user-research` | `~/.claude/skills/openPRD/openPRD-user-research/SKILL.md` | **基础调研入口**：本技能在其基础调研结果之上做深度增强。 |

**调用顺序**：
```
Skill("openPRD-user-research")        # 基础 5 个非技术问题
       ↓ 发现需求不明确 / 需要深度
Skill("openPRD-user-research-enhancement")  # 本技能：6 种方法 + 4 份模板
       ↓ 必要时
参考 anthropics/user-research 原版 6 方法定义
```

---

## 概述

**目的**：在 openPRD 用户调研的基础上，提供深度用户研究方法论支持，帮助更准确地理解用户需求、动机和痛点。

**前置条件**：已完成 openPRD-user-research 的基础调研（平台类型、功能优先级、技术约束）。

**使用场景**：
- 用户需求模糊，需要深度探索
- 涉及复杂用户行为或决策流程
- 需要验证设计方向
- 竞品功能用户反馈不明确

---

## 研究方法参考表

> 📖 **方法定义权威源**：`anthropics/user-research`（~/.agents/skills/user-research/SKILL.md）。下表与之一致，本技能不修改方法定义，只补充执行细节。

| 方法 | 最佳场景 | 样本量 | 周期 | 适用条件 | 上游定义 |
|------|----------|--------|------|----------|----------|
| 用户访谈 | 深度理解需求和动机 | 5-8 人 | 2-4 周 | 需求不明确、用户说法模糊 | ✅ 与 anthropics 一致 |
| 可用性测试 | 评估特定设计或流程 | 5-8 人 | 1-2 周 | 有原型或设计稿可测试 | ✅ 与 anthropics 一致 |
| 问卷调查 | 量化态度和偏好 | 100+ | 1-2 周 | 需要大量样本统计验证 | ✅ 与 anthropics 一致 |
| 卡片分类 | 信息架构决策 | 15-30 人 | 1 周 | 导航或分类不清晰 | ✅ 与 anthropics 一致 |
| 日志研究 | 理解长期行为 | 10-15 人 | 2-8 周 | 需要理解使用模式和频率 | ✅ 与 anthropics 一致 |
| A/B 测试 | 对比特定设计方案 | 统计显著性 | 1-4 周 | 有两个明确方案需验证 | ✅ 与 anthropics 一致 |

---

## 详细方法与模板

> 📖 **按需加载** — 下方列出各方法的完整产出模板与执行细节，点击展开使用。

| 需求场景 | 加载文件 | 提供内容 |
|----------|----------|----------|
| 准备用户访谈提纲 | [reference/interview-guide.md](reference/interview-guide.md) | 5 区块访谈提纲（Warm-up / Context / Deep Dive / Reaction / Wrap-up），含探针与追问 |
| 用户反馈聚合分析 | [reference/affinity-mapping.md](reference/affinity-mapping.md) | Affinity Mapping 完整报告模板：原始反馈清单 / Theme 分组 / Insight 矩阵 / 行为模式 / 需求优先级 |
| 复杂用户旅程梳理 | [reference/journey-map.md](reference/journey-map.md) | 用户旅程图完整模板：阶段 / 触点 / 目标 / 思维 / 行为 / 情绪 / 痛点 / 机会点 / Moments That Matter |
| 提炼用户 Jobs | [reference/jtbd.md](reference/jtbd.md) | Jobs to Be Done 完整模板：核心 Jobs（功能性/情感性/社会性）/ 优先级矩阵 / 现有方案局限 |

---

## 6 方法 vs 4 模板对照

anthropics/user-research 提供 6 方法定义；openPRD 在 4 个方法上有**深度模板**：

| 方法 | anthropics 定义 | openPRD 深度模板 |
|------|------------------|------------------|
| 用户访谈 | ✅ 5 区块结构 | ✅ [interview-guide.md](reference/interview-guide.md) - 完整 5 区块 + 探针技巧 + 追问话术 |
| 可用性测试 | ✅ 任务设计原则 | ⚠️ 未提供深度模板（按 anthropics 标准即可） |
| 问卷调查 | ✅ 量表设计 | ⚠️ 未提供深度模板（按 anthropics 标准即可） |
| 卡片分类 | ✅ 开放式/封闭式 | ⚠️ 未提供深度模板（按 anthropics 标准即可） |
| 日志研究 | ✅ 周期/参与者 | ⚠️ 未提供深度模板（按 anthropics 标准即可） |
| A/B 测试 | ✅ 统计显著性 | ⚠️ 未提供深度模板（按 anthropics 标准即可） |
| **亲和图（聚合）** | ✅ 提及 | ✅ [affinity-mapping.md](reference/affinity-mapping.md) - 5 步骤完整报告模板 |
| **用户旅程** | ✅ 提及 | ✅ [journey-map.md](reference/journey-map.md) - 9 字段完整模板 |
| **Jobs to be Done** | ✅ 提及 | ✅ [jtbd.md](reference/jtbd.md) - 3 类 Jobs + 优先级矩阵 |

> 注：4 个深度模板是 openPRD 增强，5 个 anthropics 已有定义的方法直接调用其规范即可。

---

## 使用时机

在 `openPRD-user-research` 执行过程中，当遇到以下情况时，调用本技能增强调研深度：

| 场景 | 调用的具体能力 |
|------|---------------|
| 需求不明确，用户说法模糊 | 访谈提纲 + 探针技巧 + 亲和图 |
| 收集到多条用户反馈（5条以上） | Affinity Mapping 分析 |
| 需要选择多个方案之一 | Impact/Effort Matrix 优先级排序 |
| 涉及复杂用户旅程（涉及多角色多系统） | 用户旅程图 |
| 需要验证某个设计方向 | 可用性测试 + Reaction 环节 |
| 需要量化用户偏好 | 问卷设计 + 统计分析框架 |
| 需要理解用户长期行为模式 | 日志研究方法 |

---

## Gotchas (避坑指南)

### G-01: JTBD 访谈 < 5 场,信号就是噪声
- **症状**: 跑 2 场用户访谈就急着提炼 "用户想要 XX",放进 PRD 后发现不能落
- **原因**: 5 场以下是"假信号"——单一用户口径可能只是该用户的特殊情况(例:某销售员说"我天天加班,所以想要移动端",但其他 9 个销售员根本不在外)
- **修正**: 至少 5 场访谈(同质化用户群),或 8 场(异质化群如销售/经理/老板)。3 场以下必须标注"待验证",不写进 PRD 强约束。
- **参考**: examples/01 §PRD §2 用户角色(35 页 CRM 多角色拆分)

### G-02: Affinity Mapping 在 < 10 条反馈上做,是"演戏"
- **症状**: 收集 5 条用户反馈,做了 1 个 affinity diagram(2 个 cluster),声称"归纳出 2 个洞察"
- **原因**: 5 条做 affinity,cluster 必然是"自由分组",统计学上无意义
- **修正**: 至少 10 条反馈起步(理想 25+),否则改用"逐条标注 + 关键词频次"方式提炼。Affinity 是"多→少",不是"5→2"。
- **参考**: reference/affinity-mapping.md(5 步骤完整报告模板)

### G-03: 只用 1 种方法(单方法依赖),结论片面
- **症状**: 只跑访谈不提问卷,只做问卷不做可用性测试,结论是"访谈者说 XX,所以用户都想要 XX"
- **原因**: 节省时间 + 不同方法门槛不同
- **修正**: 至少 2 种方法组合(访谈+问卷 / 访谈+可用性测试 / 日志+访谈)。单方法必在结论中标"待 X 方法验证"。见 examples/02 §经验教训 #1(状态机 + API + DB 三件套强调多源验证)。
- **参考**: examples/02 §经验教训

### G-04: Persona 提炼后无原话支撑,团队无法复用
- **症状**: 报告写"销售员 Bob: 痛点是数据录入慢",但找不到任何"原话引用"或"行为证据"
- **原因**: 提炼 Persona 时"我以为",不是"用户说"
- **修正**: 每个 Persona 至少 1 句原话引用(写"用户原话:...")+ 1 个行为证据(频率/场景/痛点实例)。否则视为"未经验证假设",需在 PRD 标注"待验证"。
- **参考**: examples/01 §PRD §2 角色 + 调研报告模板 §用户画像

**跨子技能常见错误汇总**: 见 reference/16-common-pitfalls.md(由 Sub-agent D 整合,本文件为占位说明)

---

## 完成后

### 1. 提质（保证质量）
- [ ] 调研方法选择有 anthropics/user-research 依据
- [ ] 用户访谈按 5 区块结构（Warm-up / Context / Deep Dive / Reaction / Wrap-up）执行
- [ ] 多条反馈（5+）走 Affinity Mapping
- [ ] 复杂旅程（多角色多系统）走 Journey Map
- [ ] 所有"用户为什么用"问题走 JTBD

### 2. 提量（保证覆盖）
- [ ] 至少 2 种方法组合使用（避免单方法偏差）
- [ ] 用户访谈 ≥ 5 人 或 问卷回收 ≥ 100 份
- [ ] 关键 Persona 有 ≥ 1 个引用原话支持
- [ ] 关键 Insight 有 ≥ 3 个用户反馈支撑

### 3. 交付
- [ ] 增强调研结果追加到用户调研报告
- [ ] 提炼关键 Insight 和设计建议
- [ ] 向用户确认洞察是否符合预期
- [ ] 更新调研报告中的"关键发现"和"设计偏好"章节
- [ ] 返回 `openPRD-user-research` 继续后续流程
