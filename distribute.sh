#!/bin/bash
# openPRD · V5.0 多平台分发器
# 实际生成 Claude Code / OpenCode / Codex CLI 三平台分发包
# 用法:bash distribute.sh [目标平台]
#   all    - 生成 3 个平台分发(默认)
#   claude - 仅 Claude Code
#   opencode - 仅 OpenCode
#   codex  - 仅 Codex CLI
#   inspect - 检查当前平台

set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_BASE="$HOME/Downloads"
TIMESTAMP=$(date +%Y%m%d)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  openPRD · V5.0 多平台分发器${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 检测平台
detect_platform() {
    local os=$(uname -s)
    local arch=$(uname -m)
    echo "  操作系统: $os"
    echo "  架构: $arch"

    # 检测已安装的 AI 工具
    if command -v claude &> /dev/null; then
        echo "  ✅ 检测到 Claude Code CLI"
    fi
    if [ -d "$HOME/.config/opencode" ]; then
        echo "  ✅ 检测到 OpenCode 配置目录"
    fi
    if [ -d "$HOME/.codex" ]; then
        echo "  ✅ 检测到 Codex CLI 配置目录"
    fi
    echo ""
}

# 生成 Claude Code 分发
build_claude_code() {
    echo -e "${GREEN}[1/3] 生成 Claude Code CLI 分发${NC}"
    local out="$OUTPUT_BASE/openPRD-v5.0-claude-code.zip"
    rm -f "$out"
    cd "$(dirname "$SKILL_DIR")"
    zip -r "$out" openPRD/ -x "openPRD/.DS_Store" "openPRD/**/.DS_Store" > /dev/null
    local size=$(ls -lh "$out" | awk '{print $5}')
    echo "    ✅ 已生成: $out ($size)"
    echo "    📂 安装: cp -r openPRD/ ~/.claude/skills/"
    echo ""
}

# 生成 OpenCode 分发(单文件 + frontmatter)
build_opencode() {
    echo -e "${GREEN}[2/3] 生成 OpenCode 分发${NC}"
    local out_dir="$OUTPUT_BASE/openPRD-v5.0-opencode"
    rm -rf "$out_dir"
    mkdir -p "$out_dir/skills/openPRD"

    # OpenCode 用单文件 + frontmatter
    {
        echo "---"
        echo "name: openPRD"
        echo "description: 需求到交付的完整开发文档生成器(35题调研 + 5路并行 + 39份产品文档)"
        echo "version: 5.0"
        echo "author: openPRD Team"
        echo "tags: [product, requirements, documentation, agile]"
        echo "---"
        echo ""
        echo "# openPRD V5.0 - OpenCode 单文件适配版"
        echo ""
        echo "> ⚠️ **OpenCode 适配说明**"
        echo "> - 已合并 reference/ 关键内容到单文件"
        echo "> - 适用于:中型项目(15-50份产品文档)"
        echo "> - 完整 V5.0 内容请使用 Claude Code CLI 版本"
        echo "> - 自动转换脚本: install-cross-platform.sh"
        echo ""

        # 嵌入主 SKILL.md 内容
        cat "$SKILL_DIR/SKILL.md" | \
            sed -e 's/`Agent` 工具/`bash`/`read`/`write`/g' \
                -e 's/Sub Agent/子 Agent(OpenCode 模式:可能降级为主 Agent 串行)/g' \
                -e '/reference\/[0-9][0-9]/d' \
                -e 's|详见 \[reference/.*\](.*\.\(md\))|详见主文档(单文件版本)|g'

        echo ""
        echo "---"
        echo ""
        echo "# 附:简化版 reference 索引"
        echo ""
        echo "如需详细 reference,使用 Claude Code CLI 版本。"
        echo "本单文件版本包含核心流程,适合 OpenCode 简单场景。"
    } > "$out_dir/skills/openPRD/SKILL.md"

    # 同时合并所有 reference 到附录
    {
        echo "# openPRD V5.0 - Reference 汇总(单文件版)"
        echo ""
        for ref in "$SKILL_DIR"/reference/*.md; do
            local name=$(basename "$ref")
            echo ""
            echo "## $name"
            echo ""
            echo "\`\`\`markdown"
            cat "$ref"
            echo ""
            echo "\`\`\`"
        done
    } > "$out_dir/skills/openPRD/reference-full.md"

    # 打包
    cd "$out_dir"
    local zip_out="$out_dir.zip"
    rm -f "$zip_out"
    zip -r "$zip_out" skills/ > /dev/null
    local size=$(ls -lh "$zip_out" | awk '{print $5}')
    echo "    ✅ 已生成: $zip_out ($size)"
    echo "    📂 安装:"
    echo "       mkdir -p ~/.config/opencode/skills/"
    echo "       cp -r skills/openPRD ~/.config/opencode/skills/"
    echo ""
}

# 生成 Codex CLI 分发(单文件 + 可选 README)
build_codex() {
    echo -e "${GREEN}[3/3] 生成 Codex CLI 分发${NC}"
    local out_dir="$OUTPUT_BASE/openPRD-v5.0-codex"
    rm -rf "$out_dir"
    mkdir -p "$out_dir"

    # Codex 用单文件,无子目录
    {
        echo "---"
        echo "name: openPRD"
        echo "description: 需求到交付的完整开发文档生成器(Codex CLI 适配版)"
        echo "version: 5.0"
        echo "---"
        echo ""
        echo "# openPRD V5.0 - Codex CLI 完整单文件版"
        echo ""
        echo "> ⚠️ **Codex CLI 适配说明**"
        echo "> - Codex 不支持子 Agent,自动降级为主 Agent 串行"
        echo "> - 不支持子目录,所有 reference 内容合并到本文件"
        echo "> - 预计总耗时 +140%(相比 Claude Code CLI)"
        echo "> - 建议用于:应急场景或简单项目"
        echo ""

        # 嵌入主 SKILL.md 内容(简化版)
        cat "$SKILL_DIR/SKILL.md" | \
            sed -e 's/`Agent` 工具/`terminal`/`read_file`/`write_file`/g' \
                -e 's/Sub Agent/主 Agent(Codex 模式:串行)/g' \
                -e 's/并行 5 路/串行 1 路/g' \
                -e 's|详见 \[reference/.*\](.*\.\(md\))|详见附录(本文件底部)|g' \
                -e '/### 子 Skill 目录/d'

        echo ""
        echo "============================================"
        echo ""
        echo "# 附:所有 reference 文档合并(单文件)"
        echo ""
        for ref in "$SKILL_DIR"/reference/*.md; do
            local name=$(basename "$ref")
            echo ""
            echo "## $name"
            echo ""
            echo "\`\`\`markdown"
            cat "$ref"
            echo ""
            echo "\`\`\`"
        done
    } > "$out_dir/openPRD.md"

    # 打包
    cd "$out_dir"
    local zip_out="$out_dir.zip"
    rm -f "$zip_out"
    zip -r "$zip_out" openPRD.md > /dev/null
    local size=$(ls -lh "$zip_out" | awk '{print $5}')
    echo "    ✅ 已生成: $zip_out ($size)"
    echo "    📂 安装:"
    echo "       mkdir -p ~/.codex/prompts/"
    echo "       cp openPRD.md ~/.codex/prompts/openPRD.md"
    echo ""
}

# 通用:分发到所有平台
build_all() {
    echo ""
    detect_platform
    echo "🚀 开始生成 3 平台分发包..."
    echo ""
    build_claude_code
    build_opencode
    build_codex
    echo -e "${GREEN}✅ 全部 3 平台分发包已生成!${NC}"
    echo ""
    echo "📦 输出位置: $OUTPUT_BASE/"
    ls -lh "$OUTPUT_BASE"/openPRD-v5.0-*.zip 2>/dev/null
}

# 显示使用帮助
usage() {
    echo "用法: $0 [目标平台]"
    echo ""
    echo "目标平台:"
    echo "  all       - 生成 3 个平台分发(默认)"
    echo "  claude    - 仅 Claude Code CLI"
    echo "  opencode  - 仅 OpenCode"
    echo "  codex     - 仅 Codex CLI"
    echo "  inspect   - 检查当前平台环境"
    echo ""
    echo "示例:"
    echo "  $0 all"
    echo "  $0 codex"
}

# 主流程
case "${1:-all}" in
    all)
        build_all
        ;;
    claude)
        detect_platform
        build_claude_code
        ;;
    opencode)
        detect_platform
        build_opencode
        ;;
    codex)
        detect_platform
        build_codex
        ;;
    inspect)
        detect_platform
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo "未知参数: $1"
        usage
        exit 1
        ;;
esac

echo ""
echo "💡 提示: 大多数用户只需要 Claude Code CLI 版本(完整支持)"
echo "         OpenCode/Codex 是降级方案,用于特定场景"