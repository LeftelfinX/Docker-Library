FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    xpra \
    xauth \
    dbus-x11 \
    handbrake \
    python3-pip \
    python3-dbus \
    python3-pyinotify \
    python3-xdg \
    python3-pil \
    python3-paramiko \
    x11-xserver-utils \
    xfonts-base \
    fonts-dejavu \
    libgl1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
