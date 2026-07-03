# 元歌 · 无间傀儡 王者荣耀专题网站

基于 **Vue 3 + Vite + Element Plus** 技术栈开发的王者荣耀英雄「元歌」主题单页响应式动态网站。融合《诡秘之主》联动元素，深色电竞视觉风格。

## ✨ 功能模块

| 模块 | 功能 |
|------|------|
| 🎨 **皮肤轮播** | 5 张皮肤自动轮播，hover 放大，淡入淡出切换，进度条指示器，缩略图快速切换 |
| 📰 **新闻资料** | 4 大资讯 Tab：版本资讯、出装攻略、玩法技巧、赛事数据（KPL 胜率/顶尖选手排行） |
| 📜 **改动历史** | 2017-2026 年份时间轴分层展示，折叠/展开切换，平滑过渡动画 |
| 🎬 **视频攻略** | B 站嵌入视频 + 本地视频支持，视频列表切换，完整播放控制栏 |
| 🎭 **诡秘主题** | 诡秘之主联动皮肤背景层，紫金渐变配色，水印装饰，滚动淡入动画 |

## 🛠 技术栈

- **前端框架**：Vue 3 (Composition API)
- **构建工具**：Vite 5
- **UI 组件库**：Element Plus
- **样式方案**：SCSS（CSS 变量管理主题）
- **路由**：Vue Router 4（Hash 模式）
- **响应式**：桌面端 / 平板 / 移动端三档适配

## 📦 安装与运行

```bash
# 1. 安装依赖
npm install

# 2. 启动开发服务器（默认端口 5173）
npm run dev

# 3. 构建生产版本
npm run build

# 4. 本地预览构建结果
npm run preview
```

## 📁 项目结构

```
yuange/
├── index.html                    # 入口 HTML
├── package.json                  # 依赖配置
├── vite.config.js                # Vite 构建配置
├── .gitignore                    # Git 忽略规则
├── md/
│   └── history.txt               # 原始改动历史文本
└── src/
    ├── main.js                   # 应用入口
    ├── App.vue                   # 根组件
    ├── R-C.png                   # 皮肤素材：午夜歌剧院
    ├── 云间偶戏.webp             # 皮肤素材：云间偶戏
    ├── 偶像歌剧院.webp           # 皮肤素材：偶像歌剧院
    ├── 无心.webp                 # 皮肤素材：无心
    ├── 诡秘之主.png              # 皮肤素材：诡秘之主联动（兼背景装饰）
    ├── data/
    │   └── history.js            # 格式化的 2017-2026 改动历史数据
    ├── video/
    │   └── biliVideos.js         # B 站嵌入视频数据
    ├── styles/
    │   └── global.scss           # 全局深色电竞主题 + 诡秘风格变量
    ├── views/
    │   └── Home.vue              # 主页（左右 1:1 双栏布局）
    └── components/
        ├── SiteHeader.vue        # 顶部固定导航（滚动毛玻璃）
        ├── SkinCarousel.vue      # 皮肤轮播组件（左栏）
        ├── NewsPanel.vue         # 新闻资料面板组件（右栏）
        ├── HistoryTimeline.vue   # 改动历史时间轴
        ├── VideoPlayerSection.vue# 视频播放区域
        └── SiteFooter.vue        # 页脚
```

## 🖥 响应式断点

| 设备宽度 | 布局表现 |
|---------|---------|
| ≥1201px | 顶部皮肤/资讯左右 **1:1** 双栏等高 |
| ≤1200px | 顶部两栏自动切换为**上下堆叠** |
| ≤768px  | 移动端：间距缩小、缩略图纯图标、标题字号下调 |

## 📦 推送到 GitHub

### 需要推送的文件（本仓库已用 .gitignore 过滤）

```
✅ 源代码与配置：
├── index.html
├── package.json
├── package-lock.json      # 锁定依赖版本，建议推送
├── vite.config.js
├── .gitignore
├── README.md              # 项目说明
│
✅ 素材与资源：
├── md/history.txt
└── src/
    ├── main.js
    ├── App.vue
    ├── Home.vue
    ├── 全部皮肤图片 (R-C.png / 云间偶戏.webp / ... / 诡秘之主.png)
    ├── data/history.js
    ├── video/biliVideos.js
    ├── styles/global.scss
    └── components/ (6个组件)
│
❌ 不需要推送（已在 .gitignore 排除）：
├── node_modules/          # 依赖包（npm install 自动还原）
├── dist/                  # 构建产物（npm run build 生成）
├── .vite/ .cache/         # 构建缓存
├── .env / .env.local      # 本地环境变量（含密钥）
└── 系统/编辑器临时文件：.DS_Store Thumbs.db .idea .vscode 等
```

### 快速推送命令（PowerShell 逐行执行）

```powershell
# 1. 初始化仓库（仅首次）
git init

# 2. 关联你的 GitHub 仓库（替换成自己的地址）
git remote add origin https://github.com/你的用户名/yuange-hero-site.git

# 3. 预览即将添加的文件，确认没有误加 node_modules 等
git status

# 4. 添加全部源码（.gitignore 会自动过滤）
git add .

# 5. 提交
git commit -m "init: 王者荣耀元歌专题网站 - Vue3 + Vite + Element Plus"

# 6. 推送到 GitHub 主分支
git branch -M main
git push -u origin main
```

## 📄 License

仅供学习与个人作品展示使用。英雄与皮肤素材版权归腾讯游戏所有，《诡秘之主》元素版权归爱潜水的乌贼/阅文集团所有。
