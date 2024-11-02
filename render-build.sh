#!/usr/bin/env bash

# Log start of script
echo "Starting render-build.sh script..."

# Install Chrome
echo "Installing Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt-get -f install -y

# Verify Chrome installation and path
if command -v google-chrome &> /dev/null
then
    echo "Chrome installed successfully at $(command -v google-chrome)"
else
    echo "Chrome installation failed or Chrome binary not found."
    exit 1
fi

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
