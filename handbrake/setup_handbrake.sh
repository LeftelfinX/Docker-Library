#!/usr/bin/env bash

# Get current script directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect current user
PUID=$(id -u)
PGID=$(id -g)
USERNAME=$(whoami)
HOME_DIR=$(eval echo "~$USERNAME")

echo "👤 Detected user: $USERNAME (UID: $PUID, GID: $PGID)"

# Prompt for a single media directory
read -rp "📂 Enter the FULL PATH to your HandBrake media folder (input & output): " MEDIA_DIR

if [ ! -d "$MEDIA_DIR" ]; then
  echo "❌ Error: Directory '$MEDIA_DIR' does not exist. Exiting."
  exit 1
fi

# Define config folder
CONFIG_DIR="$HOME_DIR/handbrake/config"
mkdir -p "$CONFIG_DIR"

# Create .env file
cat > "$PROJECT_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$MEDIA_DIR
CONFIG_DIR=$CONFIG_DIR
EOF

echo "✅ .env file created:"
echo "  MEDIA_DIR=$MEDIA_DIR"
echo "  CONFIG_DIR=$CONFIG_DIR"

# Set correct ownership
echo "🔐 Fixing permissions..."
sudo chown -R "$PUID:$PGID" "$CONFIG_DIR" "$MEDIA_DIR"

# Start the docker compose stack
echo "🚀 Starting HandBrake Web stack..."
docker compose up -d

# Get local IP
IP=$(hostname -I | awk '{print $1}')
echo "🌐 Access the Web UI at: http://${IP}:9999"
