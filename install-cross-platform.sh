#!/bin/bash
# openPRD Skill · V5.0 跨平台安装脚本
# 支持 Claude Code CLI / OpenCode / Codex CLI
# 用法:bash install-cross-platform.sh [target]

set -e

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SKILL_NAME="openPRD"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-all}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  openPRD Skill · V5.0 跨平台安装器${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

install_claude_code() {
    echo -e "${GREEN}[1/3] 安装到 Claude Code CLI${NC}"
    local target="$HOME/.claude/skills/$SKILL_NAME"

    mkdir -p "$target"
    cp -r "$SOURCE_DIR"/* "$target/"

    echo "    ✅ 已安装到: $target"
    echo "    📂 SKILL.md: $target/SKILL.md"
    echo "    📂 reference/: 23 个 .md 文件"
    echo "    🔧 触发方式: /openPRD"
}

install_opencode() {
    echo -e "${GREEN}[2/3] 安装到 OpenCode${NC}"
    local target="$HOME/.config/opencode/skills/$SKILL_NAME"

    mkdir -p "$target"

    # OpenCode 使用 frontmatter 格式
    {
        echo "---"
        echo "name: $SKILL_NAME"
        echo "description: 需求到交付的完整开发文档生成器(35题调研 + 5路并行研究 + 39份产品文档)"
        echo "version: 5.0"
        echo "---"
        echo ""
        cat "$SOURCE_DIR/SKILL.md"
    } > "$target/SKILL.md"

    cp -r "$SOURCE_DIR/reference" "$target/"
    cp -r "$SOURCE_DIR/templates" "$target/" 2>/dev/null || true

    echo "    ✅ 已安装到: $target"
    echo "    📂 SKILL.md: $target/SKILL.md (含 frontmatter)"
    echo "    🔧 触发方式: opencode run $SKILL_NAME"
}

install_codex() {
    echo -e "${GREEN}[3/3] 安装到 Codex CLI${NC}"
    local target_dir="$HOME/.codex/prompts"
    local target="$target_dir/${SKILL_NAME}.md"

    mkdir -p "$target_dir"

    # Codex CLI 格式:Markdown + 可选 TOML frontmatter
    {
        echo "---"
        echo "name: $SKILL_NAME"
        echo "description: openPRD V5.0 - 需求到交付的完整开发文档生成器"
        echo "version: 5.0"
        echo "---"
        echo ""
        echo "# openPRD V5.0 - 跨平台 Skill(Codex 适配版)"
        echo ""
        echo "> ⚠️ **Codex CLI 适配说明**:本文件由 SKILL.md 自动转换,去除了 Codex 不支持的子 Agent 调用,改为主 Agent 串行模式。"
        echo ""
        cat "$SOURCE_DIR/SKILL.md" | \
            sed -e 's/Sub Agent/主 Agent(Codex 不支持子 Agent,自动串行)/g' \
                -e 's/`Agent` 工具/`terminal`/`read_file`/`write_file`/g' \
                -e 's/并行 5 路行业研究/串行行业研究(Codex 模式)/g'
    } > "$target"

    echo "    ✅ 已安装到: $target"
    echo "    📂 Prompt: $target"
    echo "    🔧 触发方式: codex prompt run $SKILL_NAME"
}

case "$TARGET" in
    claude|claude-code)
        install_claude_code
        ;;
    opencode)
        install_opencode
        ;;
    codex)
        install_codex
        ;;
    all|"")
        install_claude_code
        echo ""
        install_opencode
        echo ""
        install_codex
        ;;
    *)
        echo "用法: $0 [claude|opencode|codex|all]"
        echo "  claude  - 仅 Claude Code CLI"
        echo "  opencode - 仅 OpenCode"
        echo "  codex   - 仅 Codex CLI"
        echo "  all     - 全部(默认)"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ 安装完成!${NC}"
echo ""
echo "📚 使用方法:"
echo "  Claude Code CLI:  在 Claude Code 中输入 /openPRD"
echo "  OpenCode:        opencode run openPRD"
echo "  Codex CLI:       codex prompt run openPRD"