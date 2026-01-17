#!/bin/bash

# 1. 添加所有自定义插件源 (统一放在一起)
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki' >> feeds.conf.default

# 2. 统一更新源并安装
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 处理特定的包冲突或替换
# 先卸载旧的 mosdns 相关包
./scripts/feeds uninstall luci-app-mosdns mosdns v2ray-geodata
# 重新从 mosdns 源安装
./scripts/feeds install -f -p mosdns mosdns luci-app-mosdns

# 4. 物理替换 v2ray-geodata (如果需要特定版本)
rm -rf package/v2ray-geodata
find ./ -name v2ray-geodata | xargs rm -rf
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 5. 修复 Makefile 路径 (如果确实有报错需要此操作再开启)
# sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' ./package/*/Makefile

# 6. 最后确保所有包都已安装
./scripts/feeds install -a
