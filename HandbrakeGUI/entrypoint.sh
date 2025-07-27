#!/bin/bash

# Fix permission for dconf
sudo mkdir -p /run/user/1000
sudo chown -R appuser:appuser /run/user/1000

# Create Xpra runtime dirs
mkdir -p /run/user/1000/xpra
mkdir -p ~/.xpra

export XDG_RUNTIME_DIR=/run/user/1000

# Start dbus
eval $(dbus-launch --sh-syntax)

# Start HandBrake GUI in Xpra
xpra start :0 \
  --bind-tcp=0.0.0.0:10000 \
  --html=on \
  --daemon=no \
  --start-child=ghb \
  --exit-with-children \
  --no-mdns \
  --no-notifications \
  --no-pulseaudio \
  --no-systemd-run
