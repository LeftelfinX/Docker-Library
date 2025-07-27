#!/bin/bash

# Create runtime dirs
mkdir -p /run/user/1000/xpra
mkdir -p ~/.xpra

# Fix XDG runtime
export XDG_RUNTIME_DIR=/run/user/1000

# Start Xpra with HTML5 WebSocket server
xpra start :0 \
  --bind-tcp=0.0.0.0:10000 \
  --html=on \
  --daemon=no \
  --start-child=handbrake \
  --exit-with-children \
  --no-mdns \
  --no-notifications \
  --no-pulseaudio \
  --no-systemd-run
