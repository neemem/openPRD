# Multi-Subagent 并行执行 - 调度详细

> **来源**:从主 SKILL.md 中拆分(主文件保留流程骨架 + 一句"详见 reference/10")。
> 本文件是 v4.0 架构升级后的**单一调度规则来源**,所有 4 阶段调度、依赖矩阵、并行规则、简化场景的详细定义。

## 核心思想

将**独立且无强依赖**的任务分发给多个 subagent **并行**处理,提升产出效率。但**严格遵守依赖关系**——下游任务必须在上游确认完成后才能开始。

**主 Agent 职责**:
- 串行执行所有**用户交互节点**(询问、确认、回答)
- 调度 subagent,传递上游产出物作为输入
- 验证 subagent 输出完整性后再调度下游
- 整合所有产出物,生成汇总报告与自检

## 4 阶段调度图

```
【Stage 0 - 串行·主 Agent】
Step 0: 明确交付范围(后端 vs 前端Mock + 页面级 vs 功能级)
         ↓
【Stage 0.5 - 串行·主 Agent·关键问题先行】
Step 0.5: 关键问题 Q1+Q2(35 题调研的前 2 个)
         ↓
【Stage 1 - 并行 1+5+1 路·subagent + 主 Agent】  ← 升级:5 路行业研究并行
   ├─ 主 Agent: 完成 Step 1b 剩余问答 Q3-Q35(与 5 路并行)
   ├─ Subagent A: 行业分析 (openPRD-industry-analysis)
   ├─ Subagent B: 竞品分析 (openPRD-competitor-analysis)
   ├─ Subagent C: 标杆研究 (openPRD-deep-research)
   ├─ Subagent D: 法规合规 (openPRD-regulation-compliance)
   ├─ Subagent E: 技术趋势 (openPRD-tech-trends)
   └─ [Optional] Subagent F: 用户深度研究 (openPRD-user-research-enhancement)
         ↓ Stage 1 全部完成后
【Stage 1.5 - 串行收口·主 Agent】
应用三级质量门控 G1(单 subagent)+ G2(阶段产出)
向用户确认 Stage 1 关键发现,整合输入到 Stage 3
         ↓
【Stage 2 - 并行 5 Track·subagent - 文档产出】
   ├─ Track A Core: 01-README + 02-项目整体说明 + 06-产品需求文档(页面级拆 06a-06h)
   ├─ Track B Interface: 03-接口文档
   ├─ Track C Frontend: 04-前端开发指南 + 10-前端交互 + 11-Mock + FigmaMake
   ├─ Track D Backend [仅完整模式]: 09-后端 + 12-数据库 + 13-架构 + 08-内部交互
   └─ Track E Quality: 07-测试用例(拆 3 段)+ 05-任务拆分
         ↓ Stage 2 全部完成后
【Stage 3 - 串行收口·主 Agent】
应用三级质量门控 G3(全局)
最终自检 → 生成汇总报告 → 向用户汇报
```

## 依赖关系矩阵

| 任务 | 强依赖 | 备注 |
|------|--------|------|
| **Stage 1 - 调研** | | |
| 行业分析 (A) | Q1+Q2 | 必须先知道需求主题和目标用户 |
| 竞品分析 (B) | Q1+Q2 | 同上 |
| 标杆研究 (C) | Q1+Q2 | 同上 |
| 法规合规 (D) | Q1+Q2 | 同上 |
| 技术趋势 (E) | Q1+Q2 | 同上 |
| 用户深度研究 (F) | Q1+Q2 + Q3-Q35 | 可选增强 |
| **Stage 2 - 文档产出** | | |
| Track A Core (01/02/06) | Stage 1 全部完成 | 需要产品需求背景 |
| Track B Interface (03) | Stage 1 全部完成 | 接口契约源自需求 |
| Track C Frontend (04/10/11/Figma) | Track B 完成 | 前端开发需先有 API 契约 |
| Track D Backend (09/12/13/08) | Track B 完成 | 后端开发需先有 API 定义 |
| Track E Quality (07/05) | Track A + B 完成 | 测试用例与任务拆分需要产品+接口 |

## 并行执行规则

| # | 规则 | 违反后果 |
|---|------|----------|
| 1 | **独立可并行**的任务才分发 subagent | 强依赖任务并行会导致返工 |
| 2 | 每个 subagent 必须有**明确输入与输出路径** | 输入丢失导致产出偏离 |
| 3 | subagent 完成后**主 Agent 必须验证产出** | 不验证会传递错误给下游 |
| 4 | 同一文件**不可被两个 subagent 同时编辑** | 文件冲突、内容丢失 |
| 5 | subagent 失败时**主 Agent 接管重试** | 自动跳过会导致缺口 |
| 6 | 用户未确认上一阶段时**不调度下游** | 返工成本极高 |

## 何时不用并行

| 场景 | 原因 |
|------|------|
| 任务量极小(如单页修改、纯文案调整) | 并行调度开销大于收益 |
| 用户还没确认上一阶段产出 | 强依赖未解除 |
| 上下游涉及强一致性(如数据库 schema 与后端 API 字段) | 必须串行以保证一致 |
| 项目首次接触、需求未澄清 | 先串行调研,再考虑并行 |

## 简化场景:单 Track 串行

当文档数量 ≤ 5 或任务极小时,可降级为单 Track 串行:

```
Step 1 用户调研 → Step 2 行业分析 → Step 3 文档产出(按 14 步顺序)→ Step 4 汇总
```

**判断标准**:如果项目仅涉及单一前端模块、≤3 个页面、无后端 API 改动,可直接用 openPRD-document-generation 的 14 步顺序产出,不强行并行。
