#!/bin/bash

set -e

COMPOSE_FILE="docker-compose.yaml"

if [[ ! -f $COMPOSE_FILE ]]; then
  echo "❌ Error: $COMPOSE_FILE not found. Make sure it's in the same directory."
  exit 1
fi

echo "🚀 Running one-time Watchtower update..."
docker compose -f $COMPOSE_FILE up --remove-orphans --abort-on-container-exit

echo "🧹 Cleaning up Watchtower container..."
docker compose -f $COMPOSE_FILE down --remove-orphans

echo "✅ Watchtower one-time update complete."
