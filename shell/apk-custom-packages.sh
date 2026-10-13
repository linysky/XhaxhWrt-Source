#!/bin/bash
# ============================================================
# Xhaxhwrt B 线包清单（ImmortalWrt 25.12 APK / ImageBuilder）
# 对齐基线：路由器现网 566 包功能闭包（20261012-router-pkglist.txt）
# A 线对拍成果：78 显式包 → APK 生态映射（见设计文档）
# ============================================================
# 说明：
# - 官方仓 = ImmortalWrt 25.12 官方 feed（base/luci/packages/routing）
# - 第三方 = wukongdaily/apk 仓库（build25.sh 自动 clone 解包进 packages/）
# - 标注 [验证] 的包名需首构建时验证存在性，缺了按日志增删
# - 标注 [放弃] 的是 Kwrt 特供包，ImmortalWrt 生态无对应，已评估可弃
# ============================================================

CUSTOM_PACKAGES=""

# ---------- 代理全家（第三方：passwall2 系）----------
# 调度面板 + 核心引擎（SSR 已弃用不装；SS 保留给 passwall2 SS 节点）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-passwall2 luci-i18n-passwall2-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES xray-core sing-box hysteria geoview"
# shadowsocks-libev-ss-local/ss-redir 在 ImmortalWrt feed 不存在 → 已弃（SS 协议走 xray-core 出站）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-nft-socket kmod-nft-tproxy"

# ---------- Docker 全家（官方仓）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES docker dockerd containerd runc docker-compose"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-dockerman luci-i18n-dockerman-zh-cn"  # luci-lib-docker 在 ImmortalWrt 不存在（JS 版自带依赖）→ 已弃

# ---------- LuCI 面板（官方仓）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-acme luci-i18n-acme-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-ddns luci-i18n-ddns-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-nlbwmon luci-i18n-nlbwmon-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-nut luci-i18n-nut-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-upnp luci-i18n-upnp-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-statistics luci-i18n-statistics-zh-cn"
# luci-app-tcpdump 在 ImmortalWrt feed 不存在 → 已弃（tcpdump CLI 仍在）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-diskman luci-i18n-diskman-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-arpbind"            # [验证]
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-ssl luci-proto-wireguard"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-argon luci-app-argon-config luci-i18n-argon-config-zh-cn"

# ---------- 监控统计（官方仓）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES collectd collectd-mod-cpu collectd-mod-cpufreq collectd-mod-df"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES collectd-mod-dhcpleases collectd-mod-disk collectd-mod-dns"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES collectd-mod-ipstatistics collectd-mod-netlink collectd-mod-nut"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES collectd-mod-sensors collectd-mod-swap collectd-mod-thermal"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES lm-sensors"                  # [验证]

# ---------- UPS / NUT（官方仓）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES nut nut-driver-usbhid-ups nut-upsrw nut-upssched"

# ---------- 网络服务（官方仓）----------
# DDNS 2.8.x 结构：核心 + services 定义集 + 供应商扩展（CF/DNSPod 均为正式子包，实证于 immortalwrt/packages@openwrt-25.12 Makefile）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES ddns-scripts ddns-scripts-services ddns-scripts-cloudflare ddns-scripts-dnspod-v3"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES acme-acmesh acme-acmesh-dnsapi"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES miniupnpd-nftables socat haproxy ds-lite"

# ---------- 系统工具（官方仓）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES bash htop coremark fdisk bsdtar mtools pciutils usbutils tcpdump"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES bind-host block-mount automount nano iperf3 lm-sensors-detect"  # ip-tiny 与 passwall2 的 ip-full 冲突，ip-full 为超集已随 passwall2 装入
CUSTOM_PACKAGES="$CUSTOM_PACKAGES openssh-sftp-server zram-swap fuse-overlayfs"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES samba4-client"               # [验证]
CUSTOM_PACKAGES="$CUSTOM_PACKAGES grub2-bios-setup grub2-efi grub2-editenv"  # [验证] EFI 修复工具已拍板

# ---------- 内核模块（官方仓；NIC 驱动 = R2 Max 命根子）----------
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-wireguard kmod-tun kmod-inet-diag kmod-tcp-bbr kmod-zram kmod-fuse"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-nft-nat kmod-nft-fullcone"  # fullcone [验证]
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-e1000e kmod-igb kmod-igc kmod-ixgbe kmod-ixgbevf"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-bnx2 kmod-amazon-ena kmod-amd-xgbe kmod-dwmac-intel kmod-forcedeth"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-phy-broadcom"
# 通用 x86 兼容驱动（R2 Max 用不到但对齐现网基线）
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-atlantic kmod-bnx2x kmod-iavf kmod-mlx4-core kmod-mlx5-core kmod-mlxfw bnx2x-firmware"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-r8101 kmod-r8125 kmod-r8126"  # [验证]

# ============================================================
# [放弃清单] Kwrt 特供，ImmortalWrt 生态无对应（对拍验收逐项复核）
#   luci-app-turboacc   加速面板（核心 shortcut-fe 是 Kwrt 内核补丁不可移植；
#                       内核层由 kmod-tcp-bbr(BBR) + nft offload 覆盖）【定夺】
#   appfilter/luci-app-oaf/kmod-oaf 应用过滤（kmod-oaf 树外内核模块 ImageBuilder
#                       无法承载，ImmortalWrt feed 无此包；访问控制用 passwall2 分流
#                       + 防火墙规则替代；确有需要走未来源码编译支线）【定夺】
#   homebox / luci-app-netspeedtest / netspeedtest（iperf3 替代）【定夺】
#   shadowsocks-rust-sslocal / simple-obfs-client / v2ray-plugin（SS 与插件协议
#                       走 xray-core 出站）【定夺】
#   luci-app-webadmin / luci-app-log-viewer / luci-mod-rpc
#   my-default-settings（Kwrt 默认设置包）
#   luci-app-advancedplus / luci-app-syscontrol / luci-app-sysctl / luci-app-partexp / luci-app-fan 等
# ============================================================
