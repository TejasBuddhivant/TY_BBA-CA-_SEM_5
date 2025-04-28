<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="icon" href="http://localhost:8080/AdventureMap1/main/images/iconweb.png">
    <link rel="stylesheet" href="http://localhost:8080/AdventureMap1/main/Admin%20login%20page/style1.css">
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form method="post" action="http://localhost:8080/AdventureMap1/Adminlogin" 
							id="login-form">
            <div class="input-box">
                <label for="userid">User ID</label>
                 <input type="text" name="username" id="username"
									placeholder="Your Admin ID" />
            </div>
            <div class="input-box">
                <label for="password"><i class="zmdi zmdi-lock"></i></label>
                 <input type="password" name="password" id="password" placeholder="Password" />
            </div>
            <div class="form-group form-button">
								<input type="submit" name="signin" id="signin"
									class="form-submit" value="Log in" />
							</div>
        </form>
    </div>
    <script src="script.js"></script>
</body>
</html>
