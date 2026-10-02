#!/bin/sh
nft delete table bridge dhcp_guard 2>/dev/null || true
nft add table bridge dhcp_guard || exit 1
nft add chain bridge dhcp_guard forward '{ type filter hook forward priority -300; policy accept; }' || exit 1
nft add rule bridge dhcp_guard forward meta protocol ip udp sport 67 udp dport 68 counter drop || exit 1
nft add rule bridge dhcp_guard forward meta protocol ip udp sport 68 udp dport 67 counter drop || exit 1
nft add rule bridge dhcp_guard forward meta protocol ip6 udp sport 547 udp dport 546 counter drop || exit 1
nft add rule bridge dhcp_guard forward meta protocol ip6 udp sport 546 udp dport 547 counter drop || exit 1
nft add rule bridge dhcp_guard forward meta protocol ip6 icmpv6 type nd-router-advert counter drop || exit 1
