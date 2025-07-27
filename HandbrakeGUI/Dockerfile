FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# Install dependencies
RUN apt-get update && apt-get install -y \
    xpra \
    xauth \
    dbus-x11 \
    handbrake-gtk \
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

# Create app user and dirs
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

# Copy configs
COPY --chown=appuser:appuser entrypoint.sh /entrypoint.sh
COPY --chown=appuser:appuser xpra.conf /home/appuser/.xpra/xpra.conf
RUN chmod +x /entrypoint.sh

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]
