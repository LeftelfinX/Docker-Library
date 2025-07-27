#!/bin/bash

# Adjust UID/GID if passed
if [[ -n "$PUID" && -n "$PGID" ]]; then
  echo "🔧 Setting user UID=$PUID and GID=$PGID"
  usermod -u "$PUID" user 2>/dev/null || true
  groupmod -g "$PGID" user 2>/dev/null || true
fi

# Start Xpra with HandBrake
echo "🚀 Launching HandBrake GUI (browser access)"
xpra start :10 \
  --start="handbrake --working-directory=/config/media/output" \
  --bind-tcp=0.0.0.0:14500 \
  --html=on \
  --daemon=no
