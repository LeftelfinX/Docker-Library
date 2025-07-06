#!/usr/bin/env bash

# Get current script folder (should contain docker-compose.yaml)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target folder in user home
TARGET_DIR="$HOME/jellyfin"

echo "📁 Creating Jellyfin folder at: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

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

# Create .env in target folder
cat > "$TARGET_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$MEDIA_DIR
EOF

echo "✅ .env file created in $TARGET_DIR:"
echo "  PUID=$PUID"
echo "  PGID=$PGID"
echo "  MEDIA_DIR=$MEDIA_DIR"

# Copy docker-compose.yaml
cp "$PROJECT_DIR/docker-compose.yaml" "$TARGET_DIR/"

# Make sure config and cache exist in target
mkdir -p "$TARGET_DIR/config" "$TARGET_DIR/cache"

# Fix permissions
echo "🔑 Fixing permissions for config, cache, and media..."
sudo chown -R "$PUID:$PGID" "$TARGET_DIR/config" "$TARGET_DIR/cache" "$MEDIA_DIR"

# Change to target directory
cd "$TARGET_DIR" || exit 1

# Start Jellyfin
echo "🚀 Starting Jellyfin with Docker Compose..."
docker compose up -d

# Detect local IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ Jellyfin is now running!"
echo "🌐 Access it at: http://${SERVER_IP}:8096"
