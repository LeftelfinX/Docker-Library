FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    handbrake xpra xvfb python3 net-tools \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create a user to match host UID:GID
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g ${PGID} appgroup && \
    useradd -u ${PUID} -g appgroup -m appuser

USER appuser
WORKDIR /media

CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --start=HandBrake
