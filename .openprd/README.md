# openPRD 项目级配置目录

> `.openprd/` 是 openPRD skill 的**项目级配置与跨次记忆目录**。
> 本目录在 openPRD skill 根目录提供**模板**;用户实际使用时,应将本目录**复制**到目标项目根目录。

## 目录结构

```
.openprd/
├── config.example.json    # 配置文件示例(复制为 config.json 后修改)
├── README.md              # 本文件
└── hooks/                 # 钩子脚本与文档
    ├── README.md
    └── safe-write.sh      # 防止覆盖既有产出的 PreToolUse 脚本
```

## 何时复制到项目根目录

| 场景 | 是否需要复制 | 说明 |
|------|------------|------|
| 一次性需求产出 | ❌ 不必 | 一次性场景无需跨次记忆 |
| 长期维护的产品项目 | ✅ 建议 | 支持"用户偏好沉淀 + 跨次记忆" |
| 多团队协作的复杂项目 | ✅ 强烈建议 | 统一配置入口 |
| 跨多项目复用同一套偏好 | ❌ 不复制,在用户级 `~/.claude/` 配置即可 | — |

## 复制方式

```bash
# 在目标项目根目录
cp -r /Users/neemem/.claude/skills/openPRD/.openprd ./
# 改名 config.example.json 为 config.json
mv .openprd/config.example.json .openprd/config.json
# 按需修改 config.json 中的字段
```

## 关键文件说明

### `config.json` / `config.example.json`

主 Agent 启动 openPRD 时**优先读取**的文件。读取逻辑:

1. 检查项目根目录是否存在 `.openprd/config.json`
2. **存在** → 用其中的 `default_mode`、`user_preferences` 等字段,跳过对应询问
3. **不存在** → 用默认值,并在 Step 0 询问用户

字段含义详见文件内 `_comment` 注释。

### `hooks/safe-write.sh`

PreToolUse hook 脚本,**防止主 Agent 在 `*-docs/` 目录已存在且非空时直接覆盖写入**。详细接入方式见 `hooks/README.md`。

## 跨次记忆(预留)

`config.json` 中的 `history_path` 字段预留了跨次记忆路径(默认 `./.openprd/history/`)。后续版本将支持:

- 自动保存每次产出的 hash / 关键字段
- 后续 openPRD 调用时,若需求相似,自动复用历史决策

当前 v4.0 版本此功能为占位,不实际生成 history 文件。
