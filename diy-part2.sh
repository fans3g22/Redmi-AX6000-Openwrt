#!/bin/bash
#
# OpenWrt DIY script part 2 (After Update feeds)
#

# Honk uses eBPF CO-RE and requires the running kernel to expose BTF.
# CONFIG_KERNEL_DEBUG_INFO_BTF in the OpenWrt .config selects the kernel
# option, but write the kernel-level options explicitly as well so target
# fragments cannot silently override them.
kernel_config='target/linux/mediatek/filogic/config-6.12'
if [ ! -f "$kernel_config" ]; then
  echo "ERROR: $kernel_config was not found" >&2
  exit 1
fi

sed -i -E '/^(# )?CONFIG_DEBUG_INFO(=| is not set)/d; /^(# )?CONFIG_DEBUG_INFO_BTF(=| is not set)/d' "$kernel_config"
cat >> "$kernel_config" <<'EOF'

# Required by Honk eBPF CO-RE. OpenWrt strips debug symbols from the final
# image, while retaining the BTF section used through /sys/kernel/btf/vmlinux.
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_BTF=y
EOF

# 默认开启全硬件流控 (Flow Offloading / HW NAT)
for f in package/network/config/firewall4/files/firewall.config package/network/config/firewall/files/firewall.config; do
  if [ -f "$f" ]; then
    sed -i '/config defaults/a \\toption flow_offloading '\''1'\''\n\toption flow_offloading_hw '\''1'\''' "$f"
  fi
done
