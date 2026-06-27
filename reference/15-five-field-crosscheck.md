# 15 · 5 字段交叉对比单一来源（Five-Field Cross-Check）

> 📖 **使用说明**：本文档是 openPRD **5 个关键字段跨文档一致性检查规则**的**唯一来源**。
> 5 字段：`userId` / `status` / 必填规则 / 错误码 / P0 功能名。
> 引用方：主 SKILL.md G3 门控 / 02-项目整体 / 03-接口 / 06-PRD / 07-测试 / 09-后端 / 11-Mock / 12-数据库 / 汇总报告。
>
> **Why**：原体系下"5 字段交叉对比"在 6+ 处独立维护（主 SKILL.md G3 章节 + 02 + 03 + 06 + 07 + 12 各模板的"自检章节"），规则更新遗漏即出现"漏检 / 重检"。
> 详细字段定义见 `reference/06-cross-document-consistency.md`（本文档聚焦"出现位置 + 验证方法 + 修复路径"）。

---

## 0. 文档目的

- **统一交叉对比规则**：5 字段 × 4 处出现位置 × 验证方法
- **可机械化验证**：每个字段给出 `grep` / 表格检查命令
- **单一修复路径**：发现不一致时按本文档 §3 走"先主表 → 再文档 → 最后代码"流程

---

## 1. 5 字段定义（速查表）

> 完整定义见 `reference/06-cross-document-consistency.md` §1；本节为"执行速查"。

| 字段 | 命名规范 | 类型 | 出现位置数 | 备注 |
|------|----------|------|------------|------|
| **userId** | 统一 `userId`（禁 `user_id` / `uid` / `userID` / `UserId`） | string（UUID v4 推荐） | 4 处 | 7+ 文档中出现 |
| **status** | 统一 `status`（禁 `state` / `Status` / `STATUS`） | enum: PENDING/ACTIVE/DISABLED/DELETED | 4 处 | 跨端 5 处必须一致 |
| **必填规则** | 统一"必填 / 可选"（禁"必传 / 非必填 / required"中英混用）| 字段级（不允许对象级） | 2 处 | 4 处文档标注一致 |
| **错误码** | 6 位数字 AABBCC（AA=模块 / BB=类型 / CC=序号）| string | 3 处 | 必须有"错误码总表" |
| **P0 功能名** | 中文名 + 英文标识（例：用户登录 `UserLogin`）| string | 4 处 | 3-8 个为宜 |

---

## 2. 5 字段 × 出现位置 × 验证方法（主表）

> **核心表格**——所有交叉对比规则汇总于此。其他文档引用时直接链本表，不重复定义。

| 字段 | 出现位置（4 处） | 验证方法 | 修复路径（详见 §3）|
|------|----------------|----------|---------------------|
| **字段名**（如 `userId`）| ① 06-PRD §1.4 字段定义 / ② 03-接口文档 §字段表 / ③ 12-数据库设计 §DDL / ④ 11-Mock 数据文档 §示例 | `grep -E "\b(user_id|uid|userID|UserId)\b" <4个文档>` 期望 0 命中 | ① §3.3 步骤 1-3 |
| **枚举值**（如 `status`）| ① 06-PRD §1.4 字段定义 / ② 03-接口文档 §字段表 / ③ 11-Mock 数据文档 §示例 / ④ 07-测试用例 §断言 | 4 处文档中 `status` 枚举值 grep 集合完全相同 | ② §3.3 步骤 1-3 |
| **必填规则** | ① 06-PRD §4 接口约定 / ② 03-接口文档 §字段表 | 必填字段标注一致：`grep "必填\|可选" <2个文档>` 字段一一对应 | ③ §3.3 步骤 1-3 |
| **错误码** | ① 03-接口文档 §错误码 / ② 09-后端开发指南 §错误处理 / ③ 07-测试用例 §断言 | 错误码表 + 测试断言 grep 集合相同 | ④ §3.3 步骤 4（涉及总表）|
| **P0 功能名** | ① 06-PRD §3 范围 / ② 07-测试用例 §P0 覆盖 / ③ 05-任务拆分 §P0 任务 | 3 处文档 P0 功能名 grep 集合完全相同；数量 3-8 个 | ⑤ §3.3 步骤 1-3 |

### 2.1 字段名详细验证

```bash
# 检查 userId 拼写一致性
for f in 06-产品需求文档.md 03-接口文档.md 12-数据库设计.md 11-Mock数据文档.md; do
  echo "=== $f ==="
  grep -oE "\b(user_id|uid|userID|UserId|userId)\b" "$f" | sort | uniq -c
done
```

期望：4 个文档均**只**出现 `userId`，**0** 个错例。

### 2.2 枚举值详细验证

```bash
# 检查 status 枚举值
for f in 06-产品需求文档.md 03-接口文档.md 11-Mock数据文档.md 07-测试用例.md; do
  echo "=== $f ==="
  grep -oE "status['\"]?\s*[:=]\s*['\"]?(PENDING|ACTIVE|DISABLED|DELETED|pending|active|disabled|deleted|state|Status|STATUS)" "$f" | sort | uniq -c
done
```

期望：4 个文档枚举值集合 = `{PENDING, ACTIVE, DISABLED, DELETED}` 完全一致（大小写一致）。

### 2.3 必填规则详细验证

```bash
# 检查必填规则
for f in 06-产品需求文档.md 03-接口文档.md; do
  echo "=== $f ==="
  grep -cE "(必填|必传|非必填|可选|required|optional|mandatory)" "$f"
done
```

期望：仅出现"必填"和"可选"，**0** 命中"必传/非必填/required/mandatory"。

### 2.4 错误码详细验证

```bash
# 检查错误码（必须是 6 位数字 AABBCC）
grep -oE "\b[0-9]{6}\b" 03-接口文档.md 09-后端开发指南.md 07-测试用例.md | sort | uniq -c
```

期望：错误码在 3 个文档 grep 集合相同，且每个码存在于"错误码总表"。

### 2.5 P0 功能名详细验证

```bash
# 检查 P0 功能名
for f in 06-产品需求文档.md 07-测试用例.md 05-任务拆分与交付.md; do
  echo "=== $f ==="
  grep -E "P0|P0功能" "$f" | head -10
done
```

期望：3 个文档的 P0 功能名完全相同，数量 3-8 个。

---

## 3. 修复流程

### 3.1 发现（5 个入口）

1. **手动检查**：在 G3 阶段主 Agent 逐字段人工 review
2. **脚本检查**：跑 §2.1-§2.5 的 grep 命令
3. **CI 校验**：PR 触发 `check-consistency.yml`（详见 `reference/06-cross-document-consistency.md` §7.2）
4. **开发联调报错**：集成测试失败
5. **Code Review**：Reviewer 在 PR 中标记

### 3.2 定位（4 步）

```
1. 用 §2 的 grep 命令定位不一致处
2. 在文档"5 字段主表"（fields-master.json）上标红
3. 评估影响范围（哪几份文档/几处出现）
4. 区分"主表已统一但文档未同步" vs "主表本身就分歧"
```

### 3.3 修复（按字段类型）

#### 步骤 1-3（适用于字段名 / 枚举值 / 必填规则 / P0 功能名）

```
1. 优先修复主文档（06-PRD §1.4 字段定义）
2. 用 sed/awk 批量替换其他 3 处文档
3. 二次 grep 验证 0 错例
4. 提交 commit：fix(prd): 统一 <字段> 命名
```

#### 步骤 4（错误码专项）

```
1. 在"错误码总表"（error-codes.md）中先定义/更新
2. 修改 03-接口文档 §错误码 + 09-后端开发指南 §错误处理
3. 在 07-测试用例中添加/更新断言
4. 后端代码 + 前端错误处理同步修改
5. 提交 commit：fix(api): 同步错误码
```

### 3.4 验证

```
1. 重跑 §2 的 grep 命令，期望 0 不一致
2. Code Review 二次确认
3. 联调测试通过
4. 更新"5 字段主表"的 changelog
```

> **关键原则**：**先改主表，再改文档，最后改代码**。

---

## 4. 跨字段主表（fields-master.json）

> 推荐在项目根目录建立机器可读的"字段主表"，是 G3 验证的"权威源"。

```json
{
  "userId": {
    "type": "string",
    "format": "uuid",
    "name_zh": "用户ID",
    "name_en": "userId",
    "forbidden": ["user_id", "uid", "userID", "UserId"],
    "docs_first_appearance": "06-产品需求文档.md#1.4"
  },
  "status": {
    "type": "enum",
    "values": ["PENDING", "ACTIVE", "DISABLED", "DELETED"],
    "forbidden": ["state", "Status", "STATUS", "pending", "active"]
  },
  "required_rule": {
    "notation": "必填 / 可选",
    "forbidden": ["必传", "非必填", "required", "optional", "mandatory"],
    "granularity": "字段级（不允许对象级）"
  },
  "error_code": {
    "format": "AABBCC（6 位数字）",
    "module_codes": {
      "10": "用户模块",
      "20": "订单模块"
    },
    "docs_first_appearance": "error-codes.md"
  },
  "p0_features": {
    "min": 3,
    "max": 8,
    "format": "中文名 + 英文标识",
    "example": "用户登录 UserLogin"
  }
}
```

详见 `reference/06-cross-document-consistency.md` §7.1（自动化检查脚本）。

---

## 5. 如何使用本文档

### 场景 A：主 Agent 在 G3 阶段做交叉对比

```
1. 打开本文档 §2 主表
2. 对 5 字段分别跑 §2.1-§2.5 的 grep 命令
3. 不一致项按 §3.3 步骤修复
4. 重跑验证，全部通过后才能向用户汇报
```

### 场景 B：模板编辑时（06-PRD / 03-接口 / 12-DB / 11-Mock）

```
1. 在文档中定义/引用字段时，参考 §1 命名规范
2. 完成后用 §2.1-§2.5 的 grep 自检
3. 不通过则按 §3.3 修复
```

### 场景 C：模板新增字段

```
1. 先在 fields-master.json 中定义（§4）
2. 在 06-PRD §1.4 中首次定义
3. 同步其他 3 处文档
4. 提交"新增字段" commit
```

### 场景 D：CI 配置

```
1. 在 .github/workflows/prd-consistency.yml 引用 §2.1-§2.5 的 grep
2. PR 触发自动检查
3. 失败则阻塞合并
```

---

## 6. 常见误用

| 误用 | 后果 | 修正 |
|------|------|------|
| 在 06-PRD 用 `user_id`、03-接口用 `userId` | 前端反序列化失败 | 统一 `userId` |
| 状态值大小写不一致（`pending` vs `PENDING`） | 枚举转换异常 | 全大写 `PENDING` |
| "必传" 与 "必填" 混用 | 文档可读性差 | 统一"必填" |
| 错误码 100001 在两模块都用 | 排查困难 | 增加模块位（11xxxx 用户 / 22xxxx 订单）|
| P0 功能名中文"用户登录" vs 英文 `UserLogin` vs 任务拆分"账户登录" | 测试/任务/PRD 错位 | 统一"用户登录 UserLogin" |
| P0 数量膨胀到 12 个 | 失去优先级意义 | 砍至 3-8 个 |

---

## 7. 与其他文档的关系

| 文档 | 关系 |
|------|------|
| `reference/06-cross-document-consistency.md` | **定义详细规则**（5 字段详细定义 + 15 个案例 + Node.js 脚本） |
| `reference/05-quality-gates.md` §4.3 | G3 门控的"5 字段"检查项引用本表 |
| `reference/13-quality-selfcheck.md` §3.3 | G3 全局自检的"5 字段"清单引用本表 |
| 主 SKILL.md 870-879 | 主流程的"5 字段交叉对比"章节引用本表 |
| `templates/06-产品需求文档.md` / 03 / 11 / 12 / 07 / 05 | 各模板的"5 字段"段落引用本表 |

---

## 附录：相关参考

- `reference/06-cross-document-consistency.md`：跨文档一致性（详细定义、案例、脚本）
- `reference/05-quality-gates.md` §4.3：G3 5 字段检查
- `reference/13-quality-selfcheck.md` §3.3：G3 自检 5 字段
- `templates/02-项目整体说明.md`：项目整体（应在 §1.4 字段定义章节引用本表）
- `templates/03-接口文档.md`：API 契约（错误码总表应引用本表）
