---
name: openPRD-frontend-design
description: Use for frontend design enhancement, design specs, FigmaMake prompts, design system guidance, UI/UX specifications. Triggers on "前端设计", "设计规范", "FigmaMake", "UI 规范", "设计还原", "Figma 提示词". Enhances frontend guidelines and FigmaMake specs - does not generate code, only outputs design guidance and specifications.
---

# 前端设计增强

## 概述

**目的**：基于 frontend-design 的设计思维，增强 openPRD 产出的前端开发指南和 FigmaMake 规范。

**定位**：仅输出设计指引和规范，**不生成代码**。

**前置条件**：已完成用户调研，了解目标用户、使用场景和功能需求。

---

## 核心设计原则

### Design Thinking 流程

```
理解上下文 → 确立设计方向 → 输出设计规范
```

#### 1. 理解上下文

在产出任何设计指引前，先确认：

| 问题 | 目的 |
|------|------|
| 这个界面的核心用户是谁？ | 确定交互优先级 |
| 主要使用场景是什么？ | 确定布局和交互密度 |
| 解决什么痛点？ | 确定功能和信息优先级 |
| 竞品或行业标杆是什么？ | 确定设计参照 |

#### 2. 确立设计方向

根据上下文，选择一个**明确的设计方向**并贯彻始终：

| 方向 | 适用场景 |
|------|----------|
| 极简克制 | 工具类产品、效率后台 |
| 精致奢华 | B端高客单价产品 |
| 活力现代 | 面向年轻用户的产品 |
| 稳重专业 | 金融、医疗、政务类 |
| 温暖亲和 | 面向消费者/用户的平台 |

**必须产出**：2-3 句话描述本项目的设计方向定位

#### 3. 输出设计规范

按下方"设计规范输出"链接的模板填充。

---

## 设计规范输出

> 📖 **按需加载** — 完整 7 个子规范模板（设计方向 / 色彩 / Typography / 间距 / 组件 / 动效 / Figma）见 [reference/design-system-specs.md](reference/design-system-specs.md)。

该 reference 文件包含 3.1-3.7 全部子规范的完整 Markdown 模板与字段说明，**必须原样套用，不得简化**。

---

## 调用时机

在 `openPRD-document-generation` 的以下文档产出时调用：

| 原文档 | 增强内容 |
|--------|----------|
| `04-前端开发指南.md` | 设计方向定位、色彩规范、Typography 规范、间距规范、组件规范 |
| `07-FigmaMake规范.md` | Figma 设计规范、设计系统选择、标注要求 |

---

## 输出格式

将以上规范内容追加到对应文档的**设计规范章节**中：

```markdown
## 设计规范

### 本项目设计方向
[输出 3.1]

### 色彩规范
[输出 3.2]

### Typography 规范
[输出 3.3]

### 间距与布局规范
[输出 3.4]

### 组件规范
[输出 3.5]

### 动效规范
[输出 3.6]

### Figma 设计规范
[输出 3.7]
```

---

## Gotchas (避坑指南)

### G-01: 主 Agent 选组件库靠"训练记忆",Claude 默认 Inter + 紫色渐变
- **症状**: 04-前端开发指南写"使用 Roboto + 紫色 #5B21B6 渐变",但项目实际是 antd + 蓝色 #1677ff
- **原因**: Claude 训练偏好 Inter + 紫色渐变(生成式 UI 常用),不查项目实际
- **修正**: 必先调用 openPRD-context7-integration 验证组件库当前 API + 默认主题;必查 `src/styles/GlobalStyled.jsx` 实际色值,不能"凭感觉选"。色值对不上 → 整套规范返工。参考 templates/04-前端开发指南.md §色彩规范。
- **参考**: templates/04-前端开发指南.md + openPRD-context7-integration

### G-02: `<button>` vs `<Button>` 不区分,React 多端代码风格混乱
- **症状**: H5 端用 `<Button>`(React 组件),同项目 H5 的另一处用 `<button>`(原生 HTML),视觉/交互不一致
- **原因**: agent 生成时随手写,没注意统一组件
- **修正**: 04-前端开发指南 §组件规范**明确"必用 `<Button>` 组件,禁止原生 `<button>`"**。统一组件库 1 个,所有端复用。多端(PC/H5/小程序)差异列在"端差异表"里,不放"组件替换表"里。参考 examples/01 §9-前端指南。
- **参考**: templates/04-前端开发指南.md

### G-03: 动效规范写"现代、流畅、丝滑"等空话,无具体参数
- **症状**: 04-前端开发指南 §动效规范写"按钮 hover 有现代感过渡",前端写 0.5s ease 随便挑
- **原因**: agent 用"感性词"代替"参数"
- **修正**: 动效规范必含 3 类参数:(1) **时长**(fast 150ms / normal 250ms / slow 400ms) (2) **缓动**(ease-out / cubic-bezier(0.4, 0, 0.2, 1)) (3) **触发场景**(hover / press / page-transition)。3 类齐全前端才能 1:1 还原。参考 templates/04-前端开发指南.md §动效规范。
- **参考**: templates/04-前端开发指南.md

### G-04: 设计方向写"现代商务"但色彩/字体/间距自相矛盾
- **症状**: 设计方向写"极简克制",但色彩用 5 种高饱和度色 + 阴影 + 渐变,与极简矛盾
- **原因**: 三个规范(色彩/字体/间距)独立产出,没回看"设计方向"是否自洽
- **修正**: 产出 4 个子规范(色彩/字体/间距/组件)后,**自检 1 次"是否与设计方向自洽"**。例:"极简" → 色 ≤ 3 + 无阴影 + 间距 8 倍数 + 组件无装饰。1 处矛盾 → 返工。参考 templates/04-前端开发指南.md。
- **参考**: templates/04-前端开发指南.md

**跨子技能常见错误汇总**: 见 reference/16-common-pitfalls.md(由 Sub-agent D 整合,本文件为占位说明)

---

## 完成后

1. 将设计规范内容追加到 `04-前端开发指南.md` 的**设计规范章节**
2. 将 Figma 规范追加到 `07-FigmaMake规范.md`
3. 向用户确认设计方向是否符合预期
4. 返回 `openPRD-document-generation` 继续后续文档产出
