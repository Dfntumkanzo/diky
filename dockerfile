FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      xvfb \
      openbox \
      x11vnc \
      novnc \
      websockify \
      chromium \
      xterm \
      fonts-dejavu-core \
      dbus-x11 \
      ca-certificates \
      curl \
      wget \
      git \
      python3 \
      python3-pip \
      python3-venv \
      sudo \
    && rm -rf /var/lib/apt/lists/*

# ttyd isn't packaged for Debian, so grab the prebuilt binary directly
RUN curl -fL https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
      -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR /home/dev

COPY --chown=dev:dev start.sh /home/dev/start.sh
RUN chmod +x /home/dev/start.sh

EXPOSE 6080 7681

CMD ["/home/dev/start.sh"]