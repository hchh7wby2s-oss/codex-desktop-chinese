# Codex Desktop 中文汉化 (codex-zh)

一键切换 Codex Desktop (ChatGPT.app) 中文/英文界面，无需 VPN 或代理。

> **下载地址：** https://github.com/hchh7wby2s-oss/codex-desktop-chinese/releases/latest

## 问题

Codex Desktop 内置了中文翻译资源（12270 条），但因 Statsig 服务器在国内无法访问，enable_i18n 永远为 false，中文无法加载。

## 解决方案

通过替换 app.asar 文件，将 i18n 功能强制启用，让 Codex 加载本地中文资源。

## 快速开始

1. 从 GitHub Release 下载 codex-zh-skill-full.zip
2. 解压：unzip codex-zh-skill-full.zip && cd codex-zh
3. 切换中文：sudo bash scripts/switch-lang.sh zh
4. 切换英文：sudo bash scripts/switch-lang.sh en
5. 重启 Codex Desktop 生效

## 自行构建

如果你的 Codex 版本不同：

1. 提取：npx asar extract /Applications/ChatGPT.app/Contents/Resources/app.asar ./extracted
2. 修改：perl -pi -e 's/a?.get(`enable_i18n`,!1)/!0/g' ./extracted/webview/assets/app-initial-*.js
3. 打包：node -e "require('asar').createPackage('./extracted', './app-patched.asar').then(()=>console.log('done'))"

## License

MIT
