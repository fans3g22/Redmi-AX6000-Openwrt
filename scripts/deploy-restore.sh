#!/usr/bin/env bash
set -euo pipefail

# 默认检测常见的 OpenWrt 初始 IP (192.168.1.1 或 192.168.71.80)
TARGET_IP="${1:-}"

if [ -z "$TARGET_IP" ]; then
    if ping -c 1 -W 1 192.168.71.80 >/dev/null 2>&1; then
        TARGET_IP="192.168.71.80"
    elif ping -c 1 -W 1 192.168.1.1 >/dev/null 2>&1; then
        TARGET_IP="192.168.1.1"
    else
        echo "[!] 请指定路由器的 IP 地址: ./deploy-restore.sh 192.168.1.1"
        exit 1
    fi
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PKG_TAR="$SCRIPT_DIR/restore-ax6000-honk.tar.gz"
RESTORE_SCRIPT="$SCRIPT_DIR/restore-router.sh"
KEY_FILE="$HOME/.ssh/id_armbian"

SSH_OPTS=(-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)
if [ -f "$KEY_FILE" ]; then
    SSH_OPTS+=(-i "$KEY_FILE")
fi

echo "=========================================================="
echo " 正在将恢复包部署到路由器 root@$TARGET_IP ..."
echo "=========================================================="

# 上传恢复包和恢复脚本
scp "${SSH_OPTS[@]}" "$PKG_TAR" "$RESTORE_SCRIPT" "root@$TARGET_IP:/tmp/"

# 执行恢复
ssh "${SSH_OPTS[@]}" "root@$TARGET_IP" "sh /tmp/restore-router.sh"

echo "[✓] 恢复流程全部执行完毕！"
