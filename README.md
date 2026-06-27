# openPRD · V5.0

> 📖 **需求到交付的完整开发文档生成器**
> 基于 35 题用户调研 + 5 路并行行业研究 + 39 份产品文档的全流程 Skill
>
> **版本**:V5.0 (2026-06-27)
> **验证项目**:新兰界 39 份文档 / 1.81 MB / 平均 47 KB · 4 级质量门控全通过

---

## 🎯 这是什么?

openPRD 是一个**完整的需求到交付工作流**,适用中型项目(15-50 份产品文档)。

**典型应用**:
- ✅ 微信公众号 H5 / 小程序
- ✅ Web 应用(配合 Figma 产出)
- ✅ 移动端 App
- ✅ 通用 SaaS / 内部工具

**不适合**:
- ❌ 极简 demo(< 5 份文档)
- ❌ 强合规(医疗/金融/跨境)
- ❌ 纯代码生成(无设计/法务需求)

---

## ⚡ 5 分钟快速开始(Claude Code CLI)

### 第 1 步:安装

**方式 A(zip 包,当前推荐)**:
```bash
cd ~/Downloads
unzip openPRD-v5.0-skill.zip
cp -r openPRD/ ~/.claude/skills/
ls ~/.claude/skills/openPRD/SKILL.md
```

**方式 B(URL 安装,未来支持)**:
```bash
npx skills add https://github.com/openPRD-team/openPRD-skill
```

**方式 C(Git 仓库)**:
```bash
git clone https://github.com/openPRD-team/openPRD-skill.git
cp -r openPRD-skill/ ~/.claude/skills/openPRD/
```

**多平台分发**:
```bash
bash ~/.claude/skills/openPRD/distribute.sh all
# 生成 3 平台分发包到 ~/Downloads/
```

**详细安装说明**:参考 `INSTALL.md`

### 第 2 步:触发

在 Claude Code CLI 中:
```
> /openPRD
```

或自然语言:
```
> 帮我做一份完整的产品 PRD
> 从需求到交付,产出 38 份文档
```

### 第 3 步:提供 PRD

准备一份产品需求文档(.md / .docx / .txt 均可),包含:
- 产品 Slogan
- 目标用户
- 核心功能
- 商业模式

### 第 4 步:回答 35 题

主 Agent 会自动问 35 个关键问题(G1-G9 共 9 组),请逐一回答。

### 第 5 步:获得产出

完成后获得 **38+ 份产品文档**:
- `00-汇总报告.md`(项目入口)
- `06-产品需求文档.md`(核心 PRD,16 章)
- `12-数据库设计.md`、`13-架构设计.md`
- `15-法律-*.md`(4 份法律协议)
- 等

---

## 📂 目录结构

```
openPRD/                                # Skill 根目录
├── SKILL.md                            # ⭐ 主入口(37KB)
├── README.md                           # ⭐ 本文件(使用说明)
├── reference/                          # 深度内容(28 个文件)
│   ├── 01-22.md                       # 核心内容
│   ├── 23-25.md                       # V5.0 跨平台/Matt Pocock/二次分析
│   └── 28-29.md                       # V5.0+ 医疗扩展
├── templates/                          # 文档模板
├── openPRD-*/                          # 8 个子 Skill
└── CHANGELOG/                         # 变更日志(19 个版本)
```

---

## ✨ V5.0 新增内容

| 新增 | 内容 | 大小 |
|---|---|---|
| 跨平台方案 | 适配 Claude Code / OpenCode / Codex | 28K |
| Matt Pocock 方法论 | 渐进式披露/结构化/脚本化 | 11K |
| 二次分析 | 13 必问 + "无脑丢 PRD"处理 | 11K |
| 医疗扩展 | SaMD + AI Agent(预留) | 43K |

**openPRD Skill 本体(SKILL.md / 23 个原 reference/ / 8 个子 Skill):零修改**

---

## 📋 文档产出清单(典型项目)

| 类别 | 文档 | 数量 |
|---|---|---|
| 项目管理 | 00 汇总 / 01 README | 2 |
| 项目级 | 02 整体说明 | 1 |
| 任务 | 05 任务拆分 | 1 |
| 产品需求 | 06 主文档 + 06a-i 拆分 | 10 |
| 设计 | FigmaMake-Prompt | 1 |
| 内部交互 | 08 内部交互链路 | 1 |
| 技术实现 | 03/04/09/10/11/12/13 | 7 |
| 测试 | 07 测试用例 | 1 |
| 行业研究 | 14 行业/竞品/标杆/合规/技术趋势 | 5 |
| 运维 | 14 扩容/日志/灾备/监控 | 4 |
| 法律 | 15 会员/用户/退款/隐私 | 4 |
| 上线 | 16 上线清单 | 1 |
| **总计** | | **38+** |

---

## ⚠️ 重要注意点

### 1. V5.0 质量门控

| 维度 | 要求 |
|---|---|
| 文档字节 | P0 ≥ 40K / P1 ≥ 30K / P2 ≥ 20K |
| 引用量 | 至少 5 个引用 |
| 引用权威性 | 至少 1 个 [权威] 来源 |
| 决策整合 | 35 题决策引用 ≥ 5 处 |

### 2. 用户输入要求

- ✅ **必填**:产品 Slogan / 目标用户 / 核心功能 / 商业模式
- ✅ **必填**:35 题全部回答(可分批)
- ⚠️ **可选**:行业背景 / 竞品分析 / 商业模式数据

### 3. 资源要求(Claude Code CLI)

- 5 路并行子 Agent(~10min 节省)
- 文档产出最长 ~45min
- 适合中型项目

### 4. 已知限制

- ❌ 不支持强合规(医疗/金融/跨境)
- ❌ OpenCode/Codex 不支持子 Agent(自动降级)
- ❌ 单一 Skill 实例

---

## 🔧 安装方式(Claude Code CLI)

### 方式 1:从 zip 包安装(推荐)

```bash
# 1. 下载
cd ~/Downloads
unzip openPRD-v5.0-skill.zip

# 2. 安装
cp -r openPRD/ ~/.claude/skills/

# 3. 验证
ls ~/.claude/skills/openPRD/SKILL.md

# 4. 重启 Claude Code CLI
```

### 方式 2:从 Git 仓库

```bash
git clone https://github.com/your-org/openPRD-skill.git
cp -r openPRD-skill/ ~/.claude/skills/openPRD/
```

### 方式 3:跨平台安装(可选)

> 💡 **大多数用户只需要 Claude Code CLI 即可**。如果你使用 OpenCode 或 Codex CLI,需要做额外适配。

```bash
# OpenCode(开源替代)
mkdir -p ~/.config/opencode/skills/
cp -r openPRD/ ~/.config/opencode/skills/
# 注意:子 Agent 支持有限,自动降级为主 Agent 串行

# Codex CLI(OpenAI)
mkdir -p ~/.codex/prompts/
# 配合 install-cross-platform.sh 转换(未来支持)
```

**⚠️ 多平台同时安装**:技术上可行,但**通常不需要**。建议:
- **主平台**:Claude Code CLI(完整支持)
- **备选**:OpenCode / Codex(降级支持,仅用于简单场景)

---

## 📖 使用流程

### Phase 0:范围确认(~2min)

主 Agent 自动判断 7 维度(项目类型/终端/BI/合规等)。

### Phase 1:用户调研(~25min)

- **Step 1a**:Q1+Q2 关键问题
- **Step 1b**:Q3-Q35 共 33 题(分 9 批)
- **V5.0 二次分析**:13 必问(可选)

### Phase 2:5 路并行行业研究(~3min)

A 行业 / B 竞品 / C 标杆 / D 法规 / E 技术

### Phase 3:文档产出(~45min)

- Track A:13 份 PRD
- Track B/C/D:7 份技术
- Track E:11 份其他
- Legal:4 份法律

### Phase 4:质量门控(~3min)

G1 形式 + G1.5 产物 + G2 阶段 + G3 全局

### Phase 5:交付

- 生成 `00-汇总报告.md`
- 列出 38 份文档 + 交叉引用

---

## 🔍 故障排除

### Q1:找不到 Skill?

```bash
ls ~/.claude/skills/openPRD/
# 应包含:SKILL.md reference/ templates/ CHANGELOG/
```

### Q2:触发无响应?

- 确认在 Claude Code CLI 中(不是普通终端)
- 重启 Claude Code CLI
- 检查版本 ≥ 1.0

### Q3:子 Agent 失败?

- 主 Agent 自动降级为主 Agent 串行
- 检查 `.openprd/state.json`(如有断点续做)

### Q4:文档内容太少?

- 确认符合 `min_size_per_doc`(P0 ≥ 40K)
- V5.0 触发 V1.5 扩充

### Q5:跨文档不一致?

- 主 Agent 自动跑 5 字段交叉验证
- 输出质疑清单

---

## 📊 版本历史

| 版本 | 日期 | 主要变更 |
|---|---|---|
| v5.0 | 2026-06-27 | 跨平台 + Matt Pocock + 二次分析 + 医疗扩展 |
| v4.4.6 | 2026-06-08 | Step 0 自适应 + G0 门控 |
| v4.4.0 | 2026-06-08 | 架构脑图生成 |
| v4.3 | 2026-06-06 | 内容丰富度 |
| v4.2 | 2026-06-06 | 产出范围可选化 |
| v4.1 | 2026-06-06 | 数据看板 |
| v4.0 | 2026-06-06 | 优化版 |
| v3.0 | 2026-06-03 | 页面级强制要求 |
| v2.0 | 2026-06-01 | 子技能拆分 |
| v1.0 | 2025 | 初版 |

完整记录见 `CHANGELOG/`。

---

## 🏗️ 跨平台支持(可选参考)

> 💡 **本节为高级用户准备**。大多数用户只需 Claude Code CLI,不需要关心此节。

| 维度 | Claude Code | OpenCode | Codex |
|---|---|---|---|
| 支持程度 | ✅ **完整(主目标)** | ⚠️ 部分(降级) | ⚠️ 部分(降级) |
| 触发方式 | `/openPRD` | `<name>` | `<name>` |
| 子 Agent | ✅ 5 路并行 | 部分 | ❌ 自动降级 |
| 总耗时 | 75min | 100min | 180min |
| 推荐场景 | **所有项目** | 简单项目 | 应急使用 |

**安装建议**:
- ✅ **优先**:Claude Code CLI(完整支持)
- ⚠️ **可选**:OpenCode(开源替代)
- ❌ **避免**:Codex CLI(性能差)

如果确实需要多平台:
```bash
# 各自平台单独安装(不要同时运行)
# Claude Code: cp -r openPRD/ ~/.claude/skills/
# OpenCode: cp -r openPRD/ ~/.config/opencode/skills/
# Codex: 待 install-cross-platform.sh 成熟
```

---

## 📚 进阶阅读

| 文档 | 用途 |
|---|---|
| **`INTRO.md`** | **Skill 介绍(单文件,Matt Pocock 模式)** 🆕 |
| `INSTALL.md` | 详细安装指南(3 种方式) |
| `SKILL.md` | Skill 主流程说明(必读) |
| `reference/01-22.md` | 深度内容(按需) |
| `reference/23-cross-platform-and-v5-improvements.md` | V5.0 跨平台 |
| `reference/24-matt-pocock-skill-best-practices.md` | 写作方法论 |
| `reference/25-user-research-secondary-analysis.md` | 二次分析 |
| `reference/28-medical-domain-extension.md` | 医疗 SaMD(V5.1) |
| `reference/29-medical-ai-agent-extension.md` | 医疗 AI Agent(V5.1) |
| `CHANGELOG/v5.0-best-practices.md` | V5.0 变更日志 |
| `install-cross-platform.sh` | 跨平台安装脚本 |

---

## 🤝 贡献与反馈

- **问题反馈**:在对话中告诉主 Agent
- **改进建议**:在 CHANGELOG/ 追加新版本
- **新增 reference**:放在 reference/ 子目录(不动 SKILL.md)
- **新增工具脚本**:放在根目录

---

## 📜 许可证

Copyright © 2026 neemem. All rights reserved.

---

## 👤 作者

| 项 | 值 |
|---|---|
| **作者** | neemem |
| **邮箱** | neemem@gmail.com |
| **微信** | neeeeeemem |

欢迎反馈问题、建议或合作!

---

## 🌸 致用户

**openPRD V5.0 设计哲学**:
- ✅ **Claude Code CLI 优先**(90% 用户)
- ✅ **质量优先**(不动 SKILL.md 本体)
- ✅ **简单优先**(5 分钟上手)
- ✅ **实战验证**(新兰界 39 份文档)

**大多数用户**:
1. 解压 zip
2. 复制到 `~/.claude/skills/`
3. 重启 Claude Code CLI
4. 输入 `/openPRD`
5. 完成!

**祝您使用愉快!** 🌸

**有问题?** 直接在 Claude Code CLI 中问 `/openPRD` 或自然语言描述需求即可。