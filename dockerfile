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
      nginx \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fL https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
      -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# nginx config and the combined page (served as root, since nginx needs root to bind port 80)
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY index.html /var/www/html/index.html

USER dev
WORKDIR /home/dev

COPY --chown=dev:dev start.sh /home/dev/start.sh
RUN chmod +x /home/dev/start.sh

# Only ONE port exposed now — everything goes through it
EXPOSE 8080

CMD ["/home/dev/start.sh"]