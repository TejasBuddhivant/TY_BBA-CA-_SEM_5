<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}
%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.SQLException, java.sql.Statement" %>
<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
} else {
    String username = (String) session.getAttribute("name");

    // Fetch points from the 'users' table for the logged-in user
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
         Statement stmt = conn.createStatement()) {
        
        // Query to get the points for the logged-in user
        String pointsQuery = "SELECT points FROM users WHERE uname = '" + username + "'";
        ResultSet rs = stmt.executeQuery(pointsQuery);
        
        if (rs.next()) {
            int points = rs.getInt("points");
            
            // Set points in session
            session.setAttribute("totalPoints", points);
        } else {
            // If no points found, default to 0
            session.setAttribute("totalPoints", 0);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style1.css">
    <title>Adventure Maps</title>
    <style>
           /* General styling */
        body {
            font-family: 'Trebuchet MS', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #2c3e50; /* Darker background for a game feel */
            color: #010202; /* Light text for contrast */
        }

        /* Header styling */
        h1 {
            text-align: center;
            font-size: 3em;
            margin-top: 0;
            padding: 20px;
            background-color: #34495e;
            color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        /* Container for the map */
        #map {
            height: 600px;
            width: 100%;
            margin: 20px auto;
            border: 2px solid #3498db;
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.3);
        }

        /* Top left user icon and game info section */
        .header-section {
            position: fixed;
            top: 10px;
            left: 10px;
            display: flex;
            align-items: center;
        }

        .user-info {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }

        .user-info img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.4);
        }

        .user-info p {
            margin: 0;
            font-size: 1.2em;
            color: #ecf0f1;
        }

        /* Game info styling */
        #gameInfo {
            background-color: #34495e;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
            text-align: center;
            color: #ecf0f1;
            margin-left: 20px;
            margin-top: 100px;
            z-index: 50;
        }

        #gameInfo h2 {
            margin: 0 0 10px;
            font-size: 1.5em;
            color: #f1c40f;
        }

        #gameInfo p {
            font-size: 1.2em;
            margin: 5px 0;
        }

        #totalPoints, #earnedBadge {
            font-size: 1.5em;
            color: #2ecc71; /* Green for points */
            font-weight: bold;
        }

        /* Style for different badges */
        #earnedBadge.gold {
            color: #f1c40f; /* Gold color for gold badge */
        }

        #earnedBadge.silver {
            color: #bdc3c7; /* Silver color for silver badge */
        }

        #earnedBadge.bronze {
            color: #cd7f32; /* Bronze color for bronze badge */
        }

        /* Logout button styling */
        .logout-btn {
            position: fixed;
            top: 10px;
            right: 10px;
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1em;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .logout-btn:hover {
            background-color: #c0392b;
        }

        /* Ranks table styling */
        .ranks-table-container {
            margin: 50px auto;
            width: 80%;
            background-color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.2);
        }

        .ranks-table-container h2 {
            text-align: center;
            font-size: 2em;
            color: #34495e;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }

        table th {
            background-color: #34495e;
            color: white;
        }

        table tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        
        /*for quizes css  */
        
        /* Styling for Quiz Section */
#quizContainer {
    width: 80%;
    margin: 30px auto;
    background-color: #ecf0f1;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.quiz-slider {
    display: flex;
    overflow: hidden;
    width: 100%;
    max-width: 100%;
}

.quiz {
    min-width: 100%;
    transition: 0.5s;
}

button {
    padding: 10px 15px;
    background-color: #3498db;
    color: white;
    border: none;
    cursor: pointer;
    margin-top: 10px;
    border-radius: 5px;
}

button:hover {
    background-color: #2980b9;
}

button#submitQuiz {
    background-color: #27ae60;
}

button#submitQuiz:hover {
    background-color: #2ecc71;
}
        
    </style>
</head>
<body>
    <h1>ADVENTURE MAPS</h1>

    <!-- User info and Game info in the header section -->
    <div class="header-section">
        <div class="user-info">
            <img src="images/images.jpg" alt="User Icon">
            <p>Welcome, <%= session.getAttribute("name") %>!</p>
        </div>
    </div>

    <!-- Logout button -->
    <a type="submit" class="logout-btn" href="http://localhost:8080/AdventureMap1/">LOG OUT</a>

    <!-- Map container -->
    <div id="map"></div>
    
    
    
    <!-- Quiz Container -->
<div id="quizContainer">
    <h2>Adventure Quizzes</h2>

    <!-- Quizzes Slider -->
    <div class="quiz-slider">
        <!-- Quiz 1 -->
        <div class="quiz">
            <h3>Quiz 1: Famous Landmarks</h3>
            <p>Which country is home to the Eiffel Tower?</p>
            <label><input type="radio" name="q1" value="0"> Italy</label><br>
            <label><input type="radio" name="q1" value="0"> Spain</label><br>
            <label><input type="radio" name="q1" value="10"> France</label><br>
            <label><input type="radio" name="q1" value="0"> Germany</label>
            
           
    <p>Which island is home to the statue of Christ the Redeemer?</p>
    <label><input type="radio" name="q19" value="0"> Bali</label><br>
    <label><input type="radio" name="q19" value="10"> Rio de Janeiro</label><br>
    <label><input type="radio" name="q19" value="0"> Santorini</label><br>
    <label><input type="radio" name="q19" value="0"> Ibiza</label>
        </div>

        <!-- Quiz 2 -->
        <div class="quiz">
            <h3>Quiz 2: Adventure Sports</h3>
            <p>Which is considered the highest bungee jump site?</p>
            <label><input type="radio" name="q2" value="0"> Victoria Falls</label><br>
            <label><input type="radio" name="q2" value="10"> Macau Tower</label><br>
            <label><input type="radio" name="q2" value="0"> Golden Gate Bridge</label><br>
            <label><input type="radio" name="q2" value="0"> Bloukrans Bridge</label>
            
            <p>Which island is famous for its unique species like the giant tortoise?</p>
    <label><input type="radio" name="q20" value="0"> Madagascar</label><br>
    <label><input type="radio" name="q20" value="10"> Galápagos Islands</label><br>
    <label><input type="radio" name="q20" value="0"> Seychelles</label><br>
    <label><input type="radio" name="q20" value="0"> Maldives</label>
        </div>
        
        
        
        <!-- Quiz 3: National Parks -->
<div class="quiz">
    <h3>Quiz 3: National Parks</h3>
    <p>Which is the largest national park in the world?</p>
    <label><input type="radio" name="q5" value="0"> Yellowstone National Park</label><br>
    <label><input type="radio" name="q5" value="0"> Banff National Park</label><br>
    <label><input type="radio" name="q5" value="10"> Northeast Greenland National Park</label><br>
    <label><input type="radio" name="q5" value="0"> Kruger National Park</label>

    <p>Which US state is home to the Grand Canyon?</p>
    <label><input type="radio" name="q6" value="0"> Nevada</label><br>
    <label><input type="radio" name="q6" value="10"> Arizona</label><br>
    <label><input type="radio" name="q6" value="0"> Utah</label><br>
    <label><input type="radio" name="q6" value="0"> Colorado</label>
</div>

<!-- Quiz 4: World Capitals -->
<div class="quiz">
    <h3>Quiz 4: World Capitals</h3>
    <p>What is the capital of Australia?</p>
    <label><input type="radio" name="q7" value="0"> Sydney</label><br>
    <label><input type="radio" name="q7" value="10"> Canberra</label><br>
    <label><input type="radio" name="q7" value="0"> Melbourne</label><br>
    <label><input type="radio" name="q7" value="0"> Brisbane</label>

    <p>Which capital city is known as "The Eternal City"?</p>
    <label><input type="radio" name="q8" value="0"> Athens</label><br>
    <label><input type="radio" name="q8" value="10"> Rome</label><br>
    <label><input type="radio" name="q8" value="0"> Paris</label><br>
    <label><input type="radio" name="q8" value="0"> Cairo</label>
</div>

<!-- Quiz 5: Famous Treks -->
<div class="quiz">
    <h3>Quiz 5: Famous Treks</h3>
    <p>Which trek is known as the "Roof of the World"?</p>
    <label><input type="radio" name="q9" value="10"> The Himalayan Trek</label><br>
    <label><input type="radio" name="q9" value="0"> Inca Trail</label><br>
    <label><input type="radio" name="q9" value="0"> Appalachian Trail</label><br>
    <label><input type="radio" name="q9" value="0"> Pacific Crest Trail</label>

    <p>The famous "Torres del Paine" trek is located in which country?</p>
    <label><input type="radio" name="q10" value="0"> Peru</label><br>
    <label><input type="radio" name="q10" value="10"> Chile</label><br>
    <label><input type="radio" name="q10" value="0"> Argentina</label><br>
    <label><input type="radio" name="q10" value="0"> Brazil</label>
</div>

<!-- Quiz 6: Travel Trivia -->
<div class="quiz">
    <h3>Quiz 6: Travel Trivia</h3>
    <p>Which continent has the most countries?</p>
    <label><input type="radio" name="q11" value="10"> Africa</label><br>
    <label><input type="radio" name="q11" value="0"> Asia</label><br>
    <label><input type="radio" name="q11" value="0"> Europe</label><br>
    <label><input type="radio" name="q11" value="0"> North America</label>

    <p>Which country is known as the Land of the Rising Sun?</p>
    <label><input type="radio" name="q12" value="10"> Japan</label><br>
    <label><input type="radio" name="q12" value="0"> China</label><br>
    <label><input type="radio" name="q12" value="0"> South Korea</label><br>
    <label><input type="radio" name="q12" value="0"> Thailand</label>
</div>

<!-- Quiz 7: Natural Wonders -->
<div class="quiz">
    <h3>Quiz 7: Natural Wonders</h3>
    <p>Where can you find the Great Barrier Reef?</p>
    <label><input type="radio" name="q13" value="0"> New Zealand</label><br>
    <label><input type="radio" name="q13" value="10"> Australia</label><br>
    <label><input type="radio" name="q13" value="0"> Philippines</label><br>
    <label><input type="radio" name="q13" value="0"> Indonesia</label>

    <p>Which desert is the largest in the world?</p>
    <label><input type="radio" name="q14" value="0"> Arabian Desert</label><br>
    <label><input type="radio" name="q14" value="10"> Sahara Desert</label><br>
    <label><input type="radio" name="q14" value="0"> Gobi Desert</label><br>
    <label><input type="radio" name="q14" value="0"> Kalahari Desert</label>
</div>

<!-- Quiz 8: Famous Explorers -->
<div class="quiz">
    <h3>Quiz 8: Famous Explorers</h3>
    <p>Who was the first European to reach India by sea?</p>
    <label><input type="radio" name="q15" value="0"> Christopher Columbus</label><br>
    <label><input type="radio" name="q15" value="10"> Vasco da Gama</label><br>
    <label><input type="radio" name="q15" value="0"> Ferdinand Magellan</label><br>
    <label><input type="radio" name="q15" value="0"> Marco Polo</label>

    <p>Who is known for circumnavigating the globe?</p>
    <label><input type="radio" name="q16" value="10"> Ferdinand Magellan</label><br>
    <label><input type="radio" name="q16" value="0"> Vasco da Gama</label><br>
    <label><input type="radio" name="q16" value="0"> Amerigo Vespucci</label><br>
    <label><input type="radio" name="q16" value="0"> Hernán Cortés</label>
</div>

<!-- Quiz 9: Historical Sites -->
<div class="quiz">
    <h3>Quiz 9: Historical Sites</h3>
    <p>Where is the ancient city of Petra located?</p>
    <label><input type="radio" name="q17" value="10"> Jordan</label><br>
    <label><input type="radio" name="q17" value="0"> Egypt</label><br>
    <label><input type="radio" name="q17" value="0"> Saudi Arabia</label><br>
    <label><input type="radio" name="q17" value="0"> Lebanon</label>

    <p>What is the name of the famous Mayan city in Mexico?</p>
    <label><input type="radio" name="q18" value="0"> Tikal</label><br>
    <label><input type="radio" name="q18" value="10"> Chichen Itza</label><br>
    <label><input type="radio" name="q18" value="0"> Machu Picchu</label><br>
    <label><input type="radio" name="q18" value="0"> Teotihuacan</label>
</div>

        <!-- More quizzes can be added here -->
    </div>

    <!-- Slider Navigation -->
    <button id="prevBtn" onclick="prevQuiz()">Previous</button>
    <button id="nextBtn" onclick="nextQuiz()">Next</button>

    <!-- Submit Button -->
    <button id="submitQuiz" onclick="submitQuizzes()">Submit Answers</button>
</div>
    
    
    
    
    
    
    
    
    <!-- Game Info Section -->
<!-- Game Info Section -->
<div id="gameInfo">
    <h2>Game Info</h2>
    <p>Total Points: <span id="totalPoints">
        <%= session.getAttribute("totalPoints") != null ? session.getAttribute("totalPoints") : "0" %>
    </span></p>
    <p>Earned Badge: <span id="earnedBadge" class="<%= session.getAttribute("earnedBadge") %>">
        <%= session.getAttribute("earnedBadge") != null ? session.getAttribute("earnedBadge") : "None" %>
    </span></p>
</div>


    <!-- Ranks Table -->
    <div class="ranks-table-container">
        <h2>User Rankings</h2>
        <table>
            <thead>
                <tr>
                    <th>Sr. No</th>
                    <th>Username</th>
                    <th>User Rank</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM ranksdb")) {

                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String username = rs.getString("username");
                            int rankLevel = rs.getInt("user_Ranks");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= username %></td>
                    <td><%= rankLevel %></td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- External script to initialize map -->
     <script src="script1.js"></script>
    

    <!-- Google Maps API -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDwMYmuTIg8pxqdbblJRbBUp-QT9L9Gthg&map_ids=76139607a3c83f60&callback=initMap"></script>
</body>
</html>
