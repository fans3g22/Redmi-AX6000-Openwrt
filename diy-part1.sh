#!/bin/bash
#
# OpenWrt DIY script part 1 (Before Update feeds)
#

# 1. 移除可能冲突的旧包
find ./ -name v2ray-geodata -exec rm -rf {} + 2>/dev/null || true

# 2. 克隆 v2ray-geodata 到 package 目录 (供 Honk 等分流规则使用)
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 3. 克隆 Honk 及 LuCI 管理插件到 package 目录
git clone --depth 1 https://github.com/kenzok8/openwrt-honk package/openwrt-honk

# 4. 补充常用依赖源
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
