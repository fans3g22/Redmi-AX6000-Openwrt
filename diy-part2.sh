#!/bin/bash
#
# OpenWrt DIY script part 2 (After Update feeds)
#

# 默认开启全硬件流控 (Flow Offloading / HW NAT)
for f in package/network/config/firewall4/files/firewall.config package/network/config/firewall/files/firewall.config; do
  if [ -f "$f" ]; then
    sed -i '/config defaults/a \\toption flow_offloading '\''1'\''\n\toption flow_offloading_hw '\''1'\''' "$f"
  fi
done
