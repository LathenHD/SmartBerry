#!/bin/bash

# Give cvlc access to the GUI session
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority

# Full path to cvlc
CVLC="/usr/bin/cvlc"

# Stream with display output, no interface
$CVLC \
  --no-osd \
  --network-caching=200 \
  rtsp://127.0.0.1:8554/cam &

VLC_PID=$!
sleep 20
kill "$VLC_PID"
