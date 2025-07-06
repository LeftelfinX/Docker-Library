#!/usr/bin/env bash

# Get current script folder (should contain docker-compose.yml)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get UID and GID
PUID=$(id -u)
PGID=$(id -g)

echo "Detected UID: $PUID"
echo "Detected GID: $PGID"

# Prompt for downloads folder
read -rp "Enter the FULL PATH to your downloads folder (e.g. /mnt/torrents): " DOWNLOADS_DIR

# Check if folder exists
if [ ! -d "$DOWNLOADS_DIR" ]; then
  echo "❌ Error: Directory '$DOWNLOADS_DIR' does not exist. Exiting."
  exit 1
fi

# Create .env
cat > "$PROJECT_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
DOWNLOADS_DIR=$DOWNLOADS_DIR
EOF

echo "✅ .env file created:"
echo "  PUID=$PUID"
echo "  PGID=$PGID"
echo "  DOWNLOADS_DIR=$DOWNLOADS_DIR"

# Create config directory
mkdir -p "$PROJECT_DIR/qbittorrent-config"

# Fix permissions
echo "🔑 Fixing permissions for config and downloads..."
sudo chown -R "$PUID:$PGID" "$PROJECT_DIR/qbittorrent-config" "$DOWNLOADS_DIR"

# Start qBittorrent
echo "🚀 Starting qBittorrent with Docker Compose..."
docker compose up -d

# Detect local IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ qBittorrent is now running!"
echo "🌐 Access the Web UI at: http://${SERVER_IP}:8080"
echo "🔑 Default credentials: admin/adminadmin (change this immediately!)"