---
name: codex-zh
description: "切换 Codex Desktop 界面语言为中文或英文。当用户要求切换 Codex 的语言、汉化、变中文、变英文、Chinese locale 时使用此 skill。"
---

# Codex Desktop 中英文切换

此 skill 管理 Codex Desktop (ChatGPT.app) 的界面语言切换。

## 原理

Codex Desktop 内置了中文翻译资源（zh-CN），但因为 Statsig 服务器在国内无法访问，`enable_i18n` 配置永远为 `false`，导致中文不加载。此 skill 通过替换 app.asar 文件来强制启用中文。

## 切换语言

运行切换脚本（需要 sudo 权限）：

```bash
# 切换到中文
sudo bash ~/.codex/skills/codex-zh/scripts/switch-lang.sh zh

# 切换到英文
sudo bash ~/.codex/skills/codex-zh/scripts/switch-lang.sh en
```

切换后需要**重启 Codex Desktop** 才能生效。

## 文件说明

- `data/app-asar-zh.bin` - 中文版 app.asar（已启用 i18n）
- `data/app-asar-en.bin` - 英文版 app.asar（原始版本）
- `scripts/switch-lang.sh` - 切换脚本

## 注意事项

- Codex Desktop 更新后会覆盖此补丁，需要重新运行切换脚本
- 切换前会自动覆盖当前的 app.asar
- 原始文件已备份在 `data/` 目录中
