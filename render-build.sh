#!/usr/bin/env bash

echo "Starting render-build.sh script..."

# Install dependencies required for Chrome in a headless environment
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
    libgtk-3-0 || { echo "Dependency installation failed"; exit 1; }

# Download the latest stable version of Google Chrome
echo "Downloading and installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome.deb || { echo "Failed to download Chrome"; exit 1; }
mkdir -p chrome && dpkg -x google-chrome.deb chrome || { echo "Failed to extract Chrome package"; exit 1; }

# Set Chrome binary path
CHROME_BIN=$(find chrome -type f -name 'google-chrome')
if [ -f "$CHROME_BIN" ]; then
    export GOOGLE_CHROME_BIN="$PWD/$CHROME_BIN"
    echo "GOOGLE_CHROME_BIN set to $GOOGLE_CHROME_BIN"
    echo "GOOGLE_CHROME_BIN=$GOOGLE_CHROME_BIN" > .env
else
    echo "Chrome binary not found."
    exit 1
fi

# Download ChromeDriver
echo "Downloading ChromeDriver..."
CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip || { echo "Failed to download ChromeDriver"; exit 1; }
unzip chromedriver_linux64.zip || { echo "Failed to unzip ChromeDriver"; exit 1; }
chmod +x chromedriver && mv chromedriver ./chromedriver || { echo "Failed to set up ChromeDriver"; exit 1; }

# Final check
if [ -f "./chromedriver" ]; then
    echo "ChromeDriver installed successfully at $(pwd)/chromedriver"
else
    echo "ChromeDriver installation failed."
    exit 1
fi

echo "render-build.sh script completed successfully."
