# 吃什么 · 鲸鱼娘帮你选一家真实的店 🐳

蓝色系「今天吃什么」网页。**选到区县（省 / 市 / 区县三级树状）→ 鲸鱼娘从高德地图的真实餐厅里随机抽一家**，
给出店名、菜系、评分、人均、地址、电话，一键跳转高德导航。

- 线上地址：<https://jinluxury.github.io/-/>
- 纯静态站点，无后端、无构建步骤；图片全部 base64 内嵌，`index.html` 单文件可离线双击打开

![预览](assets/og-cover.png)

---

## 功能

| 功能 | 说明 |
|---|---|
| **三级逐级下钻选择** | 点**省份** → 列出该省所有**城市** → 点城市 → 列出该市所有**区县** → 点区县即选中。全国 **34 省 / 349 市 / 3394 区县**（高德官方行政区划数据，已内嵌，无需联网） |
| **直接搜地名** | 搜索框输「拱墅区」「朝阳区」直接定位到区县，不用一层层点 |
| **可回退的面包屑** | `浙江省 › 杭州市 › 拱墅区`，点任意一层都能跳回去改 |
| **抽取范围** | 本区县 / 本市 / 本省，三档随意切换 |
| **真实店名** | 调高德 `place/text`（`types=050000` 餐饮服务），返回真实 POI：店名、菜系、评分、人均、地址、电话、坐标 |
| **一键导航** | 「在高德打开」调用高德 URI API，手机点开可直接唤起高德 App |
| **10 分钟缓存** | 同一地点重复点击不再请求接口，省额度也更快 |
| **带记忆** | 选过的地区、最近 6 次抽到的店都存 localStorage |
| **一个居中吉祥物** | 页面正上方居中一只透明底鲸鱼娘（女仆装），随抽取动作轻微摇摆；左上角 LOGO 头像 + 结果卡小图也是同一系列透明底图 |

> 已按要求**去掉浏览器定位**，改为纯手选地区。

## 图片说明（全部透明底）

| 文件 | 用途 | 位置 |
|---|---|---|
| `maid.webp` | 居中吉祥物（女仆装 Q 版） | 标题上方居中 |
| `avatar.webp` | 头像 | 左上角 LOGO |
| `eat_bowl.webp` | 干饭特写 | 结果卡左侧小图 |
| `eat_girl.webp` / `eat_chibi.webp` / `eat_pose.webp` | 备用的干饭系列透明图 | `assets/` 里备用，页面未使用（想要散落装饰时可随时放回去） |

改吉祥物大小：`index.html` 里 `.mascot{width:min(240px,46vw)}`；手机端在 media query 里单独设 `min(200px,52vw)`。



## 目录结构

```
whale-food-site/
├── index.html            整个网页（含区划数据 + base64 图片 + 逻辑，约 460 KB）
├── 404.html              找不到页面时的兜底页
├── robots.txt / _config.yml / .gitattributes
├── assets/
│   ├── whale-girl.png    鲸鱼娘原图（CC BY-NC-SA 4.0）
│   ├── mascot.webp / eating.webp / bowl.webp / sticker.webp / hint.webp   页面用图
│   ├── favicon.svg / favicon-32.png / favicon-180.png
│   └── og-cover.png      1200×630 分享卡图
└── scripts/
    ├── deploy.ps1        一键提交 + 推送 GitHub
    └── set-site-url.ps1  把真实网址写进 canonical / og:image
```

---

## 高德 Key 说明（重要）

页面里用的是**高德 Web 服务 Key**（个人开发者免费）：

```js
var AMAP_KEY = "……";   // index.html 内搜索 AMAP_KEY 即可替换
```

- **必须选「Web服务」平台**的 Key；选成「Web端(JS API)」会报 `USER_KEY_PLATFORM_ERROR`
- 静态站的 Key 一定会暴露在前端源码里，这是没法避免的。建议：
  1. 在高德控制台给这个 Key 设**调用量上限 / 用量告警**
  2. 定期在控制台看用量，异常就删掉重建 Key
  3. 想要彻底安全，就得加一层自己的后端代理（本项目没做）
- 免费额度内个人日常使用完全够；每次抽奖 = 1 次接口调用，10 分钟内重复抽同一地区走缓存不消耗额度
- 换 Key：改 `index.html` 里的 `AMAP_KEY`，或直接用 `_work` 里的模板重新装配

## 更新发布

```powershell
cd D:\router\Logisim2.7.1-cn\whale-food-site
git add -A
git commit -m "更新说明"
git push
```

GitHub Pages 会在 1 分钟内置自动重新发布。

> 如果 `git push` 报 `Connection was reset`，说明 git 没走代理：
> `git config --global http.proxy http://127.0.0.1:7897`（换成你自己的代理端口）

## 上线后自查

- [ ] 打开站点，鲸鱼娘 + 「吃什么」标题正常
- [ ] 右上角选地区 → 搜「拱墅区」→ 直接选中，显示「浙江省 杭州市 拱墅区」
- [ ] 点「随机一家」→ 出真实店名 + 地址 + 评分，不报错
- [ ] 切换「本市 / 本省」范围再抽，结果跟着变
- [ ] 点「在高德打开」能跳到高德
- [ ] 手机上排版正常（右下角贴纸点一下可展开）
- [ ] 换个不存在的路径出现 404 页

## 授权与署名

- 页面代码：随意使用。
- **女仆装鲸鱼娘**：社区二创，**CC BY-NC-SA 4.0（署名 / 非商用 / 相同方式共享）**
  - OC「溟月」by 上善无形 · DeepSeek 元素二创 ZipZipPipe · 修复 QYQCAMIAO
  - 取自 <https://github.com/fornarwhal/deepseek-whale-girl-icon>
- **干饭系列图**（先吃饭后推理 / 一碗能量加载中 / 端碗特写 / Q 版举筷）：**MIT**
  - 取自 <https://github.com/Neko3000/deepseek-whalechan>
- 店铺数据：**高德地图开放平台**（页面内已标注「数据来源：高德地图」）
- 请勿用于商业用途；商用需替换为自有版权的图片，并遵守高德开放平台条款。
