#!/bin/bash
# Xhaxhwrt B 线构建脚本（ImmortalWrt 25.12 APK ImageBuilder）
# 基于 wukongdaily/ImmortalWrt-ImageBuilder x86-64/build25.sh（MIT）改造
# 调用约定（workflow 传入环境变量）：
#   PROFILE        = ROOTFS 分区大小 MB（默认 6144）
#   INCLUDE_DOCKER = yes|no

source shell/apk-custom-packages.sh
echo "📦 对齐路由器的包清单: $CUSTOM_PACKAGES"

FILES_DIR="/home/build/immortalwrt/files"
mkdir -p "$FILES_DIR/etc/config"

# ---------- 第三方 .apk 收集 ----------
if [ -z "$CUSTOM_PACKAGES" ]; then
  echo "⚪️ 包清单为空"
else
  echo "🔄 同步第三方 apk 仓库（wukongdaily/apk）..."
  git clone --depth=1 https://github.com/wukongdaily/apk.git /tmp/store-apk-repo \
    || echo "⚠️ 第三方仓库 clone 失败，仅用官方 feed"
  mkdir -p /home/build/immortalwrt/extra-packages
  [ -d /tmp/store-apk-repo/run/x86 ] && cp -r /tmp/store-apk-repo/run/x86/* /home/build/immortalwrt/extra-packages/ 2>/dev/null
  sh shell/apk-prepare-packages.sh
  ls -lah /home/build/immortalwrt/packages/ 2>/dev/null
fi

# ---------- Docker 可裁剪 ----------
PACKAGES="$CUSTOM_PACKAGES"
if [ "$INCLUDE_DOCKER" != "yes" ]; then
  # 从清单里剔除 Docker 全家
  for p in docker dockerd containerd runc docker-compose luci-app-dockerman luci-i18n-dockerman-zh-cn luci-lib-docker; do
    PACKAGES=$(echo "$PACKAGES" | sed "s/\b$p\b//g")
  done
  echo "❎ 未包含 Docker"
else
  echo "✅ 包含 Docker 全家"
fi

# ---------- 构建 ----------
echo "$(date '+%F %T') - Building image..."
echo "ROOTFS_PARTSIZE=${PROFILE:-6144} MB"
make image PROFILE="generic" \
  PACKAGES="$PACKAGES" \
  FILES="$FILES_DIR" \
  ROOTFS_PARTSIZE="${PROFILE:-6144}"

if [ $? -ne 0 ]; then
  echo "$(date '+%F %T') - ❌ Build failed!"
  exit 1
fi
echo "$(date '+%F %T') - ✅ Build completed."
ls -lah /home/build/immortalwrt/bin/targets/x86/64/ | grep -E 'img|apk' || true
