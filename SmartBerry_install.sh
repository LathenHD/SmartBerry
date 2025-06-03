#!/bin/bash

LOGFILE="/home/pi/smartberry-install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Starting SmartBerry Setup ==="

# Update & Upgrade
echo "Updating and upgrading system..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Clone SmartBerry repo
echo "Cloning SmartBerry repository..."
git clone https://github.com/LathenHD/SmartBerry.git /home/pi/SmartBerry

# Install MagicMirror
echo "Installing MagicMirror..."
bash -c "$(curl -sL https://raw.githubusercontent.com/sdetweil/MagicMirror_scripts/master/raspberry.sh)" non-interactive

# Install Mediamtx dependencies
echo "Installing MediaMTX dependencies..."
sudo apt-get install libfreetype6 libcamera0 -y

# Create and copy MediaMTX files
echo "Setting up MediaMTX binaries and config..."
sudo mkdir -p /opt/mediamtx
sudo cp /home/pi/SmartBerry/MediamXL/mediamtx /opt/mediamtx/
sudo cp /home/pi/SmartBerry/MediamXL/mediamtx.yml /opt/mediamtx/
sudo chmod +x /opt/mediamtx/mediamtx

# Install Flask
echo "Installing Flask..."
sudo apt-get install python3-pip -y
sudo apt-get install python3-flask -y

# Install Ngrok
echo "Installing Ngrok..."
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt-get update
sudo apt-get install ngrok -y

# Add Ngrok Auth Token
echo "Adding Ngrok auth token..."
ngrok config add-authtoken 2x8WQy60XJI9chIaXoBlA73BXK5_4DhkmR3crnvQu8Z8DNS65

# Copy and enable systemd service files
echo "Copying and enabling service files..."
sudo cp /home/pi/SmartBerry/Services/*.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "Enabling and starting services..."
sudo systemctl enable mediamtx.service
sudo systemctl start mediamtx.service

sudo systemctl enable flask-server.service
sudo systemctl start flask-server.service

sudo systemctl enable ngrok.service
sudo systemctl start ngrok.service

echo "=== SmartBerry Setup Complete ==="
