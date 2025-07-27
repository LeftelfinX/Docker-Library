#!/bin/bash

# Start 1080p virtual display
Xvfb :1 -screen 0 1920x1080x24 &

export DISPLAY=:1

# Start window manager
fluxbox &

# Start VNC server
x11vnc -display :1 -nopw -forever -shared -rfbport 5901 &

# Start noVNC bridge
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

# Show media mount and config
echo "📁 Media directory: ${MEDIA_DIR:-/home/handbrake/media}"
echo "⚙️  Config directory: /home/handbrake/.config/ghb"

# Launch HandBrake GUI
ghb
