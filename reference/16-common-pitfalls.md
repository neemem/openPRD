# 16 · 跨子技能常见错误（Common Pitfalls Across Sub-Skills）

> 📖 **使用说明**：本文档是 openPRD **跨子技能常见错误**的**统一汇总**。
> 单一子技能内部的避坑指南见各子技能 SKILL.md 的 `## Gotchas`（由 Sub-agent B 维护）；本文档聚焦**跨子技能**易犯的错误。
> 引用方：主 SKILL.md 调研 / 设计 / 开发 / 测试流程；各 subagent 协作时的"跨子技能提醒"。
>
> **Why**：原体系下"常见错误"在各子技能独立维护（user-research / industry-analysis / document-generation / frontend-design / 等），跨子技能协作的错误**没有**集中处。Sub-agent B 在各子技能加 Gotchas 后，本文件提供**跨子技能视角**的提醒，避免"在 A 子技能中避免的错误，在 B 子技能中又踩"。

---

## 0. 文档目的

- **跨子技能避坑**：当一个工作流涉及 ≥ 2 个 subagent 协作时，避免"反复踩同一坑"
- **分类聚合**：按错误类型（通用 / 调研 / 文档产出 / 外部能力）聚合
- **与本地 Gotchas 的关系**：本地 Gotchas（子技能内部）→ 单点修复；本文档（跨子技能）→ 系统性预防
- **每条 ≥ 4 子项**：症状 / 原因 / 修正 / 参考（与子技能 Gotchas 格式一致）

---

## 1. 通用类（适用于多个子技能）

### CP-01: 用户语言 vs 业务语言混用
- **症状**：用户说"我想做 XX"被直接当作用户需求写进 PRD，结果开发做了 3 周后用户说"我要的不是这个"
- **原因**：未追问"为什么需要 XX"和"在什么场景下使用"，把"解决方案"当成了"问题"
- **修正**：用 5 Why / JTBD 框架追问，把"用户原话"翻译为"用户要解决的根本问题"再写进 PRD
- **参考**：openPRD-user-research G-02；06b Persona 与 JTBD 章节

### CP-02: 数据来源缺失（看起来严谨的数字无引用）
- **症状**：PRD 写"70% 用户希望 XX"，但无来源；竞品分析写"市场规模 100 亿"，但无数据出处
- **原因**：agent 编造"看起来合理"的数字，未做实际查询；或引用了但未保留链接
- **修正**：所有数字必须含来源标注（`[来源: 报告名 / URL / 用户编号]`）；无法验证的删除
- **参考**：reference/07-anti-patterns §1 占位符过多；各调研类子技能 Gotchas

### CP-03: 章节完整 ≠ 内容完整（空壳文档）
- **症状**：文档有 5 级标题，每节 1 行概述，看起来"完整"，但开发无信息可执行
- **原因**：模板填空式产出，未理解每章节的"价值定位"；agent 把"目录存在"等同于"内容完成"
- **修正**：每节至少 50 字 + 1 个表格/代码块/示例；评审时拒绝"空壳文档"过审
- **参考**：reference/07-anti-patterns §3；reference/13 §1.1 通用必含项

### CP-04: 跨文档字段拼写不一致（5 字段雷区）
- **症状**：userId / user_id / uid 在 4 处文档混用；status 状态值大小写不一致
- **原因**：复制粘贴 + 局部改名；多 subagent 各自产出未对齐
- **修正**：建立 fields-master.json；跑 `check-consistency.js`；主 Agent 协调统一
- **参考**：reference/15-five-field-crosscheck.md（单一来源）

### CP-05: 加粗泛滥 / 无加粗（视觉层次缺失）
- **症状**：所有文字都加粗（无视觉重点），或关键决策无加粗（评审时被反复问）
- **原因**：未定义"什么必须加粗"；或 agent 默认全加粗
- **修正**：仅加粗 3 类：决策 / 约束 / 风险；P0 功能名 / 必填字段 / 错误码必须加粗
- **参考**：reference/07-anti-patterns §5

### CP-06: 触发词识别错误（页面级 vs 功能级混淆）
- **症状**：用户问"页面方案"但 agent 给了功能级 6 章 PRD；或反之
- **原因**：未正确识别"页面 / 页面级 / 出页面 / 页面清单"等触发词
- **修正**：明确触发词清单（含"页面" → 16 章 50KB 模式；否则 6 章 15KB 模式）
- **参考**：主 SKILL.md 页面级方案强制要求章节；reference/14-mode-tag-table.md

### CP-07: Mock 数据与真实业务脱节
- **症状**：文档示例 `userId: "123"`，真实业务用 UUID v4 36 字符；金额 `100`，真实业务含小数 `100.00`
- **原因**：agent 偷懒用简单值，未与真实业务 1:1
- **修正**：Mock 数据必须与真实业务 1:1（长度、类型、格式、边界值）；边界值覆盖空/极小/极大/特殊字符
- **参考**：reference/07-anti-patterns §6

### CP-08: PRD 文档量虚标（声称 50KB 实际 15KB）
- **症状**：页面级方案要求 ≥ 50KB，但 PRD 实际 15KB（只填了模板空白）
- **原因**：未真正展开 16 章内容；模板填空式产出
- **修正**：每章至少含 1 个 Mermaid 图 + 1 个表格 + 5 个章节段落；用 `wc -c` 验证
- **参考**：主 SKILL.md 页面级方案自检清单；reference/13 §3.1 完整性

### CP-09: 时序图与状态机缺失（多角色 / 多状态业务无图）
- **症状**：订单/审批/支付等多角色业务无 Mermaid 图，文字描述 5 段仍说不清流程
- **原因**：agent 偷懒不画图；模板虽有要求但未强制
- **修正**：涉及 ≥ 2 角色 / ≥ 3 状态 / ≥ 1 决策点 → 必须配 Mermaid 图
- **参考**：reference/07-anti-patterns §4；reference/08-mermaid-syntax.md

### CP-10: 任务粒度过粗（不可拆分不可分配）
- **症状**：任务"实现用户管理"（5 天），不可拆分，进度黑盒
- **原因**：未按"输入/输出/工时/依赖/Owner"五字段拆分
- **修正**：每个任务 ≤ 2 人天，含验收标准；任务可独立 PR
- **参考**：reference/07-anti-patterns §11

### CP-11: 价值声明重复（每文档独立写"价值定位"）
- **症状**：每份文档头部都写"本文档回答 X、不回答 Y"长段，30 份文档 = 30 段重复
- **原因**：模板公共头未引用单一来源
- **修正**：价值声明集中在 `reference/12-value-matrix.md`，文档头部只引用
- **参考**：Sub-agent A reference/12；reference/13 §1 模板级自检

### CP-12: 性能指标无量化（"性能好"而非"P95 ≤ 500ms"）
- **症状**：PRD 写"性能好"、"响应快"，无具体数字
- **原因**：未用 SMART 原则；agent 默认占位符
- **修正**：性能指标量化（P95 / P99 / QPS / 并发数）；每条性能断言可被测试验证
- **参考**：reference/07-anti-patterns §13-14

---

## 2. 调研类（user-research / industry-analysis / competitor-analysis / deep-research / regulation / tech-trends）

### CP-13: 把"我想做 XX"当作用户需求
- **症状**：35 题调研中，所有"需求"都来自用户原话，未追问"为什么"
- **原因**：用户原话是"解决方案"，不是"问题"
- **修正**：用 5 Why 追问；区分 Problem vs Solution；用 JTBD 框架重写需求
- **参考**：openPRD-user-research G-01；06b §3.4 JTBD 章节

### CP-14: 竞品"AI 能力"声明 90% 是接了 GPT API
- **症状**：竞品分析写"XX 具备 AI 能力"，但实际只接了 GPT/Claude API，无自研
- **原因**：仅看官网营销页，未查 JD / 技术博客 / 论文
- **修正**：核验 3 维度——官网 + JD + 技术博客/论文；标注"接入第三方" vs "自研"
- **参考**：openPRD-competitor-analysis G-03；14-竞品分析 Battle Card

### CP-15: 行业分析"市场规模"数据来源过时（> 2 年）
- **症状**：14-行业分析报告引用 2022 年数据，未标注时效性
- **原因**：agent 未对来源做时效性筛选
- **修正**：≥ 60% 来源在 12 个月内；时效性差的数据明确标注"参考价值有限"
- **参考**：openPRD-industry-analysis G-02；reference/05 §3.1 综合置信度

### CP-16: 合规清单漏掉"等保 2.0"或"个保法"
- **症状**：合规清单仅列行业法规，漏掉通用法规（等保 / 个保法 / 广告法）
- **原因**：未做"通用 + 行业 + 跨境 + 等保"5 类齐全检查
- **修正**：合规清单模板强制 5 类齐全检查清单（≥ 30 项）
- **参考**：openPRD-regulation-compliance G-01；14-合规清单模板 §0.6 必含项

### CP-17: 标杆研究只有"它做了什么"，没有"为什么这么做"
- **症状**：14-标杆研究列出 5 个产品的功能清单，但未分析"为什么这样设计"
- **原因**：agent 只复制产品介绍页，未做归因分析
- **修正**：每条标杆做法配"业务背景 + 决策原因 + 适用条件"3 字段
- **参考**：openPRD-deep-research G-02；14-标杆研究 §5 归因分析

### CP-18: 技术趋势分析变成"百科词条"
- **症状**：14-技术趋势报告罗列 7 个领域的技术名词，但未给"本项目选型建议"
- **原因**：未聚焦"本项目"上下文；agent 默认"通用科普"
- **修正**：每个技术领域必须有"对本项目的建议：选 / 不选 / 待评估"3 字段
- **参考**：openPRD-tech-trends G-01；14-技术趋势模板 §7 选型建议

### CP-19: 用户画像 Persona 无设备 / 平台偏好
- **症状**：Persona 写了"姓名、年龄、职业"，但缺"用什么设备、用什么浏览器、什么网络"
- **原因**：模板未强制；agent 用默认模板填空
- **修正**：Persona 至少含 10 维度（含设备 / 平台 / 网络 / 浏览器 / 操作系统）
- **参考**：06b §3.2 Persona；reference/13 §1.2 文档族专项

---

## 3. 文档产出类（document-generation / frontend-design）

### CP-20: 06-PRD 拆 8 段时 06d 组件库章节超长失控
- **症状**：06d 一份模板 100KB+，其他 7 段各 10KB，比例严重失衡
- **原因**：组件库章节未按"基础 / 复合 / 业务"3 类组织，全部平铺
- **修正**：06d 拆 3 子文件（基础组件 / 复合组件 / 业务组件）；按页面分组而非全平铺
- **参考**：openPRD-document-generation G-01；06d 模板 §7 组件库

### CP-21: 06a-06h 各段段契约不一致（输入输出对不上）
- **症状**：06b 输出"US 列表"，但 06d 输入字段是"用户故事列表"，格式不匹配
- **原因**：未定义"段间契约"，各段独立产出未对齐
- **修正**：每段头部加"段契约块"（输入 / 输出 / 编号规则 / 优先级）
- **参考**：06a-06h 各段开头"段契约"章节；reference/13 §1.2 文档族

### CP-22: FigmaMake 提示词写得太"工程师化"（缺少设计语言）
- **症状**：FigmaMake 提示词含大量代码细节（`gap: 16px`），但缺颜色 / 字体 / 间距规范
- **原因**：agent 默认走代码生成路径，忽略"设计还原"的核心
- **修正**：FigmaMake 提示词必须含"设计 token"（颜色 / 字体 / 间距 / 圆角 / 阴影 / 动效 6 项）
- **参考**：FigmaMake-Prompt.md 模板；openPRD-frontend-design G-02

### CP-23: 前端组件库未引用设计系统（与 Figma 脱节）
- **症状**：04-前端开发指南写了组件用法，但未引用 FigmaMake-Prompt 的设计 token
- **原因**：04 和 FigmaMake 独立产出，未交叉引用
- **修正**：04 在"组件用法"段落引用 FigmaMake 颜色 / 字体变量；与 06d 组件库 1:1 对应
- **参考**：04-前端开发指南 §组件；06d 组件库

### CP-24: Mock 数据字段与接口契约不对齐
- **症状**：03-接口文档定义 `userId: string`，但 11-Mock 数据文档写 `userId: number`
- **原因**：subagent 各自产出，未对齐字段类型
- **修正**：11-Mock 引用 03-接口文档的字段类型表；主 Agent 在 G3 检查 5 字段
- **参考**：reference/15-five-field-crosscheck.md；03-接口文档 vs 11-Mock

### CP-25: 任务拆分与 PRD US 对不上
- **症状**：05-任务拆分的 P0 任务与 06-PRD 的 P0 US 数量 / 名称不一致
- **原因**：05 和 06 独立产出，未交叉引用
- **修正**：05 在 §1 P0 任务列表显式引用 06 §3 P0 US；3 处文档 grep 集合一致
- **参考**：reference/15 §2.5 P0 功能名验证；05 任务拆分 §1

### CP-26: 错误码总表散落各 PRD（无独立文档）
- **症状**：03-接口、06-PRD §6、09-后端各自列出错误码，但无统一总表
- **原因**：未建立"错误码总表"（error-codes.md）
- **修正**：建立独立 error-codes.md；所有文档引用该总表；6 位数字 AABBCC
- **参考**：reference/15 §1 错误码；reference/07 §9

---

## 4. 外部能力类（context7 / minimax / chrome-devtools）

### CP-27: context7 库不存在时 fallback 到 WebSearch 但版本不对应
- **症状**：用 context7 查 React 文档未找到，fallback WebSearch 拿到 React 18 文档，但项目用 React 19
- **原因**：WebSearch 排序靠前的是"通用"内容，未必匹配项目版本
- **修正**：fallback 时必须显式带版本号搜索（如 `React 19 hooks`）；如仍不确定，标注"需人工确认"
- **参考**：openPRD-context7-integration G-01；reference/01 库版本检查

### CP-28: minimax text_to_image 在"具体人物"提示词下表现差
- **症状**：提示词"画一个亚洲女性 CEO，30 岁，戴眼镜"生成图片怪异（人脸变形）
- **原因**：minimax 模型对具体人物提示词表现不稳定
- **修正**：先用 generic 描述（"一位商务女性形象，职业装"），后续用具体化迭代
- **参考**：openPRD-minimax-integration G-02

### CP-29: chrome-devtools take_snapshot 在 SPA 异步加载时只拿到初始状态
- **症状**：对 React SPA 抓 snapshot，页面元素未渲染（拿到的是 loading 骨架）
- **原因**：未等异步加载完成
- **修正**：先 `wait_for` 关键文本出现，再 `take_snapshot`；或在 initScript 中等待
- **参考**：openPRD-chrome-devtools-integration G-01

### CP-30: chrome-devtools Lighthouse 审计结果不导出
- **症状**：跑了 Lighthouse 拿到分数，但未保存报告文件（无法追溯）
- **原因**：未指定 `outputDirPath`
- **修正**：每次跑 Lighthouse 都指定 `outputDirPath`，报告归档到 `*-docs/lighthouse/`
- **参考**：openPRD-chrome-devtools-integration G-02

### CP-31: minimax 语音合成语速 / 音调与场景不匹配
- **症状**：用默认语速生成会议通知语音，听起来"催促"感强
- **原因**：未针对场景调参
- **修正**：根据场景调 `speed` / `pitch`（会议通知 0.9-1.0 / 警报 1.1-1.2）；用 emotion 参数
- **参考**：openPRD-minimax-integration G-03

### CP-32: context7 拿到的库 API 与项目实际版本不一致
- **症状**：用 context7 查 Prisma 文档，示例代码用 `prisma.user.findMany()`，但项目用的 Prisma 版本不支持
- **原因**：未在调用时指定库版本
- **修正**：调用 context7 时传版本号（`/prisma/docs/v5.x`）；拿到代码示例后人工对照项目版本
- **参考**：openPRD-context7-integration G-02

### CP-33: chrome-devtools 网络抓取被 CSP / robots.txt 拦截
- **症状**：抓取某竞品官网被 403
- **原因**：网站有 robots.txt 或 CSP 限制
- **修正**：先 `fetch` 看 robots.txt；公开数据用 WebSearch / WebFetch；不抓取登录后内容
- **参考**：openPRD-chrome-devtools-integration G-03

---

## 4.5. 架构脑图类（architecture-mindmap，v4.4 新增）

> 📌 **本节新增于 v4.4.0**。架构脑图子技能的 10 条本地 Gotchas 见 [`openPRD-architecture-mindmap/SKILL.md §Gotchas`](../openPRD-architecture-mindmap/SKILL.md),本节聚焦**跨子技能协作**时的常见错误(如与 PRD/架构/数据看板的衔接)。

### CP-39: 业务脑图与产品脑图"看起来一样"——维度错位
- **症状**:2 张脑图 L2-L5 内容几乎一致,只是 L1 标题不同
- **原因**:agent 偷懒——直接把 PRD §4 功能清单复制 2 份,未做"业务维度 vs 产品维度"建模
- **修正**:业务脑图按"业务域→能力→流程→对象"4 维组织,产品脑图按"模块→功能→页面→接口"4 维组织;两者**L2 必须 1:1 对应业务域**但呈现视角不同
- **参考**:`openPRD-architecture-mindmap/SKILL.md` G-05

### CP-40: 脑图节点名在 06/13/12/03 不一致——跨文档字段错位
- **症状**:脑图写"用户中心",PRD §3 写"用户模块",DB 写"user_center",4 处不一致
- **原因**:脑图独立生成,未与既有文档做 5 字段交叉
- **修正**:架构脑图子技能 Step AM5 强制 5 字段交叉对比;同时**反向**——PRD/架构变更后,脑图必须重生成(避免"两份文档 3 个月后口径不一致")
- **参考**:`reference/15-five-field-crosscheck.md` + `openPRD-architecture-mindmap/SKILL.md` G-03

### CP-41: 脑图作为单独资产归档,与 PRD/架构不联动
- **症状**:PRD/架构更新后,脑图未同步,3 个月后两份文档口径不一致
- **原因**:脑图是"一次性产出"资产,没有"更新触发器"
- **修正**:在 06-PRD §0 嵌入 Mermaid 块(用 in-place 嵌入,不是只放独立文件);在 13-架构 §0 加 .xmind 下载链接;每次大版本变更,脑图重生成;文件名带版本号(`-v2.xmind`)
- **参考**:`openPRD-architecture-mindmap/SKILL.md` G-09

### CP-42: 业务脑图误把"组织架构"当"业务架构"
- **症状**:业务脑图 L2 列"销售部/市场部/产品部"(部门)
- **原因**:agent 误把"业务架构"理解为"组织架构"
- **修正**:业务架构 = 业务域(业务能力的自然聚合),不是组织部门;判断标准:换组织架构,业务域不变
- **参考**:`openPRD-architecture-mindmap/SKILL.md` G-10

### CP-43: 架构脑图与数据看板的设计原则混淆
- **症状**:在架构脑图里出现 KPI 卡片、3-30-300 层级标注——把数据看板的设计语言搬到架构脑图
- **原因**:agent 误以为"可视化 = 数据看板"
- **修正**:架构脑图遵循"深度 4-5 层 + 兄弟 3-7 个"原则(Miller's Law);数据看板遵循"3-30-300 + 总-分-总"原则(7 条原则);两者**正交**,不可混用
- **参考**:`openPRD-data-dashboard/SKILL.md` 7 条原则 + `openPRD-architecture-mindmap/SKILL.md` ⭐ 决策 1/2

---

## 5. 反模式（系统性问题）

### CP-34: 一次性产出 16 份文档（无分阶段）
- **症状**：agent 试图在一次回复中产出所有 16 份文档，质量急剧下降
- **原因**：未理解"5 Track 并行 + 阶段门控"
- **修正**：按 Track 分批：A 调研（2 份）/ B 设计（4-9 份）/ C 开发（7 份）/ D 测试（1 份）/ E 管理（2 份），每批跑 G1/G2 门控
- **参考**：openPRD-document-generation G-03；主 SKILL.md 调度章节

### CP-35: 跨子技能协作时未声明上游依赖
- **症状**：document-generation 等 user-research 完成才启动，但两个 subagent 同时启动
- **原因**：未理解依赖图（research → design → dev → test → mgmt）
- **修正**：明确声明"本 subagent 的输入契约 / 输出契约"；上游未完成不启动
- **参考**：openPRD-document-generation G-04；主 SKILL.md §2 调度

### CP-36: 模式选择错误（应完整但选了简化）
- **症状**：用户说"我们要做全栈 CRM"，但 agent 选了简化模式（无数据库设计）
- **原因**：未仔细读用户的"后端 / 前端"选择
- **修正**：Step 0 阶段必须先确认模式（"后端同时实现" vs "只考虑前端"），再启动流程
- **参考**：主 SKILL.md Step 0；reference/14-mode-tag-table.md

### CP-37: 行业研究 5 路并行但输出未整合
- **症状**：行业 / 竞品 / 标杆 / 合规 / 技术 5 路各自产出 1 份报告，但主 Agent 未做"综合洞察"
- **原因**：未理解 5 路的"1+5"关系（1 份综合洞察 + 5 份独立报告）
- **修正**：5 路全部完成后必须出"综合洞察"（共识 + 冲突 + 解决）
- **参考**：主 SKILL.md §2.2 五路并行；reference/05 §3.1 综合置信度

### CP-38: 子技能 Gotchas 跨文件未交叉引用
- **症状**：user-research 写"不要把'我想做 XX'当需求"，但 document-generation 未引用
- **原因**：各子技能 Gotchas 独立维护，无跨文件引用
- **修正**：当一个 Gotcha 涉及"协作上游"时，引用上游子技能 Gotchas；本文档是跨技能视角的补充
- **参考**：各子技能 SKILL.md `## Gotchas`；本文档为跨技能补充

---

## 6. 修复流程（发现 Pitfall 后）

```
1. 定位：先看本文档，按"症状"匹配分类
2. 修复：按"修正"字段操作（修改文档 / 重跑脚本 / 调参数）
3. 验证：跑 reference/13 的对应自检（§1 模板级 / §2 阶段级 / §3 全局级）
4. 跨技能通报：若涉及 ≥ 2 个子技能，在主 Agent 报告里注明"跨子技能修复"
5. 沉淀：若本 Pitfall 未在本文档，补一条 CP-NN（编号递增）
```

---

## 7. 与其他文档的关系

| 文档 | 关系 |
|------|------|
| 各子技能 SKILL.md `## Gotchas` | **本地视角**：单子技能内部避坑（编号 G-NN） |
| `reference/07-anti-patterns.md` | **通用 PRD 视角**：22 条反模式（含特征 / 后果 / 修复） |
| 本文档 | **跨子技能视角**：38 条 pitfalls（症状 / 原因 / 修正 / 参考），按"通用 / 调研 / 文档产出 / 外部能力 / 系统性"5 类聚合 |
| `reference/13-quality-selfcheck.md` | 自检规则（命中本文档 Pitfall → 自检不通过） |
| `reference/15-five-field-crosscheck.md` | 5 字段专项（CP-04 详见此文件） |

> **三者关系**：子技能 Gotchas（局部）→ 反模式（通用）→ 跨子技能 Pitfalls（系统）。

---

## 附录：相关参考

- 各 subagent `openPRD-*/SKILL.md` 的 `## Gotchas` 区
- `reference/07-anti-patterns.md`：22 条通用反模式
- `reference/13-quality-selfcheck.md`：自检规则
- `reference/15-five-field-crosscheck.md`：5 字段交叉对比（CP-04 详解）
- `reference/08-mermaid-syntax.md`：Mermaid 语法（CP-09 详解）
- `reference/01-mock-data.md`：Mock 数据规范（CP-07 详解）

---

*本文档由 Sub-agent D 整合，作为跨子技能避坑指南的统一来源。新增 Pitfall 时追加在对应分类末尾（编号 CP-39, CP-40, ...），不要修改既有条目。*
