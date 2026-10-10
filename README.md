# 吃什么 · 鲸鱼娘帮你选 🐳

蓝色系「今天吃什么」随机选菜网页。选一个中国地区 → 鲸鱼娘帮你随机抽一道**附近的地方菜**。
纯静态站点，无后端、无构建步骤、无依赖，直接丢到 GitHub Pages 就能用。

![预览](assets/og-cover.png)

---

## 目录结构

```
whale-food-site/
├── index.html              # 整个网页（样式/脚本内嵌，鲸鱼娘图已 base64 内嵌，单文件可离线双击打开）
├── 404.html               # 找不到页面时的可爱兜底页
├── robots.txt             # 允许搜索引擎收录
├── assets/
│   ├── whale-girl.png     # 鲸鱼娘原图（CC BY-NC-SA 4.0，署名见下）
│   ├── favicon.svg        # 矢量图标
│   ├── favicon-32.png     # 小图标
│   ├── favicon-180.png    # iOS 添加到主屏用的图标
│   └── og-cover.png       # 1200×630 分享卡片图（微信/QQ/Twitter 抓取）
└── scripts/
    ├── deploy.ps1         # 一键提交 + 推送 GitHub
    └── set-site-url.ps1   # 把真实网址写进 canonical / og:image
```

## 功能

- **标题「吃什么」** 三个渐变大字，逐字轻微跳动
- **中央大按钮「随机一下」**：按下后 0.4–1 秒摇奖 → 出结果卡（菜名 / 来源地区 / 口味标签 / 再抽一次 / 复制菜名），不会连续抽到同一道
- **右上角「选择地区」**：默认自动定位（先浏览器定位，失败退到网络定位），定位不到就留在「全国随机」等你手选；面板里是 34 个省级地区 + 全国随机
- **34 个地区 / 350+ 道地方菜**（北京烤鸭、螺蛳粉、肉夹馍、手抓饭、蚵仔煎……）
- **本地记忆**：选择的地区、最近 6 次抽到的菜都存 localStorage
- 蓝色基调 + 上浮气泡 + 底部波浪；支持手机窄屏；尊重「减少动态效果」系统设置
- 键盘空格键也能抽

---

## 部署到 GitHub Pages（3 步）

### 方式 A：网页上传（最省事，不用装 git）

1. 打开 [github.com/new](https://github.com/new) 建一个仓库，名字比如 `whale-food-site`，选 **Public**，不要勾选 "Add a README"，点 Create。
2. 进入仓库 → **Add file → Upload files** → 把本目录里的 `index.html`、`404.html`、`robots.txt`、`assets/`、`scripts/` 全部拖进去 → Commit changes。
3. 仓库 **Settings → Pages** → Source 选 `Deploy from a branch`，Branch 选 `main` + `/ (root)` → **Save**。
   等 1 分钟，访问 `https://<你的用户名>.github.io/whale-food-site/`。

### 方式 B：本地脚本（推荐，以后更新方便）

```powershell
cd whale-food-site
git init
git branch -M main
git add -A
git commit -m "init: 吃什么 · 鲸鱼娘帮你选"
git remote add origin https://github.com/<你的用户名>/whale-food-site.git
git push -u origin main
```

之后每次改完，只要：

```powershell
.\scripts\deploy.ps1
```

首次也可以一步到位：

```powershell
.\scripts\deploy.ps1 -Remote https://github.com/<你的用户名>/whale-food-site.git
```

> 如果 push 时提示要密码：GitHub 早已不支持账号密码，请用
> **Personal Access Token**（Settings → Developer settings → Tokens (classic)，勾 `repo`）当密码，
> 或直接装 [GitHub CLI](https://cli.github.com/) 后 `gh auth login`。

### 最后一步（建议）：写入真实网址

```powershell
.\scripts\set-site-url.ps1 -User <你的用户名> -Repo whale-food-site
```

它会把 `index.html` 里的 `canonical` 和 `og:image` 换成你的真实地址（`og:image` 必须是绝对网址，微信/QQ 才能抓到分享卡图），然后再 `.\scripts\deploy.ps1` 推一次即可。

---

## 上线后自查

- [ ] 打开站点，蓝色背景 + 鲸鱼娘 + 「吃什么」标题正常显示
- [ ] 点「随机一下」能出菜名、卡片有动画
- [ ] 右上角点开地区面板能选省份，选完按钮下的文案跟着变
- [ ] 手机上（或用浏览器 F12 切设备模拟）排版不错位
- [ ] 把网址丢进微信/QQ/Twitter，能出现分享卡图（og-cover）
- [ ] 换一个不存在的路径，比如 `/abc`，会出现 404 兜底页

## 常见问题

**定位不准 / 不弹权限？**
浏览器定位需要 HTTPS（GitHub Pages 自带 HTTPS，所以线上比本地 `file://` 打开更准）。
定位失败时右侧会提示，直接在面板里手选地区即可，功能不受影响。

**想换成自己的图？**
`index.html` 里有两处 base64 图片（吉祥物大图、左上角头像）。替换方法：把自己的 PNG 转成 base64，
替换 `data:image/png;base64,...` 里逗号后那一长串即可；`assets/favicon*.png` 和 `assets/og-cover.png` 也一并换掉。

**想加菜？**
`index.html` 里 `var FOODS = { "浙江": [...], ... }`，按同样格式往数组里加菜名就行；
地区坐标表 `REGION_CENTER` 和口味标签 `FLAVOR_HINTS` 可选填。

**文件多大？会被限制吗？**
`index.html` 约 800 KB（图片已内嵌），GitHub Pages 单文件上限 100 MB、站点 1 GB，完全够用。

---

## 授权与署名

- 页面代码：随便用。
- **吉祥物「DeepSeek 鲸鱼娘」为社区二创作品，授权 CC BY-NC-SA 4.0：必须署名、不得商用、相同方式共享。**
  - 角色形象来源：上善无形（原创 OC「溟月」）
  - DeepSeek 元素二创：ZipZipPipe（GPT Image 2）
  - 改进版修复：QYQCAMIAO
  - 图片取自社区仓库：[fornarwhal/deepseek-whale-girl-icon](https://github.com/fornarwhal/deepseek-whale-girl-icon)
  - 更多参考图：[TreapGoGo/deepseek-whale-girl](https://github.com/TreapGoGo/deepseek-whale-girl)
- 页脚已包含上述署名。**如果要商用、打广告或去掉署名，请替换成自己有权的图片。**
- 菜品数据为各地常见地方菜，仅供参考。
