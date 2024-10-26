#!/bin/bash

# 检查 figlet 是否安装，并显示卸载信息
if command -v figlet &> /dev/null; then
    figlet "Uninstall Docker"
else
    echo "Uninstall Docker"
fi

# 一、移除所有未使用的容器、网络、镜像（包括悬空卷）
echo "Removing all unused containers, networks, images, and dangling volumes..."
docker system prune -a -f

# 二、删除应用程序
# 确认删除 Docker 应用程序
read -p "确定要删除 Docker 应用程序吗？(y/n): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    if [ -d "/Applications/Docker.app" ]; then
        echo "删除 Docker 应用程序..."
        sudo rm -rf /Applications/Docker.app
    else
        echo "Docker 应用程序不存在。"
    fi
fi

# 三、清理文件和配置
echo "删除 Docker 配置文件和数据..."
for dir in \
    "~/Library/Containers/com.docker.docker" \
    "~/Library/Application Support/Docker Desktop" \
    "~/Library/Group Containers/group.com.docker" \
    "~/.docker"
do
    expanded_dir=$(eval echo $dir)
    if [ -d "$expanded_dir" ]; then
        sudo rm -rf "$expanded_dir"
        echo "已删除 $expanded_dir"
    else
        echo "$expanded_dir 不存在，跳过。"
    fi
done

# 清理系统缓存和日志
echo "清理系统缓存和日志..."
for cache_or_log in \
    "~/Library/Caches/com.docker.docker" \
    "~/Library/Logs/Docker Desktop"
do
    expanded_path=$(eval echo $cache_or_log)
    if [ -d "$expanded_path" ]; then
        sudo rm -rf "$expanded_path"
        echo "已清理 $expanded_path"
    else
        echo "$expanded_path 不存在，跳过。"
    fi
done

# 四、提示重启系统
echo "请重启系统以确保所有与 Docker 相关的进程和文件都被彻底清除。"