FROM archlinux:latest

# Update Arch and enable parallel downloads
RUN sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf \
    && pacman -Syu --noconfirm

# Install core packages
RUN pacman -S --noconfirm \
    handbrake \
    xorg-server-xvfb \
    x11vnc \
    python \
    python-pip \
    python-pipx \
    wget \
    gtk3 \
    xorg-xhost \
    xorg-xrandr \
    xterm \
    fluxbox \
    && pacman -Scc --noconfirm

# Install websockify using pipx (Arch-preferred way)
RUN pipx install websockify \
    && ln -s /root/.local/bin/websockify /usr/local/bin/websockify

# Install noVNC manually
RUN mkdir -p /usr/share/novnc \
    && wget -qO- https://github.com/novnc/noVNC/archive/refs/tags/v1.5.0.tar.gz | tar xz --strip 1 -C /usr/share/novnc \
    && ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

# Create non-root user
RUN useradd -ms /bin/bash handbrake

USER handbrake
WORKDIR /home/handbrake

# Copy entrypoint
USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER handbrake

EXPOSE 8080
CMD ["/entrypoint.sh"]
