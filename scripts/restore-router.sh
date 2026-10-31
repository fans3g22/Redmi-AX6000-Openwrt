#!/bin/sh
set -e

echo "=========================================================="
echo " 开始一键恢复 Redmi AX6000 配置 (Honk + MosDNS + 性能优化)"
echo "=========================================================="

TAR_FILE="restore-ax6000-honk.tar.gz"
if [ ! -f "$TAR_FILE" ] && [ -f "/tmp/$TAR_FILE" ]; then
    TAR_FILE="/tmp/$TAR_FILE"
fi

# 1. 解压配置包
if [ -f "$TAR_FILE" ]; then
    echo "[1/7] 正在解压配置文件到系统根目录..."
    tar -xzf "$TAR_FILE" -C /
else
    echo "[!] 未在当前目录或 /tmp 找到 $TAR_FILE，仅执行配置与服务重载。"
fi

# 2. 赋予脚本执行权限
echo "[2/7] 设置防火墙及工作目录权限..."
chmod 0755 /etc/firewall/dhcp_guard.sh 2>/dev/null || true
chmod 0755 /etc/firewall.user 2>/dev/null || true
mkdir -p /etc/honk/data
chmod 0700 /etc/honk/data

# 3. 部署内核性能调优 (BBR + FQ + BPF JIT + Socket/Conntrack 优化)
echo "[3/7] 应用系统内核网络性能调优 (BBR, BPF JIT, TCP Buffer)..."
if [ -f /etc/sysctl.d/99-custom-net.conf ]; then
    sysctl -p /etc/sysctl.d/99-custom-net.conf 2>/dev/null || true
fi

# 4. 确保防火墙包含 firewall.user (执行 DHCP/IPv6 RA Guard)
echo "[4/7] 配置防火墙 DHCP/RA Guard 规则（拦截上游光猫 DHCP 劫持）..."
if ! uci -q get firewall.custom_rules >/dev/null 2>&1; then
    uci add firewall include >/dev/null
    uci rename firewall.@include[-1]='custom_rules'
fi
uci set firewall.custom_rules.type='script'
uci set firewall.custom_rules.path='/etc/firewall.user'
uci set firewall.custom_rules.fw4_compatible='1'
uci set firewall.custom_rules.enabled='1'
uci commit firewall

# 5. 清理旧代理 (momo / nikki) 残留
echo "[5/7] 清理旧代理残留..."
/etc/init.d/momo stop 2>/dev/null || true
/etc/init.d/momo disable 2>/dev/null || true
/etc/init.d/nikki stop 2>/dev/null || true
/etc/init.d/nikki disable 2>/dev/null || true

# 6. 启动必要的核心服务
echo "[6/7] 启用并启动关键服务 (mosdns, honk, usteer)..."
/etc/init.d/mosdns enable 2>/dev/null || true
/etc/init.d/mosdns restart 2>/dev/null || true

/etc/init.d/honk enable 2>/dev/null || true
/etc/init.d/honk restart 2>/dev/null || true

/etc/init.d/usteer enable 2>/dev/null || true
/etc/init.d/usteer restart 2>/dev/null || true

# 7. 重启网络与无线生效
echo "[7/7] 重启网络、DHCP 与无线..."
/etc/init.d/firewall restart 2>/dev/null || true
/etc/init.d/odhcpd restart 2>/dev/null || true
/etc/init.d/dnsmasq restart 2>/dev/null || true
/etc/init.d/network restart 2>/dev/null || true
wifi reload 2>/dev/null || true

echo "=========================================================="
echo " 恭喜！一键恢复与性能优化全部完成，路由器已成功就绪！"
echo " - LAN 管理 IP : 192.168.71.80 (上游网关 192.168.71.1)"
echo " - Wi-Fi SSID  : FN (已启用 802.11r/k/v 漫游 + usteer)"
echo " - 局域网 DHCP : OpenWrt 独占 (上游光猫 67/68 与 RA 已被拦截)"
echo " - DNS 分流    : MosDNS (国内 5335, 国外 5336; Dnsmasq 缓存已轻量化)"
echo " - 透明代理    : Honk (eBPF 内核旁路, 配置文件: /etc/honk/config.dae)"
echo " - 内核性能栈  : BBR + FQ 队列，BPF JIT 极速模式，16MB TCP 缓冲区"
echo "=========================================================="
