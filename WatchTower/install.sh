#!/bin/bash

# === CONFIGURATION ===
EXTERNAL_PORT=18080         # The external port you want to expose
# INTERNAL_PORT=8080          # Internal container port (Watchtower's API)
DOCKER_COMPOSE_FILE="docker-compose.yaml"

# === IPTABLES RULE ===
echo "🔍 Checking if port $EXTERNAL_PORT is already open for Docker..."
if sudo iptables -L DOCKER -n | grep -q "$EXTERNAL_PORT"; then
    echo "✅ Port $EXTERNAL_PORT already allowed for Docker."
else
    echo "➕ Adding rule to allow traffic on port $EXTERNAL_PORT..."
    sudo iptables -I DOCKER -p tcp --dport $EXTERNAL_PORT -j ACCEPT
fi

# === CONFIRM IPTABLES RULE ===
echo "📜 Current Docker iptables rules for port $EXTERNAL_PORT:"
sudo iptables -L DOCKER -n --line-numbers | grep "$EXTERNAL_PORT" || echo "❌ Rule not found, something went wrong."

# === RUN DOCKER COMPOSE ===
echo "🐳 Running Docker Compose from: $DOCKER_COMPOSE_FILE"
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "❌ $DOCKER_COMPOSE_FILE not found! Exiting."
    exit 1
fi

docker compose up -d

# === SHOW CONTAINER STATUS ===
echo "📦 Docker container status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
