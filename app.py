from flask import Flask, render_template, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Twitter credentials (store securely in environment variables)
USERNAME = "Kalyan442472810"
GMAIL = "kalyank1131@gmail.com"
PASSWORD = "Nithish@4321"

# Initialize Chrome WebDriver for Render environment
def init_driver():
    chrome_options = Options()

    # Use the Chrome binary path from the environment variable directly
    chrome_binary_path = os.environ.get("GOOGLE_CHROME_BIN")
    if not chrome_binary_path:
        raise Exception("Chrome binary path not found. Ensure GOOGLE_CHROME_BIN is set.")

    chrome_options.binary_location = chrome_binary_path
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--disable-software-rasterizer")
    chrome_options.add_argument("--disable-extensions")
    chrome_options.add_argument("--remote-debugging-port=9222")
    chrome_options.add_argument("--disable-setuid-sandbox")  # Important for security sandboxing issues in cloud environments
    chrome_options.add_argument("--single-process")  # Run Chrome in a single process
    chrome_options.add_argument("--disable-accelerated-2d-canvas")  # Disable hardware acceleration for 2D canvas

    # Use the locally downloaded ChromeDriver in the project root directory
    service = Service('./chromedriver')
    return webdriver.Chrome(service=service, options=chrome_options)


# Twitter login function
def login_twitter(driver):
    driver.get("https://x.com/i/flow/login")
    time.sleep(5)
    username_input = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "text")))
    username_input.send_keys(USERNAME)
    driver.find_element(By.XPATH, '//span[text()="Next"]').click()
    time.sleep(3)
    try:
        gmail_input = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "text")))
        gmail_input.send_keys(GMAIL)
        driver.find_element(By.XPATH, '//span[text()="Next"]').click()
        time.sleep(3)
    except:
        pass
    password_input = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "password")))
    password_input.send_keys(PASSWORD)
    driver.find_element(By.XPATH, '//span[text()="Log in"]').click()
    time.sleep(5)

# Function to collect usernames from a Twitter post
def collect_usernames(driver, post_url, max_scrolls=10):
    commenter_usernames = set()
    driver.get(post_url)
    time.sleep(5)
    last_height = driver.execute_script("return document.body.scrollHeight")
    scroll_count = 0
    
    while scroll_count < max_scrolls:
        try:
            comment_elements = WebDriverWait(driver, 20).until(
                EC.presence_of_all_elements_located((By.XPATH, '//div[@data-testid="User-Name"]//a[@href]'))
            )
            for comment in comment_elements:
                profile_url = comment.get_attribute("href")
                username = profile_url.split('/')[-1]
                if "status" in profile_url:
                    username = profile_url.split('/')[3]
                commenter_usernames.add(username)
        except:
            break
        
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(3)
        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
            break
        last_height = new_height
        scroll_count += 1
    
    return list(commenter_usernames)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/fetch_usernames', methods=['POST'])
def fetch_usernames():
    driver = init_driver()
    app.logger.info("Driver initialized successfully.")
    try:
        post_url = request.json.get('url', '')
        if not post_url:
            app.logger.error("No URL provided in the request.")
            return jsonify({"error": "Invalid URL provided"}), 400
        
        app.logger.info("Logging into Twitter.")
        login_twitter(driver)
        app.logger.info("Login successful.")
        
        app.logger.info(f"Fetching usernames from post URL: {post_url}")
        usernames = collect_usernames(driver, post_url)
        
        if usernames:
            app.logger.info(f"Usernames found: {usernames}")
            return jsonify(usernames=usernames)
        else:
            app.logger.warning("No usernames found or error occurred during data collection.")
            return jsonify({"error": "No usernames found or an error occurred during data collection"}), 500
    except Exception as e:
        app.logger.error("Error in fetch_usernames: %s", str(e))
        return jsonify({"error": str(e)}), 500
    finally:
        driver.quit()
        app.logger.info("Driver closed.")

# Health check route
@app.route('/health')
def health_check():
    return "OK", 200

if __name__ == '__main__':
    app.run(debug=True)
