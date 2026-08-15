#!/bin/bash
# Codex Desktop 中英文切换脚本（带版本检查）
# 用法: sudo bash switch-lang.sh [zh|en]

LANG_OPT="${1:-}"
DATA_DIR="$(cd "$(dirname "$0")/../data" && pwd)"
APP_ASAR="/Applications/ChatGPT.app/Contents/Resources/app.asar"
VERSION_FILE="$DATA_DIR/asar-version.txt"

# 获取当前安装的 Codex 版本
get_app_version() {
    defaults read /Applications/ChatGPT.app/Contents/Info.plist CFBundleShortVersionString 2>/dev/null
}

# 从备份 asar 获取版本（通过 package.json）
get_asar_version() {
    local asar_file="$1"
    if command -v node &>/dev/null; then
        node -e "
const fs = require('fs');
const buf = fs.readFileSync('$asar_file');
const header = JSON.parse(buf.slice(16, 16 + buf.readUInt32LE(4)).toString());
const pkgEntry = header.files['package.json'];
if (!pkgEntry) process.exit(1);
const data = buf.slice(pkgEntry.offset, pkgEntry.offset + pkgEntry.size).toString();
console.log(JSON.parse(data).version || 'unknown');
" 2>/dev/null
    fi
}

if [ "$LANG_OPT" != "zh" ] && [ "$LANG_OPT" != "en" ]; then
    echo "用法: sudo bash $0 [zh|en]"
    echo "  zh - 切换到中文"
    echo "  en - 切换到英文"
    exit 1
fi

if [ ! -f "$APP_ASAR" ]; then
    echo "错误: 未找到 ChatGPT.app"
    exit 1
fi

# 版本检查
APP_VER=$(get_app_version)
if [ -f "$VERSION_FILE" ]; then
    ASAR_VER=$(cat "$VERSION_FILE")
else
    ASAR_VER=$(get_asar_version "$DATA_DIR/app-asar-en.bin")
    if [ -n "$ASAR_VER" ]; then
        echo "$ASAR_VER" > "$VERSION_FILE"
    fi
fi

echo "Codex 版本: $APP_VER"
echo "备份 asar 版本: $ASAR_VER"

if [ -n "$APP_VER" ] && [ -n "$ASAR_VER" ] && [ "$APP_VER" != "$ASAR_VER" ]; then
    echo ""
    echo "⚠️  版本不匹配！当前 Codex ($APP_VER) ≠ 备份 asar ($ASAR_VER)"
    echo "替换后可能出现兼容性问题。"
    echo ""
    read -p "是否继续替换？(y/N): " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo "已取消。"
        exit 0
    fi
fi

# 执行替换
if [ "$LANG_OPT" = "zh" ]; then
    SRC="$DATA_DIR/app-asar-zh.bin"
    echo "切换到中文..."
else
    SRC="$DATA_DIR/app-asar-en.bin"
    echo "切换到英文..."
fi

if [ ! -f "$SRC" ]; then
    echo "错误: 未找到 $SRC"
    exit 1
fi

cp "$SRC" "$APP_ASAR"
if [ $? -eq 0 ]; then
    echo "✅ 切换成功！请重启 Codex Desktop 生效。"
else
    echo "❌ 切换失败，可能需要 sudo 权限"
    echo "请运行: sudo bash $0 $LANG_OPT"
fi
