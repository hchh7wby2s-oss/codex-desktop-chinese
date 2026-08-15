# Codex Desktop 中文汉化 (codex-zh)

一键切换 Codex Desktop (ChatGPT.app) 中文/英文界面，无需 VPN 或代理。

## 问题

Codex Desktop 内置了中文翻译资源，但因为 Statsig 服务器在国内无法访问，`enable_i18n` 永远为 `false`，中文无法加载。

## 解决方案

通过替换 `app.asar` 文件，将 i18n 功能强制启用，让 Codex 加载本地中文资源。

## 快速开始

### 方法一：手动替换

1. 下载 release 中对应版本的 `app-asar-zh.bin`
2. 关闭 Codex Desktop
3. 备份原始文件：
   ```bash
   sudo cp /Applications/ChatGPT.app/Contents/Resources/app.asar /Applications/ChatGPT.app/Contents/Resources/app.asar.bak
   ```
4. 替换：
   ```bash
   sudo cp app-asar-zh.bin /Applications/ChatGPT.app/Contents/Resources/app.asar
   ```
5. 重启 Codex Desktop

### 方法二：使用切换脚本

```bash
# 切换到中文
sudo bash scripts/switch-lang.sh zh

# 切换回英文
sudo bash scripts/switch-lang.sh en
```

## 版本兼容性

| Codex Desktop 版本 | 状态 |
|---|---|
| 26.810.50856 (macOS arm64) | ✅ 已验证 |

> 其他版本需要自行提取 `app.asar` 并修改 `enable_i18n` 配置。

## 原理

1. Codex 的 i18n 功能由 Statsig 配置 ID `72216192` 控制
2. 代码中 `a?.get('enable_i18n', false)` 读取配置
3. 由于 Statsig 无法连接，该值永远为 `false`
4. 补丁将此检查硬编码为 `true`
5. Codex 启动时加载本地 `zh-CN-jSttwbeY.js` 翻译文件

## 自行构建

```bash
# 1. 提取原始 app.asar
npx asar extract /Applications/ChatGPT.app/Contents/Resources/app.asar ./extracted

# 2. 修改 enable_i18n
perl -pi -e 's/a\?\.get\(`enable_i18n`,!1\)/!0/g' ./extracted/webview/assets/app-initial-*.js

# 3. 重新打包
node -e "require('asar').createPackage('./extracted', './app-patched.asar').then(() => console.log('done'))"
```

## 注意事项

- Codex Desktop 更新后会覆盖此补丁，需要重新替换
- 建议备份原始 `app.asar` 以防万一
- 切换脚本包含版本检查，版本不匹配时会警告

## License

MIT
