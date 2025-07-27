FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install HandBrake GTK + Xpra
RUN apt update && apt install -y \
    handbrake-gtk xpra xvfb python3 net-tools \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create user for mapping UID/GID
RUN useradd -ms /bin/bash user

# Copy the launch script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 14500
CMD ["/start.sh"]
