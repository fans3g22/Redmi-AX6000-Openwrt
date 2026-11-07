#!/bin/bash
#
# OpenWrt DIY script part 1 (Before Update feeds)
#

# 1. 移除可能冲突的旧包
find ./ -name luci-app-mosdns -exec rm -rf {} + 2>/dev/null || true
find ./ -name mosdns -exec rm -rf {} + 2>/dev/null || true
find ./ -name v2ray-geodata -exec rm -rf {} + 2>/dev/null || true

# 2. 克隆 MosDNS (sbwml v5 稳定版) 与 v2ray-geodata 到 package 目录
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 3. 克隆 Honk 及 LuCI 管理插件到 package 目录
git clone --depth 1 https://github.com/kenzok8/openwrt-honk package/openwrt-honk

# 4. 补充常用依赖源
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
