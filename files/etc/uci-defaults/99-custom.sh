#!/bin/sh
# Xhaxhwrt 首启网络兜底：网关固定 10.0.0.1，切过来即用
# （配置还原后以 /etc/config/network 为准，本脚本仅覆盖未还原场景）
IP="$(cat /etc/config/custom_router_ip.txt 2>/dev/null || echo 10.0.0.1)"

uci -q set network.lan.ipaddr="$IP"
uci -q set network.lan.netmask='255.255.255.0'
uci -q set system.@system[0].hostname='xhaxhwrt'
uci -q commit network
uci -q commit system

exit 0
