#!/usr/bin/env bash

set -e

echo "📦 Setting up HandBrake GUI environment..."

# Paths
HOME_DIR="$HOME"
DEST_DIR="$HOME_DIR/HandbrakeGUI"
MEDIA_DIR="$DEST_DIR/media"
CONFIG_DIR="$DEST_DIR/config"

# Create target directory
mkdir -p "$DEST_DIR"
cp Dockerfile docker-compose.yaml start.sh "$DEST_DIR"
chmod +x "$DEST_DIR/start.sh"

# Create media/output and config folders
mkdir -p "$MEDIA_DIR/output"
mkdir -p "$CONFIG_DIR"

# Detect current user
PUID=$(id -u)
PGID=$(id -g)

# Generate .env file
cat > "$DEST_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$MEDIA_DIR
CONFIG_DIR=$CONFIG_DIR
EOF

echo "✅ .env file created:"
echo "   MEDIA_DIR = $MEDIA_DIR"
echo "   OUTPUT    = $MEDIA_DIR/output"
echo "   CONFIG    = $CONFIG_DIR"
echo "   UID:GID   = $PUID:$PGID"

# Fix permissions
echo "🔐 Fixing permissions..."
sudo chown -R "$PUID:$PGID" "$DEST_DIR"

# Move to project folder
cd "$DEST_DIR"

# Build and start the container
echo "🔧 Building Docker container..."
docker compose build

echo "🚀 Starting Docker container..."
docker compose up -d

# Get IP
IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ Setup complete!"
echo "📂 Mount your SMB share manually to:"
echo "   $MEDIA_DIR"
echo "🌐 Access HandBrake GUI at: http://$IP:9999"
