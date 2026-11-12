#!/bin/bash
set -e

export DISPLAY=:1

rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

echo "Starting nginx (combined page)..."
sudo nginx

echo "Starting virtual screen..."
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

echo "Starting window manager..."
openbox &
sleep 1

echo "Starting VNC server..."
x11vnc -display :1 -forever -shared -nopw -rfbport 5900 -quiet &
sleep 1

echo "Starting noVNC (internal, port 6080)..."
websockify --web /usr/share/novnc 6080 localhost:5900 &

echo "Starting web terminal (internal, port 7681)..."
ttyd -p 7681 -W bash &

echo "Opening Chromium..."
chromium --no-sandbox --disable-dev-shm-usage --disable-gpu --start-maximized about:blank &

echo "All services started. Visit the single combined page on port 8080."
wait