let timerInterval;

function fetchUsernames() {
    const postUrl = document.getElementById("postUrl").value;
    document.getElementById("loader").style.display = "block";  // Show the loader
    document.getElementById("timer").style.display = "block";
    startTimer();

    document.getElementById("jsonOutput").value = "";  // Clear previous output

    fetch('/fetch_usernames', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ url: postUrl })
    })
    .then(response => {
        document.getElementById("loader").style.display = "none";  // Hide loader after response
        stopTimer();
        if (!response.ok) {
            throw new Error("Network response was not ok " + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        if (data.error) {
            document.getElementById("jsonOutput").value = "Error: " + data.error;
        } else {
            document.getElementById("jsonOutput").value = JSON.stringify(data.usernames, null, 2);
            document.getElementById("compareButton").style.display = "block"; // Show Compare button
        }
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById("jsonOutput").value = "Error: " + error.message;
        document.getElementById("loader").style.display = "none";  // Hide loader on error
        stopTimer();
    });
}

function startTimer() {
    let seconds = 0;
    timerInterval = setInterval(() => {
        seconds++;
        document.getElementById("timer").textContent = `Time Elapsed: ${seconds}s`;
    }, 1000);
}

function stopTimer() {
    clearInterval(timerInterval);
    document.getElementById("timer").style.display = "none";
}

function copyToClipboard() {
    const jsonOutput = document.getElementById("jsonOutput");
    jsonOutput.select();
    document.execCommand("copy");
    alert("JSON copied to clipboard!");
}

function makeList() {
    const jsonOutput = document.getElementById("jsonOutput").value;
    try {
        const usernames = JSON.parse(jsonOutput);
        const listOutput = usernames.map((username, index) => `${index + 1}) @${username}`).join("\n");
        document.getElementById("jsonOutput").value = listOutput;
    } catch (error) {
        alert("Invalid JSON format. Please make sure there is valid data in the JSON output.");
    }
}

function showComparisonArea() {
    document.getElementById("comparisonArea").style.display = "block";
}

function compareUsernames() {
    try {
        const mainPostData = JSON.parse(document.getElementById("mainPostUsers").value);
        const userPostData = JSON.parse(document.getElementById("userPostUsers").value);

        const missingUsers = mainPostData.filter(username => !userPostData.includes(username));
        const formattedMissingUsers = missingUsers.map((username, index) => `${index + 1}) @${username}`).join("\n");

        document.getElementById("missingUsers").value = formattedMissingUsers || "All users are present.";
    } catch (error) {
        alert("Invalid JSON format in one of the text areas.");
    }
}

function copyMissingUsers() {
    const missingUsers = document.getElementById("missingUsers");
    missingUsers.select();
    document.execCommand("copy");
    alert("Missing users copied to clipboard!");
}
