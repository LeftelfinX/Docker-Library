#!/bin/bash

PORT=4533
CONTAINER=navidrome

echo "Starting Docker Compose on port $PORT..."
docker-compose up -d

echo "Waiting for container $CONTAINER to be healthy..."
while [[ "$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)" != "healthy" ]]; do
    echo "Container not healthy yet. Waiting 2 seconds..."
    sleep 2
done

echo "Container is healthy! Checking if port $PORT is accessible..."
curl -v http://localhost:$PORT || echo "Port not responding (unexpected)"
