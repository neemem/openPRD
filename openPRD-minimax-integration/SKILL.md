---
name: openPRD-minimax-integration
description: Use when any openPRD subagent needs AI-generated images, image understanding, or audio generation. Triggers on "生成图", "出图", "理解图片", "看截图", "读 OCR", "语音", "配音", "示例图", "竞品截图理解", "minimax". Wraps the minimax MCP server (text_to_image, understand_image, text_to_audio, music_generation, etc.) into reusable call patterns for openPRD subagents. **所有需要视觉化产出、图像理解、音频内容生成的场景调用本 skill。**
---

# openPRD - minimax 能力集成

## 概述

**目的**：把 **minimax MCP**（图像生成、图像理解、音频生成、视频生成）封装为 openPRD 内部可调用的 subagent，**让所有子技能在需要视觉化/听觉化产出时调用 AI 能力**。

**重要性**：
- 纯文本 PRD 难以表达视觉/听觉需求
- 用户提供截图时需要理解能力
- 无设计稿时需要生成示例图
- 用户访谈/客服场景需要语音播报

**协作位置**：被 frontend-design、user-research、industry-analysis、document-generation、deep-research 等 subagent 调用。

---

## 工具映射

| 工具 | 用途 | 典型场景 |
|------|------|----------|
| `mcp__minimax__text_to_image` | 文生图 | 无设计稿时生成示例图 |
| `mcp__minimax__understand_image` | 图生文（理解）| 理解用户截图、竞品截图 |
| `mcp__minimax__text_to_audio` | 文生音 | 语音播报、客服应答示例 |
| `mcp__minimax__music_generation` | 文生音乐 | 产品宣传、品牌音 |
| `mcp__minimax__voice_clone` | 声音克隆 | 品牌专属客服语音 |
| `mcp__minimax__voice_design` | 声音设计 | 智能助手音色 |
| `mcp__minimax__play_audio` | 播放音频 | 验证生成的音频 |
| `mcp__minimax__list_voices` | 列出可用声音 | 选声音时 |
| `mcp__minimax__generate_video` | 文生视频 | 产品介绍视频 |
| `mcp__minimax__query_video_generation` | 查询视频生成任务 | 异步轮询 |

---

## 标准调用模式

### 1. 图像生成（`text_to_image`）

```javascript
mcp__minimax__text_to_image({
  model: "image-01",  // 当前仅此模型
  prompt: "<详细描述，包含风格、构图、色彩>",
  aspect_ratio: "16:9",  // 1:1, 16:9, 4:3, 3:2, 2:3, 3:4, 9:16, 21:9
  n: 1,  // 1-9 张
  prompt_optimizer: true,  // 自动优化 prompt
  output_directory: "<项目目录>/assets/images/"
})
```

**Prompt 模板**：
```
[SUBJECT], [STYLE], [COMPOSITION], [COLOR], [LIGHTING], [DETAILS]

示例（生成营销活动示例图）：
"E-commerce promotional banner, modern flat design, 
showing a smartphone with a discount tag, 
vibrant red and gold color scheme, 
clean composition with white space, 
professional product photography style"
```

### 2. 图像理解（`understand_image`）

```javascript
mcp__minimax__understand_image({
  prompt: "<具体要提取的信息>",
  image_source: "<本地路径或 URL>"
})
```

**使用注意**：
- 本地路径：绝对路径或相对路径
- URL：HTTP/HTTPS
- `@` 前缀必须去掉
- 支持：JPEG、PNG、WebP
- 不支持：PDF、GIF、PSD、SVG

**Prompt 模板**：
- 竞品分析："Extract all visible UI elements, layout structure, color palette, and any text shown in this UI screenshot"
- 设计稿解读："Describe the design system used: colors, typography, spacing, component patterns"
- 流程图理解："Describe the workflow shown in this diagram step by step"
- 截图 OCR："Extract all visible text and numbers from this screenshot"

### 3. 音频生成（`text_to_audio`）

```javascript
mcp__minimax__text_to_audio({
  text: "<要转语音的文本>",
  voice_id: "female-shaonv",  // 默认少女音
  model: "speech-2.6-hd",  // speech-2.6-hd / speech-2.6-turbo
  speed: 1.0,  // 0.5-2.0
  vol: 1.0,  // 0-10
  pitch: 0,  // -12 到 12
  emotion: "neutral",  // happy, sad, angry, fearful, disgusted, surprised, neutral
  sample_rate: 32000,
  bitrate: 128000,
  channel: 1,  // 1=单声道, 2=立体声
  format: "mp3",
  language_boost: "auto",  // auto, en, zh
  output_directory: "<项目目录>/assets/audio/"
})
```

### 4. 音乐生成（`music_generation`）

```javascript
mcp__minimax__music_generation({
  prompt: "Pop music, happy, suitable for product demo video",
  lyrics: "[Intro]\nHello world\n[Verse]\n...",
  sample_rate: 32000,
  bitrate: 128000,
  format: "mp3",
  output_directory: "<项目目录>/assets/music/"
})
```

**限制**：当前最长 1 分钟。

### 5. 视频生成（`generate_video`）

```javascript
mcp__minimax__generate_video({
  model: "MiniMax-Hailuo-02",  // 最新模型
  prompt: "<场景描述 + 15 种镜头运动之一>",
  duration: 6,  // 6 或 10 秒
  resolution: "1080P",  // 768P 或 1080P
  output_directory: "<项目目录>/assets/videos/",
  async_mode: true  // 异步模式
})
```

**15 种镜头运动**：
- Truck: `[Truck left]` / `[Truck right]`
- Pan: `[Pan left]` / `[Pan right]`
- Push/Pull: `[Push in]` / `[Pull out]`
- Pedestal: `[Pedestal up]` / `[Pedestal down]`
- Tilt: `[Tilt up]` / `[Tilt down]`
- Zoom: `[Zoom in]` / `[Zoom out]`
- Shake / Follow / Static: `[Shake]` / `[Tracking shot]` / `[Static shot]`

---

## openPRD 各 subagent 的调用场景

### 场景 1：用户调研时（`openPRD-user-research`）

```
用户上传竞品截图 → 理解图片
调用: understand_image({
  prompt: "分析此竞品 App 的核心功能、UI 风格、目标用户",
  image_source: "<截图路径>"
})
```

### 场景 2：行业研究时（`openPRD-industry-analysis`）

```
无现成图表 → 生成示例图
调用: text_to_image({
  prompt: "行业分析报告封面图，商务风格",
  aspect_ratio: "16:9"
})
```

### 场景 3：前端设计时（`openPRD-frontend-design`）

```
无 Figma 设计稿 → 生成示例图
调用: text_to_image({
  prompt: "现代 CRM 后台仪表盘，深色主题，数据可视化卡片布局",
  aspect_ratio: "16:9"
})
```

### 场景 4：竞品分析时（`openPRD-competitor-analysis`）

```
抓取竞品截图 → 理解 UI 模式
调用: understand_image({
  prompt: "提取此页面的 UI 模式：颜色、字体、组件类型、布局结构",
  image_source: "<竞品截图>"
})
```

### 场景 5：用户体验时（`openPRD-frontend-design`）

```
设计智能客服音色 → 声音设计
调用: voice_design({
  prompt: "温柔专业的女性客服声音，30-40 岁，让人感觉亲切可靠",
  preview_text: "您好，我是您的智能助手，请问有什么可以帮您？"
})
```

### 场景 6：产品宣传时（`openPRD-deep-research`）

```
生成产品介绍视频 → 视频生成
调用: generate_video({
  prompt: "现代办公室场景，团队协作，AI 数据可视化，[Push in]",
  duration: 6,
  resolution: "1080P"
})
```

### 场景 7：测试场景时（`openPRD-document-generation`）

```
语音提示示例 → 音频生成
调用: text_to_audio({
  text: "您的订单已提交成功，预计 2 小时内送达",
  voice_id: "female-shaonv",
  emotion: "happy"
})
```

---

## 使用约束

### ⚠️ 限制

- **minimax API Key 可能失效**（如当前报 2049 错误）→ 失败时回退到纯文本描述
- **生成结果需用户确认** → 不能直接当作"最终产出"
- **成本警告**：所有 minimax 工具都有成本（除非用户明确要求，否则不要主动调用）

### ✅ 最佳实践

- **优先用现有素材**（用户提供的截图、参考图）
- **图片理解优先于生成**（理解更稳定）
- **生成图仅作为"占位示例"**（最终需设计师出图）
- **生成结果保存到 `assets/` 目录**（便于复用）
- **使用 prompt_optimizer=true**（提升生成质量）

### ❌ 避免

- 不要为简单问题生成图（成本高、收益低）
- 不要生成后不向用户确认
- 不要用 AI 生成的图当作"真实数据图"（容易误导）

---

## 错误处理

```javascript
try {
  const result = await mcp__minimax__text_to_image({ ... });
} catch (error) {
  if (error.message.includes("2049")) {
    console.warn("minimax API Key 失效，跳过图像生成，使用文字描述代替");
  } else {
    throw error;
  }
}
```

**降级策略**：
| 失败 | 降级方案 |
|------|----------|
| minimax text_to_image 失败 | 用 Mermaid 流程图 + 文字描述 |
| minimax understand_image 失败 | 让用户口述图片内容 |
| minimax text_to_audio 失败 | 用文字描述 + 标点符号模拟 |
| minimax generate_video 失败 | 跳过视频，标注"待生成" |

---

## 与主 openPRD 的集成

```yaml
# 在主 SKILL.md 中描述
子技能:
  - openPRD-minimax-integration: AI 图像/音频/视频生成（minimax MCP 封装）
```

```yaml
# 在各 subagent 的 SKILL.md "外部能力集成" 章节
外部能力集成:
  - minimax:
      text_to_image: 生成示例图（无设计稿时）
      understand_image: 理解用户截图、竞品截图
      text_to_audio: 语音示例（客服、播报）
      music_generation: 品牌音、宣传音乐
      generate_video: 产品介绍视频
      voice_design: 智能助手音色
```

---

## Gotchas (避坑指南)

### G-01: text_to_image 在"具体人物"提示词下表现差,面部失真
- **症状**: 提示词"30 岁女性销售经理 Bob 在办公桌前",生成的脸部扭曲,5 张 4 张畸形
- **原因**: 主流文生图模型对"具体身份 + 具体场景 + 具体动作"组合,面部/手部容易崩
- **修正**: 2 步策略:(1) **先用 generic 描述**——"职业女性在现代办公空间,商务休闲装,半身照",生成基础图 (2) **后处理添加品牌元素**(PS / 后续工具)或选"风格化"(插画/扁平)避开真人脸。绝不直接出"具体人物营销图"。参考 openPRD-minimax-integration §使用约束。
- **参考**: openPRD-minimax-integration §使用约束 ⚠️ 限制

### G-02: understand_image 对 Figma 截图误读,关键信息丢失
- **症状**: 用户上传 Figma 截图,模型理解"这是一个登录页,有输入框和按钮",漏掉"按钮在右下角 + 间距 16px + 圆角 4px"等细节
- **原因**: understand_image 是"语义理解",不是"像素级 OCR"
- **修正**: **2 步处理 Figma 截图**:(1) understand_image 提"页面结构 + 主功能" (2) 配合 OCR/结构化描述读"具体数值"(颜色 / 间距 / 字号)。绝不依赖单次 understand_image 还原全部设计细节。参考 openPRD-chrome-devtools-integration §实战模板(用 a11y 快照辅助)。
- **参考**: openPRD-chrome-devtools-integration §2 提取页面结构(a11y 快照)

### G-03: 视频生成 duration 6s/10s 不等于实际内容时长 6s/10s
- **症状**: 生成 6 秒视频,但前 1.5s 是渐入 + 0.5s 停顿,实际有效内容只有 4s
- **原因**: 视频生成有"模型缓冲 + 镜头运镜引入",实际"主内容时长" < duration
- **修正**: 必做"预览确认"——生成后用 ffmpeg 抽帧看时间轴,标出"前 N 秒是缓冲"。如果用户要"5 秒介绍",duration 应选 8-10s(预留缓冲)。参考 openPRD-minimax-integration §5 视频生成。
- **参考**: openPRD-minimax-integration §5 视频生成

### G-04: 失败时不降级,直接报错中断主流程
- **症状**: 调 text_to_image,API 返回 2049 错误,主 Agent 抛出异常,后面 8 份文档全没产出
- **原因**: 没 try-catch
- **修正**: 必包 try-catch + 降级。降级表(已在文件 §错误处理):text_to_image 失败 → Mermaid 流程图 + 文字描述;understand_image 失败 → 用户口述;generate_video 失败 → 标"待生成"。绝不能因视觉化失败阻塞主流程。参考 §错误处理 + §降级策略。
- **参考**: openPRD-minimax-integration §错误处理 + §降级策略

### G-05: 用 AI 生成的"营销示例图"当真实数据图(数据来源不可考)
- **症状**: 把 text_to_image 生成的"行业增长率图表"放进 14-行业分析报告,被领导/客户问"数据来源是?",agent 答不出
- **原因**: 视觉化产出混了"数据图"和"示例图"
- **修正**: **2 类产出严格区分**:(1) **示例图**(无数据要求)→ AI 生成,标"AI 示例,非最终" (2) **数据图**(有具体数字)→ 用 Mermaid / Chart.js / ECharts 模板生成,标"数据来源:xxx 报告"。绝不混用。参考 §使用约束 ❌ 避免。
- **参考**: openPRD-minimax-integration §使用约束 ❌ 避免

**跨子技能常见错误汇总**: 见 [reference/16-common-pitfalls.md](./../reference/16-common-pitfalls.md)