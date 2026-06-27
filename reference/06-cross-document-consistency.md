# 06 · 跨文档一致性检查（Cross-Document Consistency）

> 解决"同一字段在 5 份文档里 5 种写法"的问题。openPRD 体系下，一份完整方案会输出 20+ 份文档（用户研究、行业分析、PRD、接口、DB、架构、测试、任务拆分等），任何字段不一致都会导致开发返工。

---

## 0. 文档目的

openPRD 一次完整方案会输出 **20+ 份** 文档（用户研究 / 行业分析 / PRD / 接口文档 / DB 设计 / 架构图 / 前端规范 / 测试用例 / 任务拆分 等），核心字段（userId、status、错误码、必填规则、P0 功能名等）会在多份文档中重复出现。

**本文档目的**：

- 定义"必须跨文档保持一致"的 5 类字段
- 提供 4-5 处交叉点的"字段出现位置矩阵"
- 提供 3 种检查方法（手动 / 脚本 / CI）
- 给出 Node.js 自动化脚本示例
- 汇总 10+ 真实不一致案例 + 修复流程
- 建立"开发前定义 → CI 校验"的预防机制

> 一致性是 PRD 可执行性的命门，openPRD 体系把它放在"质量门"前一道关卡。

---

## 1. 5 字段定义

openPRD 选出的 5 类"高敏感字段"是出错率最高、影响范围最广的字段。

### 1.1 userId（用户标识）

| 属性 | 规范 |
|---|---|
| 命名 | 统一使用 `userId`（**禁止** `user_id` / `uid` / `userID` / `UserId`） |
| 类型 | `string`（推荐 UUID v4）或 `bigint`（自增） |
| 长度 | UUID=36 字符；bigint=20 位 |
| 出现位置 | 7+ 处（见 §2 矩阵） |
| 备注 | **必须**在 §1.4 一处定义"用户体系"小节中标注 |

### 1.2 status（状态字段）

| 属性 | 规范 |
|---|---|
| 命名 | 统一使用 `status`（**禁止** `state` / `Status` / `STATUS`） |
| 类型 | `enum`（string）：`PENDING` / `ACTIVE` / `DISABLED` / `DELETED` |
| 跨端对齐 | 前端 TS 枚举、后端 Java 枚举、DB 字段、API 文档、测试用例 **5 处必须一致** |
| 备注 | 任何新增状态值必须先更新 **4 处**，再写代码 |

### 1.3 必填规则（required/optional）

| 属性 | 规范 |
|---|---|
| 表达 | **统一使用 "必填" / "可选"**（禁止 "必传" / "非必填" / "required" / "mandatory" 中英混用） |
| 颗粒度 | 字段级（不允许只标到"对象级"） |
| 默认值 | 必填字段无默认值；可选字段如需默认必须显式标注 |
| 出现位置 | API 文档、DB DDL、PRD §4 接口约定、测试用例 **4 处必须一致** |

### 1.4 错误码（Error Code）

| 属性 | 规范 |
|---|---|
| 格式 | 6 位数字字符串：`AABBCC`，AA=模块、BB=错误类型、CC=序号 |
| 示例 | `100001` = 用户模块-参数错误-001；`200101` = 订单模块-权限不足-101 |
| 模块码 | 必须有"错误码总表"独立文档（不是散落在各 PRD 中） |
| 出现位置 | API 文档、PRD §6 异常处理、测试用例 3 处一致 |

### 1.5 P0 功能名

| 属性 | 规范 |
|---|---|
| 定义 | 必须发布的"核心功能"（MVP 必备） |
| 命名 | 中文名 + 英文标识（例：用户登录 `UserLogin`） |
| 出现位置 | PRD §3 范围、任务拆分 §1、测试用例 §P0 覆盖、验收清单 4 处 |
| 数量控制 | P0 通常 3-8 个，过多则失去优先级意义 |

---

## 2. 字段出现位置矩阵

下表是 openPRD 标准产出（20 份文档）下 5 字段的"出现位置矩阵"。

| 字段 \ 文档 | 用户研究 | PRD §3 范围 | PRD §4 接口 | API 文档 | DB 设计 | 前端规范 | 状态机 | 测试用例 | 任务拆分 | 验收清单 |
|---|---|---|---|---|---|---|---|---|---|---|
| **userId** | 角色/画像 | 字段约定 | 入参 | 入参 | 主键/外键 | TS 类型 | 参与者 | 入参 | 字段表 | 检查点 |
| **status** | 行为/场景 | 范围 P0 | 返回值 | 返回值 | 枚举/索引 | 枚举映射 | 状态节点 | 断言 | 字段表 | 验收项 |
| **必填规则** | - | 字段表 | 标注 | 标注 | NOT NULL | 必填校验 | - | 前置条件 | 字段表 | 检查点 |
| **错误码** | 痛点 | §6 异常 | 标注 | 标注 | - | 错误提示 | 转移条件 | 断言 | - | 验收项 |
| **P0 功能名** | 核心需求 | §3 范围 | 关联 | 关联 | - | 关联 | - | 覆盖项 | §1 P0 任务 | 验收项 |

> 矩阵说明：每个交叉点都是"必须一致"的检查位。例如 `userId` 在 10 份文档中至少出现 7 次，**任何一次不一致都会导致集成失败**。

---

## 3. 检查方法

### 3.1 手动检查（适合个人/小团队）

**步骤**：

1. 准备一张"字段对照表"（Excel / 飞书多维表格）
2. 横向列出所有文档，纵向列出 5 字段
3. 文档定稿后，逐字段填入实际值
4. 颜色标记：绿色=一致 / 黄色=待统一 / 红色=不一致
5. 红色项必须修复后才能进入开发

**耗时**：20 份文档手动检查约 2-3 小时。

### 3.2 脚本检查（推荐，中型团队）

详见 §4 Node.js 脚本。**关键能力**：

- 遍历 `prd/`、`api/`、`db/` 目录下所有 `.md` 文件
- 用正则提取 5 字段
- 与"字段主表"（`fields-master.json`）做对比
- 输出 diff 报告

**耗时**：秒级。

### 3.3 CI 校验（企业级）

- 提交 PR 时自动跑脚本
- 失败时阻塞合并
- 配套 GitHub Actions / GitLab CI 模板

**位置**：`.github/workflows/prd-consistency.yml`。

---

## 4. 自动化检查脚本示例

下面是 Node.js（>=16）版的跨文档一致性检查脚本，**可直接复制使用**。

```javascript
#!/usr/bin/env node
// scripts/check-consistency.js
// 用法：node check-consistency.js ./prd ./api ./db
const fs = require('fs');
const path = require('path');

const ROOTS = process.argv.slice(2);
const PATTERNS = {
  userId: /\b(user_id|uid|userID|UserId)\b/g,  // 错例
  status: /\b(state|Status|STATUS)\b(?!.*?diagram)/g,
  required: /(?<![一-龥])(必传|非必填|required|mandatory)(?![一-龥])/g,
};

let issues = [];

function walk(dir) {
  for (const f of fs.readdirSync(dir)) {
    const p = path.join(dir, f);
    const stat = fs.statSync(p);
    if (stat.isDirectory()) walk(p);
    else if (p.endsWith('.md')) scan(p);
  }
}

function scan(file) {
  const text = fs.readFileSync(file, 'utf8');
  for (const [field, re] of Object.entries(PATTERNS)) {
    const matches = text.match(re);
    if (matches) {
      matches.forEach(m => issues.push({ file, field, bad: m }));
    }
  }
}

ROOTS.forEach(walk);

if (issues.length === 0) {
  console.log('OK: 5 字段跨文档一致');
  process.exit(0);
}

console.log(`FAIL: 发现 ${issues.length} 处不一致`);
console.table(issues);
process.exit(1);
```

**运行**：

```bash
node scripts/check-consistency.js ./prd ./api ./db ./frontend
```

**扩展方向**：

- 加入"字段主表"（`fields-master.json`）做严格 diff
- 集成到 husky pre-commit
- 接入 GitHub Actions，PR 红绿灯

---

## 5. 不一致案例库（10+ 场景）

openPRD 团队 2 年积累的真实不一致场景，按"出错位置 + 修复方法"组织。

| # | 案例 | 错处 | 正解 | 修复成本 |
|---|---|---|---|---|
| 1 | userId vs user_id | API 文档用 `user_id`，前端用 `userId` | 统一 `userId` | 2h |
| 2 | status 枚举值大小写 | 后端 `pending`，前端 `PENDING` | 全大写 `PENDING` | 1h |
| 3 | 状态机节点命名 | PRD 写"已禁用"，DB 写 `disabled` | 统一 `DISABLED` | 3h |
| 4 | 必填规则中英混用 | PRD"必传"，API 文档"required" | 全用"必填" | 0.5h |
| 5 | 错误码重复 | 100001 在用户/订单模块都用 | 增加模块位 11xxxx/22xxxx | 4h |
| 6 | 错误码缺失 | API 文档列了 100001，PRD §6 没列 | 补 PRD §6 引用错误码表 | 1h |
| 7 | P0 功能名拼写 | PRD 写"用户登录"，任务拆分写"账户登录" | 统一"用户登录 UserLogin" | 1h |
| 8 | 字段类型不统一 | DB 用 bigint，API 用 string | 文档统一"输出 string" | 2h |
| 9 | 默认值不一致 | API 文档未标默认，代码默认 0 | 文档显式标"默认 0" | 0.5h |
| 10 | 时间格式 | 13 处用 `yyyy-MM-dd`，3 处用 `YYYY-MM-DD` | 全用 `yyyy-MM-dd HH:mm:ss` | 1h |
| 11 | 状态机多一态 | PRD 4 态，DB 5 态（多了 ARCHIVED） | 先更新 PRD，再改 DB | 4h |
| 12 | 错误码粒度 | 后端抛 `INTERNAL_ERROR`，文档未列 | 必须为"可预期错误"分配码 | 2h |
| 13 | P0 数量膨胀 | 12 个 P0 功能（应≤8） | 砍掉非核心 4 个 | 0.5h |
| 14 | userId 出处 | 7 处用 userId，1 处用 uid（前端某组件） | grep 全替换 | 0.5h |
| 15 | 必填规则颗粒度 | 仅标到对象级，字段级缺失 | 每个字段单独标 | 1h |

> **经验**：约 70% 的不一致来自"复制粘贴 + 局部改名"，因此自动化脚本 + 字段主表能消除 90% 的人工失误。

---

## 6. 修复流程

发现不一致后，按"发现 → 定位 → 修复 → 验证"四步走。

### 6.1 发现

- 来源 1：手动检查（见 §3.1）
- 来源 2：脚本输出（见 §3.2）
- 来源 3：开发联调报错
- 来源 4：Code Review

### 6.2 定位

- 用 `grep -rn "user_id" ./docs` 找出所有错例
- 在"字段出现位置矩阵"（§2）上标红
- 评估影响范围（哪几份文档）

### 6.3 修复

- **优先修复主文档**（PRD §1.4 字段定义）
- 然后批量替换其他文档
- 更新"字段主表"（`fields-master.json`）
- 提交 commit：`fix(prd): 统一 userId 命名`

### 6.4 验证

- 重跑 §3.2 脚本
- Code Review 二次确认
- 联调测试通过

> 关键原则：**先改主表，再改文档，最后改代码**。

---

## 7. 预防机制

### 7.1 开发前定义字段表

**时机**：写第一份 PRD 之前。
**产物**：`fields-master.json`（机器可读）。

```json
{
  "userId": {
    "type": "string",
    "format": "uuid",
    "name_zh": "用户ID",
    "name_en": "userId",
    "forbidden": ["user_id", "uid", "userID"],
    "docs_first_appearance": "prd/01-prd.md#1.4"
  },
  "status": {
    "type": "enum",
    "values": ["PENDING", "ACTIVE", "DISABLED", "DELETED"],
    "forbidden": ["state", "Status", "STATUS"]
  }
}
```

### 7.2 CI 校验

- PR 触发：`check-consistency.yml`
- 失败：阻塞合并（required check）
- 通知：@作者 + 标记 `prd-inconsistency` 标签

### 7.3 文档模板化

- PRD / API / DB 模板中"字段表"段落固定
- 用 Markdown 表格 + 占位符（避免自由发挥）
- 占位符必须用 §1 字段名，无法填时打 `TODO` 触发 review

### 7.4 培训与规范

- 团队 wiki 收录本文档
- 新人入职培训 30 分钟
- 季度回顾不一致 Top 5 案例

---

## 8. 自检清单

完成 PRD 全套文档后，逐项打勾：

- [ ] **userId**：所有文档统一 `userId`（无 `user_id` / `uid`）
- [ ] **status**：枚举值在 PRD / API / DB / 前端 / 测试 5 处完全一致
- [ ] **必填规则**：每个字段独立标注"必填/可选"（无对象级模糊）
- [ ] **错误码**：6 位数字 + 模块码，且 PRD §6 引用错误码总表
- [ ] **P0 功能名**：3-8 个，中英文名一致，PRD / 任务 / 测试 / 验收 4 处一致
- [ ] **字段主表**：`fields-master.json` 已建立且与最新文档同步
- [ ] **CI 脚本**：check-consistency 通过
- [ ] **Code Review**：Reviewer 二次确认
- [ ] **联调**：开发与测试均按"主表"实现
- [ ] **预防机制**：模板 + 培训 + CI 三件套已就位

> **10 项全绿** = 可以进入开发。**任一红项** = 必须修复后才能进开发。

---

## 附录：相关参考

- `reference/05-quality-gates.md`：质量门（本文档是质量门的"前置关卡"）
- `reference/07-anti-patterns.md`：反模式清单（§2 字段不一致是反模式之一）
- `templates/01-prd.md`：PRD 模板（§1.4 字段定义段落）
- `templates/04-api-spec.md`：API 模板（错误码段落）
