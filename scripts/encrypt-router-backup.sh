#!/bin/sh
set -eu

if [ -z "${ROUTER_BACKUP:-}" ] || [ ! -f "$ROUTER_BACKUP" ]; then
  echo "Usage: ROUTER_BACKUP=/path/to/backup.tar ROUTER_CONFIG_ARCHIVE_PASSWORD='...' $0" >&2
  exit 1
fi

if [ -z "${ROUTER_CONFIG_ARCHIVE_PASSWORD:-}" ]; then
  echo "ROUTER_CONFIG_ARCHIVE_PASSWORD must be set" >&2
  exit 1
fi

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
output="$repo_root/configs/router-backup-$(date +%F).tar.gz.enc"

mkdir -p "$repo_root/configs"
umask 077
gzip -c "$ROUTER_BACKUP" | openssl enc -aes-256-cbc -salt -pbkdf2 -iter 600000 \
  -out "$output" \
  -pass env:ROUTER_CONFIG_ARCHIVE_PASSWORD

echo "Wrote $output"
