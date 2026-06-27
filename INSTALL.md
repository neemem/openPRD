# openPRD V5.0 · 安装指南

> **支持 3 种安装方式**:URL 安装(推荐) / 本地 zip 包 / Git 仓库
> **支持 3 个 AI 工具平台**:Claude Code CLI(主) / OpenCode / Codex CLI

---

## 🎯 选择你的安装方式

| 方式 | 难度 | 适用场景 | 推荐度 |
|---|---|---|---|
| **A. URL 安装(未来支持)** | ⭐ | 通过 URL 一键安装 | ⭐⭐⭐⭐⭐(一旦支持) |
| **B. 本地 zip 包** | ⭐⭐ | 下载后离线安装 | ⭐⭐⭐⭐⭐(**当前推荐**) |
| **C. Git 仓库** | ⭐⭐ | 已托管在 GitHub | ⭐⭐⭐⭐ |

---

## 方式 A:URL 安装(未来支持,**目前需手动**)

### A.1 标准方式

```bash
# Claude Code CLI(未来)
npx skills add https://github.com/openPRD-team/openPRD-skill

# OpenCode(未来)
opencode install openPRD https://github.com/openPRD-team/openPRD-skill

# Codex CLI(未来)
codex install https://github.com/openPRD-team/openPRD-skill
```

### A.2 通用方式(当前可用)

```bash
# 使用 git URL 克隆
git clone https://github.com/openPRD-team/openPRD-skill.git
# 复制到对应平台目录
cp -r openPRD-skill/ ~/.claude/skills/openPRD/
```

> 💡 **当前阶段**:URL 安装功能依赖平台原生支持,openPRD Skill 通过 `skill.json` 清单文件**预留**了完整元数据,等待平台支持。

---

## 方式 B:本地 zip 包(**当前推荐**)

### B.1 下载并安装(Claude Code CLI)

```bash
# 1. 下载 openPRD-v5.0-skill.zip(本压缩包)
# 2. 解压
cd ~/Downloads
unzip openPRD-v5.0-skill.zip

# 3. 复制到 Claude Code CLI skills 目录
cp -r openPRD/ ~/.claude/skills/

# 4. 验证
ls ~/.claude/skills/openPRD/SKILL.md

# 5. 重启 Claude Code CLI
```

### B.2 多平台分发(可选)

```bash
# 使用本 Skill 的 distribute.sh 生成 3 平台分发
bash ~/.claude/skills/openPRD/distribute.sh all

# 产物:
# ~/Downloads/openPRD-v5.0-claude-code.zip(完整版)
# ~/Downloads/openPRD-v5.0-opencode.zip(OpenCode 单文件版)
# ~/Downloads/openPRD-v5.0-codex.zip(Codex 单文件版)
```

---

## 方式 C:从 Git 仓库

```bash
# 1. 克隆仓库
git clone https://github.com/openPRD-team/openPRD-skill.git

# 2. Claude Code CLI 安装
cp -r openPRD-skill/ ~/.claude/skills/openPRD/

# 3. OpenCode 安装
mkdir -p ~/.config/opencode/skills/
cp -r openPRD-skill/ ~/.config/opencode/skills/openPRD/

# 4. Codex CLI 安装(单文件模式)
mkdir -p ~/.codex/prompts/
# 需要先运行 distribute.sh 生成 openPRD.md
bash openPRD-skill/distribute.sh codex
cp openPRD-v5.0-codex/openPRD.md ~/.codex/prompts/openPRD.md
```

---

## 📊 平台选择建议

| 你是谁? | 推荐平台 | 安装方式 |
|---|---|---|
| 多数用户 | **Claude Code CLI** | 方式 B(zip) |
| 开源爱好者 | OpenCode | 方式 B + distribute.sh |
| 应急使用 | Codex CLI | 方式 B + distribute.sh |
| 喜欢 git | 任意 | 方式 C(git clone) |
| 期待未来 | 任意 | 方式 A(等平台支持) |

---

## ✅ 安装验证

### Claude Code CLI

```bash
ls ~/.claude/skills/openPRD/
# 应看到: SKILL.md README.md reference/ templates/ CHANGELOG/

# 在 Claude Code CLI 中:
> /openPRD
```

### OpenCode

```bash
ls ~/.config/opencode/skills/openPRD/
# 应看到: SKILL.md

# 在 OpenCode 中:
> /openPRD
```

### Codex CLI

```bash
ls ~/.codex/prompts/openPRD.md
# 应是单文件,约 150KB

# 在 Codex CLI 中:
> /openPRD
```

---

## 🔧 高级:URL 部署(项目维护者)

### 步骤 1:创建 Git 仓库

```bash
cd ~/.claude/skills/openPRD/
git init
git add .
git commit -m "openPRD V5.0.0"
gh repo create openPRD-team/openPRD-skill --public
git push -u origin main
```

### 步骤 2:确保 skill.json 完整

```bash
cat skill.json | jq '.'
# 验证 name, version, triggers, installation 字段完整
```

### 步骤 3:打 tag

```bash
git tag v5.0.0
git push origin v5.0.0
```

### 步骤 4:用户可通过 URL 安装

```bash
# Claude Code CLI(未来)
npx skills add https://github.com/openPRD-team/openPRD-skill@v5.0.0

# OpenCode(未来)
opencode install openPRD https://github.com/openPRD-team/openPRD-skill@v5.0.0
```

---

## 🚨 故障排除

### 安装后找不到 Skill?

```bash
# 1. 检查路径
ls ~/.claude/skills/openPRD/SKILL.md

# 2. 检查权限
chmod -R 755 ~/.claude/skills/openPRD/

# 3. 重启 AI 工具
```

### URL 安装失败?

```bash
# 1. 确认网络连接
curl -I https://github.com/openPRD-team/openPRD-skill

# 2. 改用方式 B(zip)
bash distribute.sh claude

# 3. 手动安装
unzip openPRD-v5.0-claude-code.zip
cp -r openPRD/ ~/.claude/skills/
```

### 触发 Skill 无响应?

- 确认 AI 工具版本 ≥ 1.0
- 确认在项目目录中运行
- 重启 AI 工具

---

## 💡 提示

**90% 用户推荐**:
- 安装方式:方式 B(zip 包)
- 平台:Claude Code CLI
- 路径:`~/.claude/skills/openPRD/`
- 触发:`/openPRD`

**多平台用户**:
- 安装方式:方式 C(git clone)
- 平台:Claude Code CLI(主)+ OpenCode(备)
- 触发:分别使用各平台对应命令

**未来展望**:
- URL 安装(`npx skills add`)
- 多 Skill 协同
- 跨平台同步

---

## 📋 总结

| 维度 | 现状 | 未来 |
|---|---|---|
| 安装方式 | zip + git | + npx |
| 支持平台 | Claude Code CLI | + OpenCode + Codex |
| 单文件版本 | 手动生成 | + 自动转换 |
| URL 安装 | 预留(等平台) | ⏳ 等待 |

**openPRD V5.0 已支持 zip + git 安装,URL 安装预留接口!**

---

> **最后更新**:2026-06-27
> **对应 Skill 版本**:V5.0.0
> **完整说明**:参考 `README.md` 和 `CHANGELOG/v5.0-best-practices.md`