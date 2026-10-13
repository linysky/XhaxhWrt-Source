# XhaxhWrt-Source @ immortal-25.12

> ⚠️ **本分支已归档（2026-10-13）**：ImmortalWrt APK 线完成全部验证（终版 539 包、
> 功能闭包清零）但 Kwrt 特供生态不可移植，主人定案升级采用 A 线 Kwrt v3 镜像。
> 分支保留备查/重启用，不再主动迭代。

Xhaxhwrt 自建固件线（B 线）——**ImmortalWrt 25.12 APK / ImageBuilder** 底座。

与 `25.12` 分支（Kwrt 源码编译线，已封存）的区别：本分支用官方 ImmortalWrt
ImageBuilder Docker 镜像构建，**分钟级出货、无源码编译**；包管理为 apk。

## 快速构建

Actions → `Build Xhaxhwrt x86-64 (ImmortalWrt 25.12 APK)` → Run workflow：

| 输入 | 默认 | 说明 |
|---|---|---|
| luci_version | 25.12.2 | ImmortalWrt 版本（25.12.0 有口碑坑） |
| custom_router_ip | **10.0.0.1** | 与现网一致，切过来即用 |
| profile | 6G | overlay 大小 |
| include_docker | yes | Docker 全家 |

出货：Release `autobuild-x86-64-imm`，附 `squashfs-combined-efi.img.gz` + sha256。

## 目录

```
.github/workflows/build-x86-64-25.12.yml   构建工作流
x86-64/build25.sh                          ImageBuilder 构建脚本
shell/apk-custom-packages.sh               包清单（对齐路由器 566 包基线）★
shell/apk-prepare-packages.sh              第三方 .apk 收集
files/                                     铺进固件的覆盖文件（去品牌 + 网络兜底）
reference/                                 参考基线（wukongdaily/ImmortalWrt-ImageBuilder）
```

## 包清单

`shell/apk-custom-packages.sh` 是唯一事实源，按路由器现网 566 包功能闭包对齐
（passwall2/xray-core 第三方 feed，Docker/监控/NUT/ACME 官方 feed）。
标注 `# [验证]` 的包名首构建时核验存在性。

## 去品牌

files/ 直接覆盖 `etc/os-release`、`usr/lib/os-release`、`etc/openwrt_release`、
`etc/banner`，品牌 Xhaxhwrt / power by xlin。

## 参考致谢

构建机制基于 [wukongdaily/ImmortalWrt-ImageBuilder](https://github.com/wukongdaily/ImmortalWrt-ImageBuilder)（MIT）。
