from flask import Flask, render_template, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import threading

app = Flask(__name__)

USERNAME = "Kalyan442472810"
GMAIL = "kalyank1131@gmail.com"
PASSWORD = "Nithish@4321"

def init_driver():
    chrome_options = Options()
    chrome_options.add_argument("--start-maximized")
    chrome_options.add_argument("--disable-notifications")
    chrome_options.add_argument("--headless")
    service = Service('C:/Users/KAS714/Downloads/chromedriver-win32/chromedriver-win32/chromedriver.exe')  # Update with your actual path
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
def collect_usernames(driver, post_url):
    commenter_usernames = set()
    driver.get(post_url)
    time.sleep(5)
    last_height = driver.execute_script("return document.body.scrollHeight")
    
    while True:
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
    
    return list(commenter_usernames)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/fetch_usernames', methods=['POST'])
def fetch_usernames():
    try:
        post_url = request.json.get('url', '')
        if not post_url:
            return jsonify({"error": "Invalid URL provided"}), 400
        
        driver = init_driver()
        login_twitter(driver)
        usernames = collect_usernames(driver, post_url)
        driver.quit()  # Close the WebDriver after use
        
        if usernames:
            return jsonify(usernames=usernames)
        else:
            return jsonify({"error": "No usernames found or an error occurred during data collection"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)