FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt update && apt install -y \
    handbrake \
    xpra \
    xauth \
    xvfb \
    dbus-x11 \
    python3-pip \
    ca-certificates \
    curl \
    sudo \
    --no-install-recommends && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create user to match host UID/GID
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g ${PGID} appgroup && \
    useradd -u ${PUID} -g appgroup -m appuser && \
    usermod -aG sudo appuser

# Set user
USER appuser

# Set working directory
WORKDIR /config

# Entrypoint
CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --start=handbrake --daemon=no
