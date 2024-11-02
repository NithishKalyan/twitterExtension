# Use an official Python image with the appropriate version
FROM python:3.9-slim

# Install required packages
RUN apt-get update && apt-get install -y \
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
    libgtk-3-0 && \
    rm -rf /var/lib/apt/lists/*

# Download and set up Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome.deb && \
    dpkg -i google-chrome.deb || apt-get install -f -y && \
    rm google-chrome.deb

# Set the Chrome binary path
ENV GOOGLE_CHROME_BIN="/usr/bin/google-chrome"

# Download and set up ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    rm chromedriver_linux64.zip

# Set environment variables for ChromeDriver
ENV PATH="/usr/local/bin:$PATH"

# Copy app code
WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Run the app
CMD ["python", "app.py"]
