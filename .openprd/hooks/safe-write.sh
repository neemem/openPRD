#!/usr/bin/env bash
#
# safe-write.sh - openPRD 安全写入 PreToolUse Hook(示例)
#
# 行为:当 Write 工具的目标路径匹配 *-docs/ 且目录已存在且非空时,打印警告
#       并 exit 2(Claude Code PreToolUse 约定:exit 2 = 拦截,要求二次确认)。
#
# 注意:本脚本是 openPRD 设计的**示例 / 文档化最佳实践**。当前环境(本 skill
# 仓库)内 Claude Code hooks 需用户在 ~/.claude/settings.json 中显式配置后才
# 会真正生效;否则本脚本仅作为 agent 阅读时的"内嵌指令"——即"写文件前手动
# 跑一下这个检查"。
#
# 实际接入方式见 ./hooks/README.md。

set -e

TARGET_PATH="${CLAUDE_TOOL_INPUT_FILE_PATH:-$1}"

if [ -z "$TARGET_PATH" ]; then
  echo "[safe-write] 未提供目标路径,跳过检查" >&2
  exit 0
fi

# 仅对 *-docs/ 目录做检查(避免误伤普通文件)
case "$TARGET_PATH" in
  *-docs/*)
    # 提取 *-docs/ 父目录
    DOCS_DIR=$(echo "$TARGET_PATH" | sed -E 's|(.*-docs/).*|\1|')
    if [ -d "$DOCS_DIR" ] && [ -n "$(ls -A "$DOCS_DIR" 2>/dev/null)" ]; then
      echo "[safe-write] ⚠️  目标目录已存在且非空:$DOCS_DIR" >&2
      echo "[safe-write] 为避免覆盖既有产出物,需要二次确认。" >&2
      echo "[safe-write] 退出码 2 = 阻止本次写入。请确认是否要继续。" >&2
      exit 2
    fi
    ;;
esac

exit 0
