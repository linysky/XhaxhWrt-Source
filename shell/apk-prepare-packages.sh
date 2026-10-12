#!/bin/sh
# 收集第三方 .apk 到 ImageBuilder 的 packages/ 目录
# 基于 wukongdaily/ImmortalWrt-ImageBuilder 的 apk-prepare-packages.sh（MIT）
# 改动：仅保留 .apk 收集（.run 自解压链路暂不需要）

BASE_DIR="extra-packages"
TARGET_DIR="packages"

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# extra-packages/<任意子目录>/*.apk（仅一级子目录）
find "$BASE_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.apk" \
  -exec echo "👉 Found:" {} \; \
  -exec cp -v {} "$TARGET_DIR"/ \;

# extra-packages/ 根下的散装 .apk
find "$BASE_DIR" -maxdepth 1 -type f -name "*.apk" \
  -exec cp -v {} "$TARGET_DIR"/ \;

echo "✅ 所有 .apk 已整理至 $TARGET_DIR/"
