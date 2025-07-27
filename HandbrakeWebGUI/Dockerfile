FROM ubuntu:22.04


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install dependencies
RUN apt update && apt install -y \
    handbrake \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    fluxbox \
    wget \
    net-tools \
    xterm \
    && apt clean

# Create non-root user
RUN useradd -ms /bin/bash handbrake

USER handbrake
WORKDIR /home/handbrake

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
CMD ["/entrypoint.sh"]
