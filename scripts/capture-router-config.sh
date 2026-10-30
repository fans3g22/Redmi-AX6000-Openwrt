#!/usr/bin/env bash
set -euo pipefail

: "${ROUTER_CONFIG_ARCHIVE_PASSWORD:?Set ROUTER_CONFIG_ARCHIVE_PASSWORD first}"

router_host="${ROUTER_HOST:-root@192.168.71.80}"
router_key="${ROUTER_SSH_KEY:-$HOME/.ssh/id_armbian}"
repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
output="${ROUTER_OUTPUT:-$repo_root/configs/router-backup-$(date +%F).tar.gz.enc}"

mkdir -p "$(dirname -- "$output")"
umask 077

ssh -i "$router_key" \
  -o IdentitiesOnly=yes \
  -o BatchMode=yes \
  -o StrictHostKeyChecking=accept-new \
  "$router_host" \
  'tar -C / -czf - etc' |
  openssl enc -aes-256-cbc -salt -pbkdf2 -iter 600000 \
    -out "$output" \
    -pass env:ROUTER_CONFIG_ARCHIVE_PASSWORD

echo "Encrypted router configuration written to:"
echo "$output"
