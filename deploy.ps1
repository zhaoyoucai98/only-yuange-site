# 元歌专题网站 - 一键部署到 GitHub Pages (main 分支 /docs 目录)
# 使用方法：在项目根目录右键 -> "在终端中运行" 然后输入： .\deploy.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   元歌专题网站 - 一键部署 GitHub Pages" -ForegroundColor Cyan
Write-Host "   (main 分支 /docs 目录方案)" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan

# 1. 进入脚本所在目录（即项目根目录）
Set-Location $PSScriptRoot
Write-Host "[1/4] 当前目录: $(Get-Location)" -ForegroundColor Yellow

# 2. 删除旧的构建产物
Write-Host "[2/4] 清理旧构建..." -ForegroundColor Yellow
if (Test-Path docs) {
    Remove-Item -Recurse -Force docs
}

# 3. 执行 npm run build（vite.config.js 已配置 outDir = 'docs'）
Write-Host "[3/4] 执行生产构建 (npm run build)..." -ForegroundColor Yellow
npm.cmd run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 构建失败！请检查错误信息后重试" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}

# 4. 复制 index.html -> 404.html（SPA 路由回退，防刷新 404）
Write-Host "[4/4] 生成 SPA 路由回退页 (404.html)..." -ForegroundColor Yellow
Copy-Item docs\index.html docs\404.html -Force

# 5. 提交 docs/ 和配置变更到 main 分支并推送
Write-Host ""
Write-Host "正在提交并推送到 main 分支..." -ForegroundColor Magenta
git add -A 2>$null
git status --short

$commitMsg = "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg 2>$null
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "   ✅ 部署成功！🎉" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "访问地址: https://zhaoyoucai98.github.io/only-yuange-site/" -ForegroundColor Cyan
    Write-Host "(首次部署请等待 GitHub Pages 分发，约 30-60 秒后刷新)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "⚠️  Pages 部署源设置确认（只需要设置一次）：" -ForegroundColor Yellow
    Write-Host "   Source: Deploy from a branch" -ForegroundColor White
    Write-Host "   Branch: main   👉  Folder: /docs  👉  Save" -ForegroundColor White
} else {
    Write-Host "❌ 推送失败！请检查网络或 GitHub 权限" -ForegroundColor Red
}

Write-Host ""
Read-Host "按回车退出"
