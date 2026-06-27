---
name: openPRD-document-generation
description: Use for documentation generation, PRD output, interface docs, task breakdown, development handoff. Triggers on "生成文档", "输出文档", "需求方案", "开发文档", "PRD 产出", "接口文档", "任务拆分". Generates README, architecture, interface specs, frontend guide, FigmaMake specs, and task breakdown based on research.
---

# openPRD - 文档产出

## 概述

**目的**：基于调研结果，产出完整的开发文档包。

**前置条件**：
1. ✅ 用户调研已完成
2. ✅ 行业分析已完成（如果涉及特定行业）
3. ✅ **交付范围已确认**（后端同时实现 vs 只考虑前端）

**产出模式**：

| 模式 | 条件 | 产出内容 |
|------|------|----------|
| **完整模式** | 用户选择"后端同时实现" | 全部文档（含数据库设计、后端任务、测试用例） |
| **简化模式** | 用户选择"只考虑前端" | 核心文档（含Mock数据、接口契约、无后端任务） |

---

## 执行步骤（6 步法）

> 📖 **详细说明** — 6 步执行细节（确认范围 / 代码风格验证 / 按序产出 / 内容规范 / 测试用例定制 / 最终检查）见 [reference/execution-steps.md](reference/execution-steps.md)。

### 步骤摘要

| 步骤 | 关键动作 | 输出 |
|------|----------|------|
| 1. 确认产出范围 | 读取用户的"后端/前端"选择 | 完整模式 vs 简化模式 |
| 2. 代码风格验证 | 读取 GlobalStyled.jsx / LayoutStyled.jsx | 颜色与布局已验证值 |
| 3. 按序产出文档 | 按 14 步产出顺序生成 | 14 份文档 |
| 4. 文档内容规范 | 流程图/表格/加粗/代码块 | 实用性强的内容 |
| 5. 测试用例定制 | 按模块类型定制用例 | 10-20 条核心用例 |
| 6. 最终检查 | 6 大类检查清单 | 最终检查报告 |

> ⚠️ 详细执行内容请展开 reference 文件读取，**不得跳过任何步骤**。

---

## 模板位置

```
~/.claude/skills/openPRD/templates/
├── 01-README.md                    ✅
├── 02-项目整体说明.md              ✅
├── 03-接口文档.md                  ✅
├── 04-前端开发指南.md              ✅
├── 05-任务拆分与交付.md            ✅
├── 06-产品需求文档.md              ✅
├── 07-测试用例.md                  ✅（根据模块定制）
├── 08-内部交互链路.md              ✅（前后端交互）
├── 09-后端开发指南.md              ✅
├── 10-前端交互文档.md              ✅
├── 11-Mock数据文档.md              ✅
├── 12-数据库设计.md                ✅
├── 13-架构设计.md                  ✅
├── 14-行业分析报告.md              ✅（可选）
├── FigmaMake-Prompt.md             ✅
└── 用户调研报告模板.md             ✅
```

---

## 完成后

1. **执行最终检查** - 按照第六步检查清单逐项确认
2. **生成检查报告** - 输出"最终检查报告"章节
3. **向用户汇报** - 报告产出物清单和检查结果
4. **等待用户确认** - 用户确认后交付

---

## 并行 Track 调度（5 Track）

> 📖 **加载时机**：当文档数量 ≥ 5 且任务间无强冲突时使用。规模较小时退回 14 步顺序产出。

### 调度前提

| 前提 | 说明 |
|------|------|
| 用户已完成需求确认 | Stage 1/2 已结束 |
| 行业分析/竞品分析已产出 | 作为 Track A 的输入 |
| 交付模式已确认（完整 vs 简化） | 决定 Track D 是否参与 |

### 5 Track 分配

| Track | 文档 | 依赖 | 简化模式 |
|-------|------|------|----------|
| **A Core** | 01-README + 02-项目整体说明 + 06-产品需求文档 | 调研+行业+竞品 | ✅ 参与 |
| **B Interface** | 03-接口文档 | Step 1 用户调研 | ✅ 参与（Mock） |
| **C Frontend** | 04-前端开发指南 + 10-前端交互 + 11-Mock + FigmaMake | Track B | ✅ 参与 |
| **D Backend** | 09-后端 + 12-数据库 + 13-架构 + 08-内部交互 | Track B | ❌ 仅完整模式 |
| **E Quality** | 07-测试用例 + 05-任务拆分 | Track A + B | ✅ 参与 |
| **F 展示(v4.4 可选)** | 20-架构脑图（业务+产品 × 4 格式） | Track A + B | ✅ 参与(可选) |

### 依赖图

```
Track A Core ─────────────────┐
                              ↓
Track B Interface ─────┬─────┴─────┐
                       ↓           ↓
                Track C Frontend   Track E Quality
                       ↓                ↓
                Track D Backend [仅完整]  Track F 展示(可选架构脑图)
```

**Track F(架构脑图,v4.4 新增)**:独立子技能 `openPRD-architecture-mindmap`,触发条件:
- 用户原始消息含 架构脑图/业务架构/产品架构/mindmap/xmind 任一词
- 用户在 Step 4 文档产出阶段说"顺便出张脑图"或"给老板/客户展示"
- 产出 8 份文件到 `*-docs/architecture/`,并在 06-PRD §0 嵌入 Mermaid 块
- 详见 [`openPRD-architecture-mindmap/SKILL.md`](../openPRD-architecture-mindmap/SKILL.md)

### 受众感知调度（v4.2.2）

> 📖 **规则来源**：[reference/19-audience-tag-table.md §3-4](../reference/19-audience-tag-table.md) — 完整受众映射 + 摘要降级规则

**调度流程**（在每个 Track 完成后、文件写入前执行）：

1. 读取 `.openprd/config.json` 的 `default_audiences` 字段（默认全选）
2. 对本 Track 负责的每个模板，从 `reference/19` §2 映射表查"主受众"
3. 主受众在 `default_audiences` 中 → 产出**全文**
4. 主受众不在 `default_audiences` 中 → 调用 `reference/19-summarizer.py` 生成 ≤ 200 字**摘要**，写入同文件末尾的"## 摘要(降级输出,200 字内)"段（不覆盖全文）

**调用命令**：

```bash
# 对 templates/15-ab-test-design.md 排除"产品"受众生成摘要
python3 reference/19-summarizer.py templates/15-ab-test-design.md 产品
```

**降级后结构**（参考 reference/19 §3.1 固定结构）：

```markdown
## 摘要(降级输出,200 字内)

> 本文档已降级。受众 [排除列表] 未列入产出范围。
> 模板定位:[第一个 ### 章节]

**核心决策**:
- [⭐ 决策 1-5 条]

**关键数字/对象**:[P0 数 / API 数 / 表数 / 合规条款数]

**完整版见**:`templates/XX-xxx.md`(主受众可访问)
```

**合规特殊规则**（reference/19 §3.5）：即使合规受众被排除，14-合规清单 的核心 5 条（GDPR / 个保法 / 等保 / 行业资质 / 跨境传输）**必须保留**为摘要中的 5 个 bullet——合规风险零容忍。

**5 Track 受众影响**：

| Track | 主受众 | 排除"产品" | 排除"技术" | 排除"运营" | 排除"合规" |
|-------|--------|-----------|-----------|-----------|-----------|
| A Core | 产品 | 摘要 | 全文 | 全文 | 全文 |
| B Interface | 技术 | 全文 | 摘要 | 全文 | 全文 |
| C Frontend | 技术 | 全文 | 摘要 | 全文 | 全文 |
| D Backend | 技术 | 全文 | 摘要 | 全文 | 全文 |
| E Quality | 技术 | 全文 | 摘要 | 全文 | 全文 |
| **14-行业分析** | **运营** | 全文 | 全文 | **摘要** | 全文 |
| **14-合规** | **合规** | 全文 | 全文 | 全文 | **摘要（保留 5 核心）** |

**Gotcha G-06**（受众调度）：摘要生成必须**早于**文件写入,否则会出现"全文已写又被摘要覆盖"的回滚。

### 执行步骤

1. **主 Agent 调度**：将 5 个 Track 分发给 5 个 subagent **并行**执行
2. **每个 subagent 收到**：
   - 输入：上游产出物（调研报告、行业分析、接口契约）
   - 任务清单：本 Track 包含的文档列表
   - 输出路径：`{需求名称}-docs/{文档名}.md`
3. **主 Agent 收口验证**：
   - Track A/B/C/E 全部完成后才能开始 Track D
   - Track E 必须在 Track A、B 都完成后才能产出（避免测试和任务拆分与产品/接口不一致）
4. **失败回退**：任一 Track 失败时，主 Agent 重试该 Track（不影响其他 Track）

### 冲突规避规则

| 规则 | 说明 |
|------|------|
| 不同 Track 操作不同文件 | 5 个 Track 各自负责的文档列表不重叠 |
| Track A 与 B 都引用接口契约 | A 的产品需求引用 B 的接口定义，**B 先于 A 完成**或 A 引用 B 占位字段 |
| Track C 引用 B 接口契约 | 同上，B 先完成 |
| Track D 引用 B + A | D 是最后完成，依赖 A 和 B 都已产出 |
| Track E 引用 A + B | E 引用 A 的产品需求和 B 的接口 |

### 何时退回顺序产出

| 场景 | 退回原因 |
|------|----------|
| 文档数 ≤ 5 | 并行开销大于收益 |
| Track 间冲突 > 3 处 | 难以协调 |
| 用户没确认上游 | 强依赖未解除 |
| 项目无后端 | Track D 不参与，但仍可用 4 Track 并行 |

---

## Gotchas (避坑指南)

### G-01: 06d 组件库章节最容易超长(>300 行),按页面分组而非平铺
- **症状**: 06d 组件库章节写到 800 行,堆 50+ 个组件,按"组件 1/组件 2/组件 3"平铺,无结构
- **原因**: agent 按"组件分类"组织(Button/Input/Table),但读者需要的是"按页面"找组件
- **修正**: 06d 必按"页面 × 组件"二维组织——按 35 个页面分组,每页列该页用到的 3-8 个组件及其变体。例:"线索详情页" → 头部(Breadcrumb/StatusBadge/ActionGroup)+ Tab(Table/Timeline/EmptyState)+ 表单(Form/Field/DatePicker)。这样开发找组件时按页面索引 1 步到位。参考 templates/06d-产品需求-组件库与交互.md。
- **参考**: templates/06d-产品需求-组件库与交互.md

### G-02: 05-任务拆分"1-3 天"粒度常被打破,>3 天必再拆
- **症状**: 任务表写"前端开发 - 8 天",工时 8d 必延期,实际 12-15d
- **原因**: 任务粒度太大,1 个任务含 5+ 页面,期间无法"分步验收"
- **修正**: **每个任务必 1-3 天**,>3 天必再拆(例:"前端开发 8 天" → "线索模块前端 2d / 客户模块 2d / 商机模块 2d / 联调 2d")。验收节点 = 任务边界,可独立完成/Review。例:examples/02 §任务拆分(8 个任务均 0.5-3 天)。
- **参考**: examples/02 §关键章节节选 §任务拆分

### G-03: "五字段交叉对比"不做,联调返工 50%+
- **症状**: 联调时发现 PRD 中 userId(驼峰) vs DB 中 user_id(下划线) vs Mock 中 userID(全大写) — 3 处拼写不一致
- **原因**: 6 份文档独立产出,字段名未统一治理
- **修正**: **5 字段(userId / status / 必填规则 / 错误码 / P0 功能名)必在 6 处交叉对比**:02-项目整体说明、06-PRD、03-接口文档、12-数据库设计、11-Mock 数据、08-内部交互链路。任何一处不一致 → 阻塞。统一表见 reference/15-five-field-crosscheck.md(Sub-agent D 整合)。
- **参考**: reference/06-cross-document-consistency.md + reference/15-five-field-crosscheck.md

### G-04: FigmaMake-Prompt.md 不含颜色值,设计稿"看起来对"但实际偏离
- **症状**: FigmaMake 提示词写"现代商务风格,蓝色主色调",生成的设计稿主色是 #2962FF(随便定的),与实际 GlobalStyled.jsx 的 #635BFF 偏离
- **原因**: 提示词不给具体色值,FigmaMake 用模型默认色
- **修正**: FigmaMake 提示词**必含 3 类具体值**:(1) **色值**(主色 #635BFF、辅色 #15b79f、危险色 #fb5248) (2) **字体**(PingFang SC / Inter 14px) (3) **间距**(8 倍数 8/16/24/32)。3 类值参考 templates/FigmaMake-Prompt.md + reference/00-INDEX §2.2 颜色验证。例:examples/01 §06-PRD §12 设计规范。
- **参考**: templates/FigmaMake-Prompt.md + 00-INDEX §2.2

### G-05: 测试用例 7a/7b/7c 拆分错位,核心模块用例塞到"扩展模块"
- **症状**: 7a(核心模块)用例只写 3 个,7b(扩展模块)写 18 个,但实际业务上"用户登录"是核心,7b 反着写
- **原因**: agent 按"工作量平衡"硬拆,不看业务 P0 等级
- **修正**: 7a(核心模块)P0 用例必含(登录 / 主数据增删改查 / 状态机主流程),7b(扩展)只含辅助功能,7c(边界异常)集中放异常用例。三件套加起来 ≥ 20 个 P0 用例。例:examples/02 §7 测试用例(30 个用例含核心 18 + 扩展 8 + 异常 4)。
- **参考**: examples/02 §关键章节节选 §测试用例

### G-06: v4.2.2 受众感知调度——摘要生成必须早于文件写入
- **症状**: 全文已写到 `{需求名称}-docs/XX.md`,再调 `python3 reference/19-summarizer.py` 生成 200 字摘要 append,结果用户在编辑器里看到"全文 + 摘要"两个版本,选错版
- **原因**: 调度顺序错——Step 3 写完文件才发现该降级,只能 append 不能替换
- **修正**: 严格按 [### 受众感知调度（v4.2.2）](#受众感知调度v422) 的"调度流程 4 步":① 读 `default_audiences` → ② 查映射表 → ③ 调 summarizer 生成摘要内容 → ④ **同时**写全文 + 摘要到文件(摘要放文件末尾的 `## 摘要(降级输出,200 字内)` 段)。**禁止**"写完全文再补摘要"的两步走。
- **参考**: reference/19-summarizer.py 用法 + reference/19 §3-4

**跨子技能常见错误汇总**: 见 reference/16-common-pitfalls.md(由 Sub-agent D 整合,本文件为占位说明)
