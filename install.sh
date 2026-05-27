#!/usr/bin/env bash
set -e

APP_DIR="/opt/wg-easy-amneziawg"

read -p "Server IP / INIT_HOST: " INIT_HOST
read -p "Admin username [admin]: " INIT_USERNAME
INIT_USERNAME=${INIT_USERNAME:-admin}

read -s -p "Admin password: " INIT_PASSWORD
echo

read -p "VPN UDP port [51820]: " INIT_PORT
INIT_PORT=${INIT_PORT:-51820}

read -p "Panel TCP port [51821]: " PANEL_PORT
PANEL_PORT=${PANEL_PORT:-51821}

read -p "DNS [1.1.1.1,8.8.8.8]: " INIT_DNS
INIT_DNS=${INIT_DNS:-1.1.1.1,8.8.8.8}

apt update
apt install -y curl wget sudo gnupg2 ca-certificates lsb-release dkms linux-headers-$(uname -r)

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

systemctl enable --now docker

if ! command -v awg >/dev/null 2>&1; then
  add-apt-repository -y ppa:amnezia/ppa
  apt update
  apt install -y amneziawg amneziawg-tools
fi

modprobe amneziawg || true

mkdir -p "$APP_DIR"
cp docker-compose.yml "$APP_DIR/docker-compose.yml"

cat > "$APP_DIR/.env" <<ENV
INIT_HOST=$INIT_HOST
INIT_USERNAME=$INIT_USERNAME
INIT_PASSWORD=$INIT_PASSWORD
INIT_PORT=$INIT_PORT
PANEL_PORT=$PANEL_PORT
INIT_DNS=$INIT_DNS
ENV

cd "$APP_DIR"
docker compose up -d

echo
echo "Done."
echo "Panel: http://$INIT_HOST:$PANEL_PORT"
echo "Login: $INIT_USERNAME"
