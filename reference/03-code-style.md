# 代码风格验证（详细参考）

## 概述

**⚠️ 禁止使用近似值**

每次产出文档前，必须验证以下文件。

---

## 1. 颜色验证

| 文件 | 验证内容 | 常见错误 |
|------|----------|----------|
| `GlobalStyled.jsx` | 主操作色 #635BFF | Mock 使用 #10b981 而非 #15b79f |
| `GlobalStyled.jsx` | 成功色 #15b79f | Mock 使用 #10b981 |
| `GlobalStyled.jsx` | 危险色 #fb5248 | - |
| `GlobalStyled.jsx` | 文字色 #212636, #667085 | - |

---

## 2. 布局验证

| 文件 | 验证内容 |
|------|----------|
| `LayoutStyled.jsx` | 内容区 max-width: 1392px, min-width: 916px |
| `LayoutStyled.jsx` | 页面 padding: 24px |

---

## 3. 组件验证

| 文件 | 验证内容 |
|------|----------|
| TitleStyled.jsx | 标题样式 |
| CustomTableStyled.jsx | 表格、操作文字样式 |
| EmptyStyled.jsx | 空状态样式 |
| SearchFormStyled.jsx | 表单样式 |

---

## 4. 验证流程

```
1. 读取 GlobalStyled.jsx
2. 读取 LayoutStyled.jsx
3. 读取相关组件 styled 文件
4. 将验证结果记录到文档中
5. 如发现与 mock 代码不一致，以 GlobalStyled.jsx 为准
```

---

## 5. 前端开发要点

### 5.1 组件使用规范

| 规范 | 说明 |
|------|------|
| 必须使用 Ant Design 组件 | 使用 Input, Select 等组件，不使用原生 HTML |
| 遵循三合一模式 | Component + Styled + Service |
| 颜色必须验证 | 禁止使用 mock 中的近似值 |

### 5.2 颜色参考（已验证）

| 用途 | 色值 | 说明 |
|------|------|------|
| 主操作 | #635BFF | 按钮、链接 |
| 成功 | #15b79f | 状态标识（不是 #10b981） |
| 危险 | #fb5248 | 错误、删除 |
| 文字主 | #212636 | 主文字 |
| 文字辅助 | #667085 | 辅助文字 |

### 5.3 布局参考

| 用途 | 数值 |
|------|------|
| 页面内边距 | 24px |
| 卡片间距 | 24px |
| 元素间距 | 16px |
| 圆角 | 8px |
| 内容区最大宽度 | 1392px |
| 内容区最小宽度 | 916px |

---

## 6. FigmaMake 规范要点

### 6.1 精确值要求

FigmaMake 需要**精确值**，必须从源码读取：
- 颜色值：必须来自 GlobalStyled.jsx
- 间距：必须来自 LayoutStyled.jsx 或组件 styled 文件
- 字体：必须来自相关样式文件

### 6.2 禁止事项

- ❌ 使用 mock 中的近似颜色
- ❌ 使用记忆中的数值
- ❌ 假设类似项目有相同值
