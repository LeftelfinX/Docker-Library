#!/bin/bash
set -e

echo "🛠️  Setting up HandBrake GUI Docker environment..."

# Define install path
INSTALL_DIR="$HOME/handbrake"

# Copy current folder contents into ~/handbrake/
echo "📁 Copying files to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cp -r . "$INSTALL_DIR"

cd "$INSTALL_DIR"

# Ask user for media folder path
read -rp "📂 Enter full path to your media folder (input/output): " MEDIA_PATH

# Ensure media folder exists and is accessible
if [ ! -d "$MEDIA_PATH" ]; then
  echo "❌ Directory '$MEDIA_PATH' does not exist. Creating it..."
  mkdir -p "$MEDIA_PATH"
fi
chmod -R a+rw "$MEDIA_PATH"

# Create persistent config folder for HandBrake
CONFIG_PATH="$INSTALL_DIR/config/ghb"
mkdir -p "$CONFIG_PATH"
chmod -R a+rw "$CONFIG_PATH"

# Save media path to .env for docker-compose
echo "MEDIA_PATH=$MEDIA_PATH" > .env

# Build and start the container
echo "🚀 Launching Docker Compose..."
docker-compose up -d --build

# Detect local IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
  SERVER_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')
fi

echo "✅ Setup complete!"
echo "🌐 Open http://$SERVER_IP:8080/vnc.html?resize=scale to use HandBrake GUI."
