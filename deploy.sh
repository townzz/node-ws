#!/bin/bash
set -e

# ========== 颜色定义 ==========
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
RESET="\033[0m"

# ========== 第一步：自动检测用户名 ==========
cd ~ || { echo -e "${RED}❌ 无法切换到主目录${RESET}"; exit 1; }
USERNAME="$(basename "$PWD")"
echo -e "${CYAN}🧑 当前用户名:${RESET} ${YELLOW}$USERNAME${RESET}"

# ========== 第二步：自动检测最新域名目录，失败允许手动输入 ==========
DOMAIN_PATH=$(ls -1td /home/"$USERNAME"/domains/*/ 2>/dev/null | head -n 1)

if [ -z "$DOMAIN_PATH" ]; then
    echo -e "${YELLOW}⚠️ 未检测到域名目录，请手动输入${RESET}"
    read -p "请输入域名目录名称（如 be.yust.eu.org）: " DOMAIN
    DOMAIN_PATH="/home/$USERNAME/domains/$DOMAIN"
    mkdir -p "$DOMAIN_PATH"
else
    DOMAIN=$(basename "$DOMAIN_PATH")
    echo -e "${CYAN}🌐 自动检测到最新域名:${RESET} ${YELLOW}$DOMAIN${RESET}"
fi

if [ -z "$DOMAIN" ]; then
    read -p "请输入域名名称（如 be.yust.eu.org）: " DOMAIN
    DOMAIN_PATH="/home/$USERNAME/domains/$DOMAIN"
    mkdir -p "$DOMAIN_PATH"
fi

# ========== 第三步：输入或自动生成 UUID ==========
while true; do
    read -p "请输入 UUID（回车自动生成）: " UUID
    if [ -z "$UUID" ]; then
        if command -v uuidgen >/dev/null 2>&1; then
            UUID=$(uuidgen)
        else
            UUID=$(cat /proc/sys/kernel/random/uuid)
        fi
        echo -e "${YELLOW}⚙️ 自动生成 UUID:${RESET} ${MAGENTA}$UUID${RESET}"
        break
    elif [[ "$UUID" =~ ^[a-fA-F0-9-]{36}$ ]]; then
        echo -e "${CYAN}✅ 使用手动输入的 UUID: ${MAGENTA}$UUID${RESET}"
        break
    else
        echo -e "${RED}❌ UUID 格式不正确，请重新输入${RESET}"
    fi
done
# ========== 探针可选项 ==========
read -p "是否安装哪吒探针？[y/n] [n]: " input
input=${input:-n}
if [ "$input" != "n" ]; then
  read -p "输入 NEZHA_SERVER（如 nz.xxx.com:5555）: " nezha_server
  [ -z "$nezha_server" ] && { echo "❌ NEZHA_SERVER 不能为空"; exit 1; }

  read -p "输入 NEZHA_PORT（v1留空，v0用443/2096等）: " nezha_port
  read -p "输入 NEZHA_KEY（v1面板为 NZ_CLIENT_SECRET）: " nezha_key
  [ -z "$nezha_key" ] && { echo "❌ NEZHA_KEY 不能为空"; exit 1; }
fi

# ========== 基础路径设置 22.16.0 20.19.2 ==========
APP_ROOT="/home/$USERNAME/domains/$DOMAIN/public_html"
NODE_VERSION="22.16.0"
NODE_ENV_VERSION="22"
STARTUP_FILE="index.js"
NODE_VENV_BIN="/home/$USERNAME/nodevenv/domains/$DOMAIN/public_html/$NODE_ENV_VERSION/bin"
LOG_DIR="/home/$USERNAME/.npm/_logs"
RANDOM_PORT=$((RANDOM % 40001 + 20000))

# ========== 第四步：准备目录 ==========
echo "📁 创建应用目录: $APP_ROOT"
mkdir -p "$APP_ROOT"
cd "$APP_ROOT" || { echo "❌ 切换目录失败"; exit 1; }

# ========== 下载主程序 ==========
echo "📥 下载 index.js 和 cron.sh,下载ttyd"
curl -s -o "$APP_ROOT/index.js" "https://raw.githubusercontent.com/town95/node-ws/main/index.js"
curl -s -o "/home/$USERNAME/cron.sh" "https://raw.githubusercontent.com/town95/node-ws/main/cron.sh"
chmod +x /home/$USERNAME/cron.sh

# wget "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64"
# mv ttyd.x86_64 ttyd
# chmod +x ttyd

# ========== 替换变量 ==========
sed -i "s/1234.abc.com/$DOMAIN/g" "$APP_ROOT/index.js"
sed -i "s/3000;/$RANDOM_PORT;/g" "$APP_ROOT/index.js"
sed -i "s/de04add9-5c68-6bab-950c-08cd5320df33/$UUID/g" "$APP_ROOT/index.js"

# 探针变量替换
if [ "$input" = "y" ]; then
  sed -i "s/NEZHA_SERVER || ''/NEZHA_SERVER || '$nezha_server'/g" "$APP_ROOT/index.js"
  sed -i "s/NEZHA_PORT || ''/NEZHA_PORT || '$nezha_port'/g" "$APP_ROOT/index.js"
  sed -i "s/NEZHA_KEY || ''/NEZHA_KEY || '$nezha_key'/g" "$APP_ROOT/index.js"
  sed -i "s/nezha_check=false/nezha_check=true/g" "/home/$USERNAME/cron.sh"
fi

# ========== 写入 package.json ==========
cat > "$APP_ROOT/package.json" << EOF
{
  "name": "node-ws",
  "version": "1.0.0",
  "description": "Node.js Server",
  "main": "index.js",
  "author": "eoovve",
  "repository": "https://github.com/eoovve/node-ws",
  "license": "MIT",
  "private": false,
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "ws": "^8.14.2",
    "axios": "^1.6.2"
  },
  "engines": {
    "node": ">=14"
  }
}
EOF

# ========== 配置 CloudLinux Node 环境 ==========
echo "📄 复制 cloudlinux-selector 为本地 cf 命令"
cp /usr/sbin/cloudlinux-selector ./cf

echo "🗑️ 尝试销毁旧环境（如存在）"
./cf destroy \
  --json \
  --interpreter=nodejs \
  --user="$USERNAME" \
  --app-root="$APP_ROOT" || echo "⚠️ 无旧环境，跳过"

echo "⚙️ 创建新 Node 环境"
./cf create \
  --json \
  --interpreter=nodejs \
  --user="$USERNAME" \
  --app-root="$APP_ROOT" \
  --app-uri="/" \
  --version="$NODE_VERSION" \
  --app-mode=Production \
  --startup-file="$STARTUP_FILE"

# ========== 安装依赖 ==========
echo "📦 安装依赖 via npm"
"$NODE_VENV_BIN/npm" install

# ========== 清理日志 ==========
echo "🧹 清理 npm 日志"
[ -d "$LOG_DIR" ] && rm -f "$LOG_DIR"/*.log || echo "📂 无日志目录，跳过"


# ========== 设置定时任务 ==========
echo "⏱️ 写入 crontab 每分钟执行一次 cron.sh"
echo "*/1 * * * * cd /home/$USERNAME/public_html && /home/$USERNAME/cron.sh" > ./mycron
crontab ./mycron >/dev/null 2>&1
rm ./mycron

# ========== 结束提示 ==========
echo "✅ 应用部署完成！"
echo "🌐 域名: $DOMAIN"
echo "🧾 UUID: $UUID"
echo "📡 本地监听端口: $RANDOM_PORT"
[ "$input" = "y" ] && echo "📟 哪吒探针已配置: $nezha_server"

# ========== 自毁脚本 ==========
rm -- "$0"

