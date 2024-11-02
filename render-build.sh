#!/usr/bin/env bash

# Log start of script
echo "Starting render-build.sh script..."

# Download and extract a portable version of Chrome
echo "Downloading Chrome..."
wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
mkdir -p chrome
dpkg -x google-chrome-stable_current_amd64.deb chrome

# Set the path to the Chrome binary
export GOOGLE_CHROME_BIN=$PWD/chrome/opt/google/chrome/google-chrome
echo "GOOGLE_CHROME_BIN=$GOOGLE_CHROME_BIN" > .env  # Save to .env for runtime access
echo "Chrome binary set to $GOOGLE_CHROME_BIN"

# Install ChromeDriver
echo "Installing ChromeDriver..."
CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver ./chromedriver  # Move to the project root directory
chmod +x ./chromedriver

# Verify ChromeDriver installation
if [ -f "./chromedriver" ]; then
    echo "ChromeDriver installed successfully at $(pwd)/chromedriver"
else
    echo "ChromeDriver installation failed."
    exit 1
fi

echo "render-build.sh script completed."
