# Redmi AX6000 / ImmortalWrt 可复现构建

本仓库按 2026-10-29 从在线路由器导出的配置和软件清单构建
`Xiaomi Redmi Router AX6000 (stock layout)` 固件。

## 当前设备基线

- 固件：ImmortalWrt `25.12-SNAPSHOT`
- 固件版本：`r38202-313718c25f`
- ImmortalWrt 源码：`313718c25f206cdeee399bdc6c002b7388c9a513`
- 内核：`6.12.108`
- 平台和目标：`mediatek/filogic`
- 设备布局：stock
- 路由器 LAN：`192.168.71.80/24`
- 上游网关：`192.168.71.1`
- 已安装软件：295 个，完整版本清单在
  [`manifests/installed-packages.tsv`](manifests/installed-packages.tsv)

详细配置摘要见
[`manifests/device-snapshot.md`](manifests/device-snapshot.md)。

## 构建

1. 在仓库 `Settings > Secrets and variables > Actions` 中创建名为
   `ROUTER_CONFIG_ARCHIVE_PASSWORD` 的 secret。
2. 打开 `Actions > Build ImmortalWrt for Redmi AX6000 > Run workflow`。
3. 保持 `include_router_config=true`，下载
   `immortalwrt-ax6000-stock-current-router` artifact。
4. 在 LuCI 的“备份与更新”页面刷写
   `*-squashfs-sysupgrade.bin`。首次使用 stock factory 映像前，应再次确认
   当前 U-Boot 和分区布局。

若只想验证软件选择、不注入私人配置，将 `include_router_config` 设为
`false`。

## 私人配置

路由器完整备份经过 AES-256/PBKDF2 加密后保存在：

`configs/router-backup-2026-10-29.tar.gz.enc`

其中是路由器当前的整个 `/etc` 配置树，包含 Wi-Fi 密码、Momo 订阅/节点、
mosdns 配置、防火墙脚本、root 密码哈希、SSH 主机密钥和其他个人凭据。因此
不能删除加密或直接提交明文备份。构建时仅在 GitHub runner 的临时目录中
解密，排除缓存与临时文件后覆盖到 OpenWrt 构建的 `files/` 目录。

重新导出路由器备份后，可运行：

```sh
ROUTER_BACKUP=backup-ImmortalWrt-YYYY-MM-DD.tar \
ROUTER_CONFIG_ARCHIVE_PASSWORD='secure-password' \
./scripts/encrypt-router-backup.sh
```

[`files/`](files/) 中只保存可公开的辅助脚本。路由器的 DMZ、防火墙、无线、
Momo/mosdns 和计划任务设置来自加密快照。

## 安全提示

- 此仓库是公开仓库；GitHub Actions artifact 含刷入设备后可直接读取的个人
  设置，请仅自己下载，不要公开分享固件。
- 固件包含原设备的配置身份。若公开固件，应先移除
  `/etc/shadow`、`/etc/dropbear/*_host_key`、无线密码和代理凭据。
- 刷机前保留 `backup-ImmortalWrt-2026-10-29.tar` 和密文备份。
- stock 与 ubootmod 的 U-Boot/分区布局不同，不能混刷。
