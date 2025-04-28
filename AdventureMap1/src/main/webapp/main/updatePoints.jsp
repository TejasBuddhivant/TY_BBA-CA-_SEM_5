<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%
    // Get the current logged-in user's username from the session
    String username = (String) session.getAttribute("name");

    // Get the points from the quiz submission (from the AJAX call)
    String pointsParam = request.getParameter("points");
    int newPoints = 0;

    if (pointsParam != null) {
        newPoints = Integer.parseInt(pointsParam);
    }

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/adventure";
    String user = "root";
    String password = "Tejas@412301";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Step 1: Retrieve the user's current points
        String fetchPointsQuery = "SELECT points FROM users WHERE uname = ?";
        pstmt = conn.prepareStatement(fetchPointsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        int currentPoints = 0;
        if (rs.next()) {
            currentPoints = rs.getInt("points");
        }

        // Step 2: Add the new points to the current points
        int totalPoints = currentPoints + newPoints;

        // Step 3: Update the user's points in the database
        String updatePointsQuery = "UPDATE users SET points = ? WHERE uname = ?";
        pstmt = conn.prepareStatement(updatePointsQuery);
        pstmt.setInt(1, totalPoints);
        pstmt.setString(2, username);
        pstmt.executeUpdate();

        // Update session attribute for total points (to reflect in game info)
        session.setAttribute("totalPoints", totalPoints);

        // Send a success response back to the frontend
        out.print("Points updated successfully!");

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.print("Error updating points.");
    } finally {
        // Close all connections
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
