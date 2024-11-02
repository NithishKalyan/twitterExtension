# Dockerfile
# Install dependencies and Chrome, ChromeDriver
FROM python:3.9

RUN apt-get update && apt-get install -y wget unzip curl && \
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip && \
    apt-get install -y google-chrome-stable && \
    chmod +x /usr/local/bin/chromedriver && \
    chmod +x /usr/bin/google-chrome

# Explicitly set Chrome and ChromeDriver paths
ENV GOOGLE_CHROME_BIN=/usr/bin/google-chrome
ENV CHROMEDRIVER_PATH=/usr/local/bin/chromedriver

WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]
