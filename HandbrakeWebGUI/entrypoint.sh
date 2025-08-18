#!/bin/bash
set -e

# Start virtual display
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99

# Wait for Xvfb to be ready
sleep 2

# Start VNC server (on all interfaces)
x11vnc -display :99 -nopw -forever -shared -rfbport 5900 -listen 0.0.0.0 &

# Start noVNC (on all interfaces)
websockify --web=/usr/share/novnc/ 0.0.0.0:8080 0.0.0.0:5900 &

# Show media mount and config
echo "📁 Media directory: ${MEDIA_DIR:-/home/handbrake/media}"
echo "⚙️  Config directory: /home/handbrake/.config/ghb"

# Force dark GTK theme
export GTK_THEME=Adwaita:dark

# Launch HandBrake GUI (binary is ghb in Arch)
ghb --fullscreen
