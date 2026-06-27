# openPRD Hooks 目录

> 本目录是**设计文档**与**示例实现**,不是开箱即用的 hook 接入。

## 文件清单

| 文件 | 用途 | 状态 |
|------|------|------|
| `safe-write.sh` | 防止覆盖既有 `*-docs/` 产出物的安全检查 | 示例脚本(可执行) |

## 实际接入说明

Claude Code 的 PreToolUse hook 需要在用户的 `~/.claude/settings.json` 中显式配置。openPRD 不修改用户全局配置——以下为**复制即用**的参考片段:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/neemem/.claude/skills/openPRD/.openprd/hooks/safe-write.sh"
          }
        ]
      }
    ]
  }
}
```

将上述片段合并到 `~/.claude/settings.json` 后,**所有 Write 工具的调用**都会先经过 `safe-write.sh` 拦截:

- 目标路径不在 `*-docs/` 下 → 放行(exit 0)
- 目标路径在 `*-docs/` 下且目录**不存在或为空** → 放行(exit 0)
- 目标路径在 `*-docs/` 下且目录**已存在且非空** → 拦截(exit 2),并打印警告

## 行为约定

- **exit 0**:允许工具继续
- **exit 2**:Claude Code 阻止工具调用,要求用户确认
- **其他 exit code**:非标准,Claude Code 处理为允许

## 未配置 hook 时的"内嵌指令"

如果用户的 `~/.claude/settings.json` 中未配置本 hook,openPRD 主 SKILL.md 中的**启动检查**章节会要求 agent 在 Write 前**主动**执行 `safe-write.sh` 检查(或肉眼判断目标目录状态)。
