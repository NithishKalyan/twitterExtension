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
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -f -y \
    && rm google-chrome-stable_current_amd64.deb

# Print contents of /usr/bin to verify chrome is installed
RUN ls -l /usr/bin | grep google-chrome

# Set the Chrome binary path
ENV GOOGLE_CHROME_BIN="/usr/bin/google-chrome"

# Download and set up a compatible ChromeDriver version (replace with specific version if needed)
RUN wget -q https://chromedriver.storage.googleapis.com/115.0.5790.102/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    rm chromedriver_linux64.zip && \
    chmod +x /usr/local/bin/chromedriver  # Ensure ChromeDriver is executable

# Verify ChromeDriver installation
RUN ls -l /usr/local/bin | grep chromedriver

# Set environment variables for ChromeDriver
ENV PATH="/usr/local/bin:$PATH"

# Set the working directory and copy application code
WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Run the app
CMD ["python", "app.py"]

