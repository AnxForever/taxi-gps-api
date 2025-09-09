#!/bin/bash
# 自动部署到GitHub Pages脚本

echo "🚀 开始部署GPS数据到GitHub Pages..."

# 检查git状态
if [ ! -d ".git" ]; then
    echo "❌ 当前目录不是Git仓库"
    exit 1
fi

# 添加所有文件
git add .
git status

# 提交变更
echo "📝 提交数据更新..."
git commit -m "更新GPS出租车数据 $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到GitHub
echo "📤 推送到GitHub..."
git push origin main

echo "✅ 部署完成!"
echo "🌐 数据将在几分钟后通过GitHub Pages可用"
echo "📍 访问地址: https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/"
