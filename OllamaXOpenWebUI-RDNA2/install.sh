#!/bin/bash

PORT=6500

echo "Starting Docker Compose on port $PORT..."
docker-compose up -d

echo "Checking if the container is running..."
docker ps

echo "Testing if port $PORT is accessible (optional)..."
curl -v http://localhost:$PORT || echo "Port not responding (may still be starting)"