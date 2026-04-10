# EterUl

[English](README_en.md) | 中文

已停止维护，后续将是新的一代....
（Bug严重多，对不起，放弃了）

一个为 Android Termux 用户设计的 proot 管理工具，也可用于 Linux 服务器。

## 功能特性

- Android/Termux 支持 - 专为 Termux 优化的 proot 管理
- Linux 服务器支持 - 支持在 Linux 服务器上运行
- Minecraft 服务器 - 快速部署 Java 版 Minecraft 服务器
- 性能优化 - 内置 proot 优化脚本
- 自动更新 - 支持自动检查更新

## 系统要求

### Android (Termux)

- Android 7.0 或更高版本
- Termux 最新版
- 存储空间至少 2GB

### Linux 服务器

- Ubuntu 18.04+ / Debian 10+ / CentOS 7+
- 1GB+ RAM
- 5GB+ 可用磁盘空间

## 安装

### 快速安装 (Termux)

```bash
# 安装必要组件
pkg update
pkg install git curl wget

# 克隆仓库
git clone https://github.com/EterUltimate/EterUl.git

# 运行安装
bash ~/EterUl/eterui.sh
```

### 快速安装 (Linux)

```bash
# 安装必要组件 (Debian/Ubuntu)
apt-get update
apt-get install -y git curl wget

# 克隆仓库
git clone https://github.com/EterUltimate/EterUl.git

# 运行安装
sudo bash ~/EterUl/eterui.sh
```

## 使用方法

### 命令行选项

| 参数 | 说明 |
|------|------|
| -h, --help | 显示帮助信息 |
| -s, --start | 开始安装/配置 |
| -u, --update | 更新 EterUl |
| --debug | 调试模式 |

### 交互式菜单

```bash
# 启动交互式菜单
bash eterui.sh
```

## 项目结构

```
EterUl/
├── eterui.sh              # 主程序入口
├── config/              # 配置文件目录
│   ├── config.sh        # 用户配置
│   └── version          # 版本信息
├── function/            # 核心功能函数
│   ├── update.sh       # 更新功能
│   ├── proot_optimization  # proot 优化
│   └── proot_proc/     # proot 进程模拟
├── local/
│   ├── Android/        # Android/Termux 专用
│   └── Linux/          # Linux 服务器专用
└── README.md           # 本文档
```

## 配置

配置文件位于 ~/EterUl/config/config.sh（Termux）或 /opt/EterUl/config/config.sh（Linux）。

### 可配置项

- git - Git 镜像源
- rawgit - 原始文件镜像源
- auto_upgrade - 自动更新开关 (true/false)
- QQbot - QQ 机器人配置

## 常见问题

### Q: 安装失败怎么办？

A: 请确保已安装 git, curl, wget。如果没有网络，请配置镜像源。

### Q: proot 运行缓慢？

A: 运行内置优化脚本：bash function/proot_optimization

### Q: 如何更新到最新版本？

A: 运行 bash eterui.sh -u

## 贡献指南

欢迎提交 Issue 和 Pull Request！

请查看 CONTRIBUTING.md 了解贡献流程。

## 许可证

本项目采用 MIT 许可证 - 查看 LICENSE 了解详情。

## 免责声明

- 本工具仅供学习交流使用
- 请勿用于商业用途
- 使用本工具造成的后果由用户自行承担

Star 本项目以示支持！

2024-2026 EterUl Project
