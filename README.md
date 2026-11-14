# Redmi AX6000 ImmortalWrt 25.12 纯净增强固件构建

本项目基于 **[ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 25.12 分支** 构建，专为 **红米 Redmi AX6000 (MT7986A Filogic)** 定制。

保持 ImmortalWrt 官方原汁原味的基础系统与默认网络行为，仅在其基础上集成核心代理、DNS 分流、无缝漫游与全硬件加速，无任何多余脚本或冗余插件注入。

---

## 包含的核心特性与基础包

1. **Honk (基于 eBPF 的高性能透明代理与 DNS 服务)**
   - 核心与管理界面：`honk` + `luci-app-honk`
   - 底层内核驱动与基础支持包：`kmod-tun`、`kmod-inet-diag`、`kmod-netlink-diag`、`kmod-nft-tproxy`、`kmod-nft-queue`、`kmod-veth`、`kmod-sched-core`、`kmod-sched-bpf`、`kmod-tcp-bbr`、`ip-full`、`ca-bundle`、`ca-certificates`、`curl`
   - 规则数据：最新 `v2ray-geodata` (`geoip.dat` / `geosite.dat`)
2. **UPnP 与 SQM 体验优化**
   - 端口映射：`luci-app-upnp` (支持主机联机与 P2P 自动映射)
   - 队列管理：`luci-app-sqm` + `kmod-sched-cake` + `kmod-ifb` (CAKE 智能抗 Bufferbloat，下载满速打游戏不跳 ping)
3. **无线 802.11k/v/r 漫游与弱信号剔除**
   - 完整版无线组件：`wpad-wolfssl`（支持 802.11k/v/r 快速漫游与 WPA3）
   - 智能弱信号踢除与漫游引导：`usteer` + `luci-app-usteer`
4. **全硬件流控 (Flow Offloading / HW NAT)**
   - 驱动支持：`kmod-nft-offload`
   - 防火墙默认启用硬件转发加速，充分发挥 MT7986A 硬件包转发引擎效能
5. **Web 控制台与中文语言**
   - `luci` + `luci-base` + `luci-compat` + `luci-lib-ipkg`
   - 简体中文语言包：`luci-i18n-base-zh-cn` 等
   - 基础系统管理与防火墙：`luci-app-firewall`、`luci-app-opkg`

---

## 项目目录结构

```
Redmi-AX6000-Openwrt/
├── .config                     # OpenWrt 编译配置文件
├── diy-part1.sh                # 更新 feeds 源前执行 (拉取 Honk, MosDNS 与额外依赖源)
├── diy-part2.sh                # 更新 feeds 源后执行 (开启防火墙全硬件流控默认选项)
└── .github/workflows/
    ├── build-openwrt.yml       # 核心固件编译工作流 (dl 缓存加速、Release 校验与产物发布)
    └── update-checker.yml      # 上游 ImmortalWrt / Honk / MosDNS 自动更新巡检
```

---

## 固件云端编译 (GitHub Actions)

1. 进入仓库页面顶部 **Actions** 标签页。
2. 在左侧选择 **Build OpenWrt** 工作流。
3. 点击右侧 **Run workflow** 按钮启动云端构建。
4. 编译完成后，可在该次运行详情底部的 **Artifacts** 处或仓库 **Releases** 页面下载编译生成的 `.bin` / `.ubi` 固件。
