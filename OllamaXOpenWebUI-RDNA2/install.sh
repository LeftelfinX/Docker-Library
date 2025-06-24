#!/bin/bash

PORT=6500
CONTAINER=open-webui

echo "Starting Docker Compose on port $PORT..."
docker-compose up -d

echo "Waiting for container $CONTAINER to be healthy..."
while [[ "$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)" != "healthy" ]]; do
    echo "Container not healthy yet. Waiting 2 seconds..."
    sleep 2
done

echo "Container is healthy! Checking if port $PORT is accessible..."
if curl --silent --output /dev/null --fail http://localhost:$PORT; then
    echo "Port $PORT is accessible ✅"
else
    echo "Port $PORT is not responding ❌"
fi
