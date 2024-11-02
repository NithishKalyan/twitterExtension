#!/usr/bin/env bash

echo "Starting build process..."

# Confirm Chrome and ChromeDriver paths
echo "Verifying Google Chrome and ChromeDriver installation and permissions..."
ls -l /usr/bin/google-chrome
ls -l /usr/local/bin/chromedriver

echo "Build process completed."
