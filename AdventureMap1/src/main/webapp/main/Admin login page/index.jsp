<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="navbar">
        <h1>Admin Dashboard</h1>
    </div>

    <div class="container">
        <!-- Card 1: Enter Latitude and Longitude -->
        <div class="card">
            <h2>Location Input</h2>
            <form method="post" action="http://localhost:8080/AdventureMap1/UploadLocation" enctype="multipart/form-data">
                <label for="locationName">Enter Location Name:</label>
                <input type="text" id="locationName" name="locationName" placeholder="Location Name" required>
                
                <label for="latitude">Enter Latitude:</label>
                <input type="text" id="latitude" name="latitude" placeholder="Latitude" required>
                
                <label for="longitude">Enter Longitude:</label>
                <input type="text" id="longitude" name="longitude" placeholder="Longitude" required>
                
                <label for="image">Upload Image:</label>
                <input type="file" id="image" name="image" required>
                
                <button type="submit" name="action" value="createLocation">Create New Location</button>
            </form>
        </div>
        
        <!-- Card 2: Manage Locations -->
        <div class="card">
            <h2>Manage Locations</h2>
            <table id="locationTable">
                <thead>
                    <tr>
                        <th>Location</th>
                        <th>Latitude</th>
                        <th>Longitude</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
                             Statement stmt = conn.createStatement();
                             ResultSet rs = stmt.executeQuery("SELECT * FROM locations")) {

                            while (rs.next()) {
                                String locationName = rs.getString("location_name");
                                String lat = rs.getString("latitude");
                                String lng = rs.getString("longitude");
                    %>
                    <tr>
                        <td><%= locationName %></td>
                        <td><%= lat %></td>
                        <td><%= lng %></td>
                        <td>
                            <form method="post" action="index.jsp" style="display:inline;">
                                <input type="hidden" name="locationName" value="<%= locationName %>">
                                <button type="submit" name="action" value="deleteLocation" class="delete-btn">Delete</button>
                            </form>
                        </td>
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
        
        <!-- Card 3: User List Table -->
        <div class="card">
            <h2>User List</h2>
            <table id="userTable">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
                             Statement stmt = conn.createStatement();
                             ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {

                            while (rs.next()) {
                                String username = rs.getString("uname");
                    %>
                    <tr>
                        <td><%= username %></td>
                        <td>
                            <form method="post" action="index.jsp" style="display:inline;">
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" name="action" value="deleteUser" class="delete-btn">Delete</button>
                            </form>
                        </td>
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
</div>

<div class="container">
        <!-- Card 4: User Rankings Table -->
        <div class="card">
            <h2>User Rankings</h2>
            <table id="rankingsTable">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>User Rank</th>
                        <th>Points</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
                             Statement stmt = conn.createStatement();
                             ResultSet rs = stmt.executeQuery("SELECT * FROM ranksdb")) {

                            while (rs.next()) {
                                String username = rs.getString("username");
                                int userRank = rs.getInt("user_Ranks");
                                int points = rs.getInt("points");
                    %>
                    <tr>
                        <td><%= username %></td>
                        <td>
                            <form method="post" action="index.jsp" style="display:inline;">
                                <input type="number" name="newRank" value="<%= userRank %>" required>
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" name="action" value="editRank">Edit Rank</button>
                            </form>
                        </td>
                        <td>
                            <form method="post" action="index.jsp" style="display:inline;">
                                <input type="number" name="newPoints" value="<%= points %>" required>
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" name="action" value="editPoints">Edit Points</button>
                            </form>
                        </td>
                        <td>
                            <form method="post" action="index.jsp" style="display:inline;">
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" name="action" value="deleteRanking" class="delete-btn">Delete</button>
                            </form>
                        </td>
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

        <!-- Retrieve Users Button -->
        <div class="card">
            <form method="post" action="index.jsp">
                <button type="submit" name="action" value="retrieveUsers">Retrieve Users</button>
            </form>
        </div>
    </div>

    <%
        // Handle form submissions for CRUD operations
        String action = request.getParameter("action");
        if (action != null) {
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301")) {

                // Retrieve Users and store in ranksdb
                if ("retrieveUsers".equals(action)) {
                    String retrieveUsersQuery = "SELECT uname FROM users";
                    try (Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery(retrieveUsersQuery)) {
                        String insertQuery = "INSERT INTO ranksdb (username) VALUES (?)";
                        try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                            while (rs.next()) {
                                String username = rs.getString("uname");
                                ps.setString(1, username);
                                ps.executeUpdate();
                            }
                        }
                    }
                } else if ("editRank".equals(action)) {
                    String username = request.getParameter("username");
                    int newRank = Integer.parseInt(request.getParameter("newRank"));

                    // Update rank in ranksdb
                    String updateRankQuery = "UPDATE ranksdb SET user_Ranks=? WHERE username=?";
                    try (PreparedStatement ps = conn.prepareStatement(updateRankQuery)) {
                        ps.setInt(1, newRank);
                        ps.setString(2, username);
                        ps.executeUpdate();
                    }
                } else if ("editPoints".equals(action)) {
                    String username = request.getParameter("username");
                    int newPoints = Integer.parseInt(request.getParameter("newPoints"));

                    // Update points in ranksdb
                    String updatePointsQuery = "UPDATE ranksdb SET points=? WHERE username=?";
                    try (PreparedStatement ps = conn.prepareStatement(updatePointsQuery)) {
                        ps.setInt(1, newPoints);
                        ps.setString(2, username);
                        ps.executeUpdate();
                    }

                    // Also update points in users table
                    String updateUserPointsQuery = "UPDATE users SET points=? WHERE uname=?";
                    try (PreparedStatement ps = conn.prepareStatement(updateUserPointsQuery)) {
                        ps.setInt(1, newPoints);
                        ps.setString(2, username);
                        ps.executeUpdate();
                    }
                } else if ("deleteLocation".equals(action)) {
                    String locationName = request.getParameter("locationName");
                    String deleteQuery = "DELETE FROM locations WHERE location_name=?";
                    try (PreparedStatement ps = conn.prepareStatement(deleteQuery)) {
                        ps.setString(1, locationName);
                        ps.executeUpdate();
                    }
                } else if ("deleteUser".equals(action)) {
                    String username = request.getParameter("username");
                    String deleteQuery = "DELETE FROM users WHERE uname=?";
                    try (PreparedStatement ps = conn.prepareStatement(deleteQuery)) {
                        ps.setString(1, username);
                        ps.executeUpdate();
                    }
                } else if ("deleteRanking".equals(action)) {
                    String username = request.getParameter("username");
                    String deleteRankingQuery = "DELETE FROM ranksdb WHERE username=?";
                    try (PreparedStatement ps = conn.prepareStatement(deleteRankingQuery)) {
                        ps.setString(1, username);
                        ps.executeUpdate();
                    }
                }

                // Redirect to refresh the page
                response.sendRedirect("index.jsp");
            } catch (SQLException e) {
                e.printStackTrace();
                // Handle the error, maybe display an error message to the user
            }
        }
    %>
</body>
</html>