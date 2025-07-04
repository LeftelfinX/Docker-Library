#!/usr/bin/env bash

# Get current script folder (should contain docker-compose.yml)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get UID and GID
PUID=$(id -u)
PGID=$(id -g)

echo "Detected UID: $PUID"
echo "Detected GID: $PGID"

# Prompt for full path to media folder
read -rp "Enter the FULL PATH to your media folder (e.g. /mnt/Watch-Library): " MEDIA_DIR

# Check if folder exists
if [ ! -d "$MEDIA_DIR" ]; then
  echo "❌ Error: Directory '$MEDIA_DIR' does not exist. Exiting."
  exit 1
fi

# Create .env
cat > "$PROJECT_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$MEDIA_DIR
EOF

echo "✅ .env file created:"
echo "  PUID=$PUID"
echo "  PGID=$PGID"
echo "  MEDIA_DIR=$MEDIA_DIR"

# Make sure config and cache directories exist
mkdir -p "$PROJECT_DIR/config" "$PROJECT_DIR/cache"

# Fix permissions
echo "🔑 Fixing permissions for config, cache, and media..."
sudo chown -R "$PUID:$PGID" "$PROJECT_DIR/config" "$PROJECT_DIR/cache" "$MEDIA_DIR"

# Start Jellyfin
echo "🚀 Starting Jellyfin with Docker Compose..."
docker compose up -d

# Detect local IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ Jellyfin is now running!"
echo "🌐 Access it at: http://${SERVER_IP}:8096"
