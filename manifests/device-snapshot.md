# Router snapshot

Captured 2026-10-29 from `https://192.168.71.80/`.

## Identity and firmware

| Item | Value |
| --- | --- |
| Model | Xiaomi Redmi Router AX6000 (`stock` layout) |
| Target | `mediatek/filogic` |
| CPU | ARMv8, MediaTek MT7986, 4 cores |
| Firmware | ImmortalWrt 25.12-SNAPSHOT |
| Firmware revision | `r38202-313718c25f` |
| Source commit | `313718c25f206cdeee399bdc6c002b7388c9a513` |
| Kernel | 6.12.108 |
| LuCI | `26.249.28459~d6167ea` |
| Hostname | `ImmortalWrt` |
| Timezone | `Asia/Shanghai`, `CST-8` |
| Installed packages | 295 |

## Network

The device is configured as a LAN router/access point rather than a
conventional routed gateway:

| Item | Value |
| --- | --- |
| LAN address | `192.168.71.80/24` |
| Upstream gateway | `192.168.71.1` |
| DNS | `223.5.5.5`, `119.29.29.29` |
| Dnsmasq upstream | `127.0.0.1#5354` (Momo/sing-box DNS) |
| DHCP range | `192.168.71.150`-`.249`, 12 h leases |
| DHCP advertised gateway/DNS | `192.168.71.80` |
| Bridge | `br-lan`: `lan2`, `lan3`, `lan4`, `wan` |
| MAC | `D4:DA:21:EF:9A:8C` |

The WAN port and `wan` firewall zone exist, but the current `wan` port is
bridged into LAN. This layout must be preserved unless the physical network is
redesigned.

## Wireless

| Radio | Settings |
| --- | --- |
| 2.4 GHz | MT7986, channel 1, HE20, country CN, 10 dBm |
| 5 GHz | MT7986, channel 36, HE160, country CN, 16 dBm |
| SSID | `FN` on both radios |
| Security | WPA2 PSK/CCMP, password stored only in the encrypted snapshot |
| Roaming | 802.11r, 802.11k, 802.11v, usteer |

## Firewall and services

- Hardware and software flow offloading are enabled.
- Full-cone NAT is enabled; IPv6 full-cone is disabled.
- Momo 1.2.1 is enabled with sing-box 1.12.25 and profile
  `configdns-2-2.json`.
- Momo transparent proxy uses TPROXY for TCP and UDP, with LAN and router
  traffic proxied.
- Momo panel/API listens on `192.168.71.80:9090`.
- UPnP IGD is installed; `uhttpd` and `miniupnpd` are disabled by the public
  bootstrap script. LuCI uses nginx/uwsgi.
- 3proxy and RADIUS are installed but disabled.
- Nikki is disabled; its configuration is retained in the encrypted snapshot.
- Scheduled jobs restart Momo at 03:00 daily, clear its logs every 5 minutes,
  and reboot the router Wednesdays at 05:00 after `sync`.

The encrypted snapshot is a gzip archive of the complete live `/etc` tree
(442 entries), including the active mosdns configuration and Momo panel assets.
Build-time extraction excludes caches, temporary password backups and the
urandom seed.

## Build source pins

| Source | Ref |
| --- | --- |
| ImmortalWrt | `313718c25f206cdeee399bdc6c002b7388c9a513` |
| ImmortalWrt packages | `8c55f325c98f8ef09906fce123e83314f02470ee` |
| ImmortalWrt LuCI | `2858f8d98b270bd3baf30a1d19c6e26df22c3197` |
| 3proxy extra package feed | `f3355492bd38b6e40afbb1cad9307c43bf4d843e` |
| Momo | `v1.2.1`, `dc0b315030aff15687829e3c411421299d32298a` |
| mosdns | `v5.3.4-r14`, `fae49a28404a7cee309b47fccd920c3da7e81c2e` |
| mihomo / small feed | `1.19.32`, `3a03f66d706885bf4a35d9ac04c08b2d51593f55` |

The full package/version inventory is in `installed-packages.tsv`.
