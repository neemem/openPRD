# Example 01 · 页面级 SaaS CRM 完整方案

> **典型场景**：B2B SaaS CRM 系统的完整产品方案。
> **触发词**："完整的方案" / "页面方案" / "页面清单" / "出页面"
> **产出规模**：20+ 份文档，约 8-12 万字 + 30+ 张 Mermaid 图

---

## 项目背景

- **产品**：智云 CRM（虚构）—— 中小企业销售管理 SaaS
- **目标用户**：10-50 人销售团队的 CRM 管理员、销售经理、销售员
- **核心价值**：线索 → 客户 → 商机 → 合同 → 回款，全流程数字化
- **本次范围**：MVP 1.0 完整功能（6 大模块、35 个页面）
- **开发周期**：12 周（3 个月）

---

## 文档清单（20+ 份）

```
00-document-index.md          文档总目录
01-user-research.md           用户研究（35 题问卷 + 8 场访谈）
02-industry-analysis.md       行业分析（5 路并行：销售易 / 纷享销客 / HubSpot / Salesforce / Zoho）
03-regulation-compliance.md   合规分析（GDPR / 个人信息保护法 / 等保 2.0）
04-tech-trends.md             技术趋势（低代码 / AI 辅助 / 移动优先）
05-architecture.md            系统架构（C4 图 + 技术选型 ADR）
06-prd.md                     PRD 主文档（16 章体系）
06a-prd-scope.md              PRD §3 范围细化
06b-prd-personas.md           PRD §2 用户角色
06c-prd-pages-list.md         页面清单（35 个页面，06h 拆分）
06d-prd-states.md             状态机（线索/客户/商机/合同）
06e-prd-errors.md             错误码总表
06f-prd-permissions.md        权限矩阵（RBAC）
06g-prd-glossary.md           术语表
06h-prd-pages-detail/         页面细节（35 份，每页一份）
07-api-spec.md                API 接口文档
08-db-design.md               数据库设计
09-frontend-guide.md          前端规范
10-figma-make-spec.md         Figma Make 设计稿规范
11-test-cases.md              测试用例
12-task-breakdown.md          任务拆分
13-acceptance.md              验收清单
14-glossary.md                术语表
15-risks.md                   风险登记册
16-adr/                       ADR 决策记录
   0001-frontend-framework.md
   0002-state-management.md
   0003-database-selection.md
17-deployment.md              部署架构
18-monitoring.md              监控告警
```

---

## 关键章节节选（PRD §3 范围）

```markdown
## 3. 范围

### 3.1 P0 核心功能（必须发布）

1. **线索管理** `LeadManagement` —— 线索录入、分配、跟进、转化
2. **客户管理** `CustomerManagement` —— 客户档案、联系人、归属
3. **商机管理** `OpportunityManagement` —— 商机阶段、金额、预测
4. **合同管理** `ContractManagement` —— 合同创建、审批、生效
5. **回款管理** `PaymentCollection` —— 回款计划、记录、提醒
6. **数据看板** `Dashboard` —— 销售漏斗、业绩、转化率

### 3.2 P1 增强功能（V1.1）

- 移动端适配
- 微信集成
- AI 智能线索评分
- 邮件营销自动化

### 3.3 不在本期范围

- 财务记账
- 库存管理
- 客服工单
- HRM
```

**页面清单节选（06c）**：

| 模块 | 页面 | 路径 | P0 |
|---|---|---|---|
| 线索 | 线索列表 | /leads | ✓ |
| 线索 | 线索详情 | /leads/:id | ✓ |
| 线索 | 新建线索 | /leads/new | ✓ |
| 客户 | 客户列表 | /customers | ✓ |
| 客户 | 客户详情 | /customers/:id | ✓ |
| ... | ... | ... | ... |

---

## 关键章节节选（页面细节 06h - 线索详情页）

```markdown
## 线索详情页 LeadDetail

### 页面结构
- 顶部：面包屑 / 标题 / 状态徽章 / 操作按钮组
- Tab 1：基本信息（来源、联系人、需求）
- Tab 2：跟进记录（时间线）
- Tab 3：关联客户/商机
- Tab 4：附件

### 关键交互
- 状态变更：PENDING → CONTACTED → QUALIFIED → CONVERTED
- 转化为客户：弹窗选客户归属人、创建客户档案
- 转化为商机：跳商机新建页，预填线索信息

### 状态机
mermaid stateDiagram-v2
    [*] --> PENDING
    PENDING --> CONTACTED : 首次跟进
    CONTACTED --> QUALIFIED : 判定为合格
    QUALIFIED --> CONVERTED : 转化为客户
    PENDING --> INVALID : 无效线索
    INVALID --> [*]
    CONVERTED --> [*]
```

---

## 经验教训

1. **页面级方案的最大价值**：**统一了"前端 + 设计 + 测试"对产品的理解**，避免 35 个页面各做各的。
2. **06h 拆分原则**：1 页 1 文档，< 200 行；超长则拆"详情页 + 列表页 + 表单页"三件套。
3. **页面清单 (06c) 是"开发排期表"**：把 35 页 × 工时 = 总工时，避免"拍脑袋"立项。
4. **状态机必须画**：35 页有 12 个状态机，缺图则 if-else 嵌套必崩。
5. **权限矩阵 06f 是审计核心**：客户/合同/财务数据必须按角色严格隔离。
6. **错误码总表 06e 必独立**：散落各 PRD 必乱，6 位数字 + 模块位是 openPRD 强约束。
7. **风险与 ADR 并行**：架构决策（前端框架、状态管理、ORM）必须留痕，避免新人重做。

> 页面级方案适合**"从 0 到 1 完整产品"** 或**"产品大版本重构"**。功能迭代用 Example 02 简化版。
