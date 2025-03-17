#!/bin/bash

PORT=6500

# Check if the rule already exists
echo "Checking if port $PORT is already allowed for Docker..."
if sudo iptables -L DOCKER -n | grep -q "$PORT"; then
    echo "Port $PORT is already open. Skipping rule addition."
else
    echo "Allowing traffic on port $PORT for Docker..."
    sudo iptables -I DOCKER -p tcp --dport $PORT -j ACCEPT
fi

# Confirm the rule is in place
echo "Current rules for port $PORT:"
sudo iptables -L DOCKER -n --line-numbers | grep "$PORT" || echo "No rule found, something went wrong."

# Run Docker Compose
echo "Running Docker Compose in the current directory..."
docker-compose up -d

# Show the status of running containers
echo "Showing container status:"
docker ps
