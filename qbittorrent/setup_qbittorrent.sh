#!/usr/bin/env bash

# Get current script folder (should contain docker-compose.yml)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target folder in user home
TARGET_DIR="$HOME/qbittorrent"

echo "📁 Creating qBittorrent folder at: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

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

# Create .env in target folder
cat > "$TARGET_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
DOWNLOADS_DIR=$DOWNLOADS_DIR
EOF

echo "✅ .env file created in $TARGET_DIR:"
echo "  PUID=$PUID"
echo "  PGID=$PGID"
echo "  DOWNLOADS_DIR=$DOWNLOADS_DIR"

# Copy docker-compose.yaml
cp "$PROJECT_DIR/docker-compose.yaml" "$TARGET_DIR/"

# Make sure qbittorrent-config folder exists in target
mkdir -p "$TARGET_DIR/qbittorrent-config"

# Fix permissions
echo "🔑 Fixing permissions for config and downloads..."
sudo chown -R "$PUID:$PGID" "$TARGET_DIR/qbittorrent-config" "$DOWNLOADS_DIR"

# Change to target directory
cd "$TARGET_DIR" || exit 1

# Start qBittorrent
echo "🚀 Starting qBittorrent with Docker Compose..."
docker compose up -d

# Detect local IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ qBittorrent is now running!"
echo "🌐 Access the Web UI at: http://${SERVER_IP}:8080"
echo "🔑 Default credentials: admin/adminadmin (change this immediately!)"
