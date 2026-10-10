# ============================================================
#  吃什么 · 鲸鱼娘帮你选  —— 把站点 URL 写进 SEO / 分享卡
#  用法:  .\scripts\set-site-url.ps1 -User 你的GitHub用户名 -Repo whale-food-site
# ============================================================
param(
  [Parameter(Mandatory = $true)][string]$User,
  [string]$Repo = "whale-food-site"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$index = Join-Path $root "index.html"
$url = "https://$User.github.io/$Repo/"

if (-not (Test-Path $index)) { throw "找不到 index.html：$index" }

$txt = [System.IO.File]::ReadAllText($index, [System.Text.Encoding]::UTF8)

# canonical
$txt = [regex]::Replace($txt, '<link rel="canonical" href="[^"]*">',
  "<link rel=`"canonical`" href=`"$url`">")

# og:image / twitter:image 必须是绝对地址（社交平台抓取用）
$txt = [regex]::Replace($txt, '<meta property="og:image" content="[^"]*">',
  "<meta property=`"og:image`" content=`"${url}assets/og-cover.png`">")
$txt = [regex]::Replace($txt, '<meta name="twitter:image" content="[^"]*">',
  "<meta name=`"twitter:image`" content=`"${url}assets/og-cover.png`">")

[System.IO.File]::WriteAllText($index, $txt, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "[OK] 站点地址已写入 index.html" -ForegroundColor Green
Write-Host "     canonical : $url"
Write-Host "     分享卡图  : ${url}assets/og-cover.png"
Write-Host ""
Write-Host "下一步：提交并推送后，到仓库 Settings -> Pages 选择 main / (root) 保存。" -ForegroundColor Cyan
