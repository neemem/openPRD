# minimax 调用示例库

> **目的**：为 openPRD 各子技能提供 minimax 工具的标准化调用模式，按"场景"分类组织。

---

## 1. 通用调用流程

### 1.1 图像生成（text_to_image）

```javascript
mcp__minimax__text_to_image({
  model: "image-01",  // 当前唯一模型
  prompt: "<详细描述，包含风格、构图、色彩、灯光、细节>",
  aspect_ratio: "16:9",  // 1:1, 16:9, 4:3, 3:2, 2:3, 3:4, 9:16, 21:9
  n: 1,  // 1-9
  prompt_optimizer: true,  // 自动优化
  output_directory: "<项目目录>/assets/images/"
})
```

**Prompt 公式**：
```
[SUBJECT], [STYLE], [COMPOSITION], [COLOR PALETTE], [LIGHTING], [DETAILS]
```

### 1.2 图像理解（understand_image）

```javascript
mcp__minimax__understand_image({
  prompt: "<具体要提取的信息>",
  image_source: "<本地路径或 URL>"  // @ 前缀必须去掉
})
```

**支持格式**：JPEG、PNG、WebP
**不支持**：PDF、GIF、PSD、SVG

### 1.3 音频生成（text_to_audio）

```javascript
mcp__minimax__text_to_audio({
  text: "<文本>",
  voice_id: "female-shaonv",  // 默认
  model: "speech-2.6-hd",  // 或 speech-2.6-turbo
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

### 1.4 音乐生成（music_generation）

```javascript
mcp__minimax__music_generation({
  prompt: "<风格、情绪、场景>",  // 10-300 字
  lyrics: "[Intro]\n...\n[Verse]\n...\n[Outro]\n...",  // 10-600 字，支持结构标签
  sample_rate: 32000,
  bitrate: 128000,
  format: "mp3",
  output_directory: "<项目目录>/assets/music/"
})
```

**限制**：当前最长 1 分钟。

### 1.5 视频生成（generate_video）

```javascript
mcp__minimax__generate_video({
  model: "MiniMax-Hailuo-02",  // 最新
  prompt: "<场景描述 + 15 种镜头运动之一>",
  duration: 6,  // 6 或 10 秒
  resolution: "1080P",  // 768P 或 1080P
  output_directory: "<项目目录>/assets/videos/",
  async_mode: true  // 异步
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

### 1.6 声音克隆（voice_clone）

```javascript
mcp__minimax__voice_clone({
  voice_id: "<新声音 ID>",
  file: "<参考音频路径或 URL>",
  text: "<演示文本>",
  is_url: false,
  output_directory: "<项目目录>/assets/audio/"
})
```

### 1.7 声音设计（voice_design）

```javascript
mcp__minimax__voice_design({
  prompt: "<声音描述，如：温柔专业的女性客服，30-40 岁>",
  preview_text: "<预览文本>",
  voice_id: "<可选，新 ID>",
  output_directory: "<项目目录>/assets/audio/"
})
```

---

## 2. 各 openPRD 子技能的典型调用

### 2.1 前端设计（openPRD-frontend-design）

#### 场景 1：生成示例图

```javascript
// 无设计稿时生成占位图
mcp__minimax__text_to_image({
  prompt: "Modern CRM dashboard, dark theme, data visualization cards layout, clean and professional, blue accent color, sidebar navigation",
  aspect_ratio: "16:9",
  n: 1,
  prompt_optimizer: true,
  output_directory: "./assets/images/dashboard-mockup.png"
})
```

#### 场景 2：解读用户截图

```javascript
// 用户上传竞品截图
mcp__minimax__understand_image({
  prompt: "分析此 UI 截图的核心功能、UI 风格、目标用户、布局结构、色彩搭配",
  image_source: "/Users/user/Downloads/competitor-screenshot.png"  // 去掉 @ 前缀
})
```

### 2.2 行业分析（openPRD-industry-analysis）

```javascript
// 生成行业分析报告封面
mcp__minimax__text_to_image({
  prompt: "Industry analysis report cover, business style, modern minimalist, blue and white color scheme, professional",
  aspect_ratio: "16:9",
  output_directory: "./assets/images/industry-cover.png"
})
```

### 2.3 竞品分析（openPRD-competitor-analysis）

```javascript
// 解读抓取的竞品截图
mcp__minimax__understand_image({
  prompt: "Extract: 1) Color palette (hex codes), 2) Typography (font family/size), 3) Component patterns (buttons/cards/forms), 4) Layout grid, 5) Brand identity",
  image_source: "https://competitor.com/screenshot.png"
})
```

### 2.4 用户研究（openPRD-user-research）

```javascript
// 用户上传竞品 App 截图
mcp__minimax__understand_image({
  prompt: "分析此 App 截图：1) 核心功能，2) UI 模式，3) 目标用户，4) 关键交互，5) 视觉风格",
  image_source: "/Users/user/competitor-app.png"
})
```

### 2.5 深度研究（openPRD-deep-research）

```javascript
// 生成产品介绍视频
mcp__minimax__generate_video({
  model: "MiniMax-Hailuo-02",
  prompt: "Modern office, team collaboration, AI data visualization, [Push in]",
  duration: 6,
  resolution: "1080P",
  output_directory: "./assets/videos/intro.mp4",
  async_mode: true
})
```

### 2.6 文档产出（openPRD-document-generation）

```javascript
// 生成语音播报示例（如：客服场景）
mcp__minimax__text_to_audio({
  text: "您的订单已提交成功，预计 2 小时内送达",
  voice_id: "female-shaonv",
  emotion: "happy",
  output_directory: "./assets/audio/"
})
```

---

## 3. Prompt 模板库

### 3.1 图像生成 Prompt 模板

#### 模板 1：CRM 仪表盘
```
Modern CRM dashboard, dark theme, sidebar navigation,
data visualization cards layout, charts and metrics,
clean and professional, blue accent color #1890ff,
modern UI design, SaaS application
```

#### 模板 2：移动端 App
```
Mobile app UI design, modern iOS style, clean typography,
card-based layout, product showcase, e-commerce app,
vibrant gradient background, mockup on iPhone
```

#### 模板 3：营销 Banner
```
E-commerce promotional banner, modern flat design,
smartphone with discount tag, vibrant red and gold color scheme,
clean composition with white space,
professional product photography style
```

#### 模板 4：登录页
```
Login page UI design, modern minimal style, split screen,
hero image on left, form on right, blue primary color,
gradient background, professional SaaS
```

### 3.2 图像理解 Prompt 模板

#### 模板 1：竞品 UI 提取
```
分析此 UI 截图：
1) 主色调（精确 hex 值）
2) 字体（family + size + weight）
3) 间距系统（px 值）
4) 圆角（px 值）
5) 阴影（box-shadow 值）
6) 组件清单（按钮/输入框/卡片等）
7) 布局结构（grid/columns）
8) 品牌风格总结
```

#### 模板 2：设计稿解读
```
描述此设计稿的设计系统：
- 颜色变量
- 字体规范
- 间距规范
- 组件模式
- 交互模式
```

#### 模板 3：截图 OCR
```
提取此截图中所有可见的文字和数字，保留原始格式。
```

### 3.3 音频 Prompt 模板

#### 模板 1：客服欢迎语
```
mcp__minimax__text_to_audio({
  text: "您好，欢迎使用 [产品名]，我是您的智能助手，请问有什么可以帮您？",
  voice_id: "female-shaonv",
  emotion: "happy",
  speed: 1.0
})
```

#### 模板 2：错误提示
```
mcp__minimax__text_to_audio({
  text: "抱歉，操作失败，请稍后重试或联系客服",
  voice_id: "female-shaonv",
  emotion: "sad",
  speed: 0.9
})
```

#### 模板 3：成功提示
```
mcp__minimax__text_to_audio({
  text: "操作成功，您的请求已处理完成",
  voice_id: "male-qn-jingying",
  emotion: "happy"
})
```

---

## 4. 错误处理

### 4.1 API Key 失效

```javascript
try {
  const result = await mcp__minimax__text_to_image({ ... });
} catch (error) {
  if (error.message.includes("2049") || error.message.includes("invalid api key")) {
    console.warn("minimax API Key 失效，跳过图像生成，使用文字描述代替");
    // 降级：用 Mermaid 流程图 + 文字描述
    return { fallback: "text_description" };
  } else {
    throw error;
  }
}
```

### 4.2 降级策略表

| 失败 | 降级方案 |
|------|----------|
| text_to_image 失败 | 用 Mermaid 流程图 + 文字描述 |
| understand_image 失败 | 让用户口述图片内容 |
| text_to_audio 失败 | 用文字描述 + 标点符号模拟 |
| generate_video 失败 | 跳过视频，标注"待生成" |
| voice_clone 失败 | 用现成 voice_id |
| voice_design 失败 | 用 list_voices 选一个最接近的 |

---

## 5. 成本意识

| 工具 | 成本量级 | 建议 |
|------|----------|------|
| text_to_image | 中 | 必要场景用 |
| understand_image | 中 | 解读用户/竞品截图时用 |
| text_to_audio | 低 | 客服/播报示例用 |
| music_generation | 中 | 品牌音/宣传用 |
| generate_video | 高 | 重要场景用 |
| voice_clone | 高 | 品牌专属场景用 |
| voice_design | 中 | 智能助手场景用 |

**调用原则**：
- 每次调用都要有明确目的
- 优先用用户提供的素材
- 生成结果标注"AI 示例"
- 不调用相同 query 多次

---

## 6. 资产保存规范

```
<项目目录>/
├── assets/
│   ├── images/        # text_to_image 输出
│   │   ├── mockup-dashboard.png
│   │   └── mockup-mobile.png
│   ├── screenshots/   # 用户/竞品截图
│   ├── audio/         # text_to_audio 输出
│   │   ├── voice-customer-happy.mp3
│   │   └── voice-system-error.mp3
│   ├── music/         # music_generation 输出
│   ├── videos/        # generate_video 输出
│   └── voice-clones/  # voice_clone 输出
```

---

**文档完成。** 版本：v1.0
