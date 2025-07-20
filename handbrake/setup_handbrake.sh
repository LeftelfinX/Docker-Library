#!/usr/bin/env bash

# Get current script folder
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get UID and GID
PUID=$(id -u)
PGID=$(id -g)

echo "Detected UID: $PUID"
echo "Detected GID: $PGID"

# Prompt for full path to Input and Output folders
read -rp "Enter the FULL PATH to your HandBrake Input folder: " INPUT_DIR
read -rp "Enter the FULL PATH to your HandBrake Output folder: " OUTPUT_DIR

# Automatically set Config folder to ~/handbrake/config
CONFIG_DIR="$HOME/handbrake/config"
mkdir -p "$CONFIG_DIR"

# Validate input/output folders
for DIR in "$INPUT_DIR" "$OUTPUT_DIR"; do
  if [ ! -d "$DIR" ]; then
    echo "❌ Error: Directory '$DIR' does not exist. Exiting."
    exit 1
  fi
done

# Create .env file
cat > "$PROJECT_DIR/.env" <<EOF
PUID=$PUID
PGID=$PGID
INPUT_DIR=$INPUT_DIR
OUTPUT_DIR=$OUTPUT_DIR
CONFIG_DIR=$CONFIG_DIR
EOF

echo "✅ .env file created:"
echo "  PUID=$PUID"
echo "  PGID=$PGID"
echo "  INPUT_DIR=$INPUT_DIR"
echo "  OUTPUT_DIR=$OUTPUT_DIR"
echo "  CONFIG_DIR=$CONFIG_DIR"

# Fix permissions
echo "🔑 Fixing permissions..."
sudo chown -R "$PUID:$PGID" "$INPUT_DIR" "$OUTPUT_DIR" "$CONFIG_DIR"

# Start HandBrake
echo "🚀 Starting HandBrake with Docker Compose..."
docker compose up -d

# Detect local IP
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "✅ HandBrake is now running!"
echo "🌐 Access the Web UI at: http://${SERVER_IP}:5800"
