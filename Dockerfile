# Dockerfile
# Start from the official Python image
FROM python:3.9

# Install necessary packages for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y wget unzip && \
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip && \
    apt-get install -y google-chrome-stable

# Set working directory
WORKDIR /app

# Copy all files to working directory
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose port for the application
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
