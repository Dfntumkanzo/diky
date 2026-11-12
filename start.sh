#!/bin/sh
set -e

export DISPLAY=:1

echo "Starting virtual screen..."
Xvfb :1 -screen 0 1280x800x24 &
sleep 2

echo "Starting window manager..."
openbox &
sleep 1

echo "Starting VNC server..."
x11vnc -display :1 -forever -shared -nopw -rfbport 5900 -quiet &
sleep 1

echo "Starting noVNC (browser desktop viewer) on port 6080..."
websockify --web /usr/share/novnc 6080 localhost:5900 &

echo "Starting web terminal (ttyd) on port 7681..."
ttyd -p 7681 bash &

echo "Opening Chromium..."
chromium --no-sandbox --disable-dev-shm-usage --disable-gpu --start-maximized about:blank &

echo "All services started. Keeping container alive."
wait -n