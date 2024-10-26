#!/bin/bash
set -e

# 重新加载系统服务
sudo systemctl daemon-reload
# 重启 docker 服务
sudo systemctl restart docker

# 保持容器运行
exec "$@"