#!/bin/bash

# Load token from .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ .env file not found!"
  exit 1
fi

# Check if token is present
if [ -z "$WATCHTOWER_TOKEN" ]; then
  echo "❌ WATCHTOWER_TOKEN not set in .env"
  exit 1
fi

# Load hosts from file
HOSTS_FILE=".hosts"
if [ ! -f "$HOSTS_FILE" ]; then
  echo "❌ $HOSTS_FILE not found!"
  exit 1
fi
HOSTS=($(grep -v '^#' "$HOSTS_FILE"))
PORT=18080


# Trigger Watchtower updates
for HOST in "${HOSTS[@]}"; do
  echo "🔁 Triggering Watchtower on $HOST..."
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST http://$HOST:$PORT/v1/update \
    -H "Authorization: Bearer $WATCHTOWER_TOKEN")

  if [ "$RESPONSE" = "200" ]; then
    echo "✅ Success: $HOST"
  else
    echo "❌ Failed: $HOST (HTTP $RESPONSE)"
  fi
done
