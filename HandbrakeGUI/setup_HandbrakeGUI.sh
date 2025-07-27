#!/usr/bin/env bash

# Set project directory
PROJECT_DIR="$HOME/HandbrakeGUI"

# Create directory and copy files
mkdir -p "$PROJECT_DIR"
cp -r . "$PROJECT_DIR"

# Set working directory
cd "$PROJECT_DIR" || exit 1

# Detect user info
PUID=$(id -u)
PGID=$(id -g)

# Create media and output dirs
mkdir -p "$PROJECT_DIR/media/output"
mkdir -p "$PROJECT_DIR/config"

# Write .env file
cat > .env <<EOF
PUID=$PUID
PGID=$PGID
MEDIA_DIR=$PROJECT_DIR/media
CONFIG_DIR=$PROJECT_DIR/config
EOF

# Set permissions
sudo chown -R "$PUID:$PGID" "$PROJECT_DIR"

# Build and start
docker compose build
docker compose up -d

# Print access info
IP=$(hostname -I | awk '{print $1}')
echo "🌐 HandBrake GUI accessible at: http://$IP:9999"
