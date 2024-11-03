# Dockerfile
# Start from an official Python image
FROM python:3.9

# Install dependencies and Chrome, ChromeDriver
RUN apt-get update && apt-get install -y wget unzip curl && \
    # Download ChromeDriver
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip && \
    # Install Chrome
    wget -q -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install && \
    rm /tmp/google-chrome-stable_current_amd64.deb && \
    # Set permissions
    chmod +x /usr/local/bin/chromedriver && \
    chmod +x /usr/bin/google-chrome

# Explicitly set Chrome and ChromeDriver paths
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome
ENV CHROMEDRIVER_PATH=/usr/local/bin/chromedriver

# Set the working directory
WORKDIR /app

# Copy all files into the container
COPY . /app

# Install required Python packages
RUN pip install -r requirements.txt

# Expose the port your application runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
