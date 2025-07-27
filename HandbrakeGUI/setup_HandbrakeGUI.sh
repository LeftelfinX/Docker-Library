#!/bin/bash

# Get current user info
PUID=$(id -u)
PGID=$(id -g)
USERNAME=$(whoami)
HOME_DIR="/home/$USERNAME"

# Define base dir
BASE_DIR="$HOME_DIR/HandbrakeGUI"
MEDIA_DIR="$BASE_DIR/media"
OUTPUT_DIR="$MEDIA_DIR/output"

echo "📁 Creating folders..."
mkdir -p "$MEDIA_DIR"
mkdir -p "$OUTPUT_DIR"

# Copy all docker files to HandbrakeGUI folder
echo "📦 Copying files to $BASE_DIR..."
cp Dockerfile "$BASE_DIR/"
cp docker-compose.yaml "$BASE_DIR/"
cp entrypoint.sh "$BASE_DIR/"
cp xpra.conf "$BASE_DIR/"

# Create .env file
echo "⚙️ Creating .env..."
cat > "$BASE_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$MEDIA_DIR
EOF

# Change to project dir
cd "$BASE_DIR" || exit

# Fix permissions
echo "🔐 Setting permissions..."
chown -R "$PUID:$PGID" "$BASE_DIR"

# Build and start
echo "🔨 Building docker image..."
docker compose build

echo "🚀 Starting container..."
docker compose up -d

# Show IP address
IP=$(hostname -I | awk '{print $1}')
echo "🌐 Access the HandBrake GUI via your browser:"
echo "    http://${IP}:10000/"
