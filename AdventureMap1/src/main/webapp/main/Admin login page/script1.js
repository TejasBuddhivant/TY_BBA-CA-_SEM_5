document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent form submission

    // Get the user input
    const userID = document.getElementById("userid").value;
    const password = document.getElementById("password").value;

    // Perform basic validation (optional)
    if (userID && password) {
        alert("Login successful!");
    } else {
        alert("Please fill in both fields.");
    }
});
