# ============================================================
#  一键把本站推送到 GitHub（首次会自动初始化仓库）
#  用法:
#     .\scripts\deploy.ps1 -Remote https://github.com/你的用户名/whale-food-site.git
#  之后再次更新只需:
#     .\scripts\deploy.ps1
# ============================================================
param(
  [string]$Remote = "",
  [string]$Branch = "main",
  [string]$Message = "update: 吃什么 · 鲸鱼娘帮你选"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Need-Git {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "没检测到 git，请先安装 Git for Windows: https://git-scm.com/download/win"
  }
}

Need-Git
Write-Host "仓库目录: $root" -ForegroundColor Cyan

# 1) 初始化（首次）
if (-not (Test-Path (Join-Path $root ".git"))) {
  Write-Host "-> 初始化 git 仓库" -ForegroundColor Yellow
  git init | Out-Null
  git branch -M $Branch
}

# 2) 设置 remote
if ($Remote -ne "") {
  $existing = (git remote 2>$null) -split "`n" | Where-Object { $_.Trim() -eq "origin" }
  if ($existing) { git remote set-url origin $Remote } else { git remote add origin $Remote }
  Write-Host "-> remote origin = $Remote" -ForegroundColor Yellow
}

if (-not ((git remote 2>$null) -match "origin")) {
  throw "还没有 remote。请这样运行： .\scripts\deploy.ps1 -Remote https://github.com/你的用户名/whale-food-site.git"
}

# 3) 提交
git add -A
$dirty = (git status --porcelain)
if ($dirty) {
  git -c user.name="whale-food" -c user.email="whale-food@users.noreply.github.com" commit -m $Message | Out-Null
  Write-Host "-> 已提交改动" -ForegroundColor Yellow
} else {
  Write-Host "-> 没有新改动，跳过提交" -ForegroundColor DarkGray
}

# 4) 推送
git push -u origin $Branch

Write-Host ""
Write-Host "[OK] 推送完成。" -ForegroundColor Green
Write-Host "如果还没开启 Pages：仓库 Settings -> Pages -> Source 选 'Deploy from a branch'，Branch 选 $Branch / (root)，Save。" -ForegroundColor Cyan
Write-Host "等 1 分钟左右，网址就是： https://<你的用户名>.github.io/<仓库名>/" -ForegroundColor Cyan
Write-Host ""
Write-Host "别忘了把真实网址写进 SEO/分享卡：" -ForegroundColor Cyan
Write-Host "    .\scripts\set-site-url.ps1 -User <你的用户名> -Repo <仓库名>" -ForegroundColor Cyan
