#!/usr/bin/env bash

echo "Starting build process..."

# Verify Chrome and ChromeDriver installation paths
echo "Checking Google Chrome and ChromeDriver paths and permissions..."
ls -l /usr/bin/google-chrome
ls -l /usr/local/bin/chromedriver

echo "Build process completed."
