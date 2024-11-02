#!/usr/bin/env bash

# Log start of script
echo "Starting render-build.sh script..."

# Update package list and install dependencies for Chrome
echo "Installing dependencies for Chrome..."
apt-get update && apt-get install -y \
    wget \
    unzip \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxrandr2 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libpangocairo-1.0-0 \
    libcups2 \
    libxss1 \
    libgbm1 \
    libpango-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0

# Download the latest stable version of Chrome
echo "Downloading and installing Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
mkdir -p chrome
dpkg -x google-chrome-stable_current_amd64.deb chrome

# Find and set Chrome binary path
CHROME_BIN=$(find chrome -type f -name 'google-chrome')
if [ -f "$CHROME_BIN" ]; then
    export GOOGLE_CHROME_BIN="$PWD/$CHROME_BIN"
    echo "GOOGLE_CHROME_BIN set to $GOOGLE_CHROME_BIN"
    echo "GOOGLE_CHROME_BIN=$GOOGLE_CHROME_BIN" > .env  # Save to .env for runtime access
else
    echo "Chrome binary not found. Installation failed."
    exit 1
fi

# Download ChromeDriver
echo "Downloading ChromeDriver..."
CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
chmod +x chromedriver
mv chromedriver ./chromedriver  # Move ChromeDriver to the project root directory

# Verify ChromeDriver installation
if [ -f "./chromedriver" ]; then
    echo "ChromeDriver installed successfully at $(pwd)/chromedriver"
else
    echo "ChromeDriver installation failed."
    exit 1
fi

echo "render-build.sh script completed successfully."
