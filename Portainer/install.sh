#!/bin/bash

# 🛡️ UFW setup
PORTS=(9443 8000)
echo "🛡️  Starting UFW and Docker Compose setup..."

for PORT in "${PORTS[@]}"; do
    echo "🔍 Checking if port $PORT is already allowed through UFW..."
    if sudo ufw status | grep -q "${PORT}/tcp"; then
        echo "✅ Port $PORT is already allowed. Skipping."
    else
        echo "➕ Allowing port $PORT through UFW..."
        sudo ufw allow $PORT/tcp comment "Allow Docker service on port $PORT"
    fi
done

echo "🔄 Reloading UFW to apply changes..."
sudo ufw reload

# 🐳 Docker Compose
echo "🐳 Launching Docker Compose in the current directory..."
docker compose up -d

# 📦 Status
echo "📦 Showing container status:"
docker ps

# 🩺 Optional health check
echo "🩺 Checking Portainer on https://localhost:9443..."
curl -kIs https://localhost:9443 | head -n 1

echo "🎉 Setup complete!"
