package com.datagetting;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RankServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JDBC URL, username and password of MySQL server
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/adventure";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Tejas@412301";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Establish connection to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
            // Fetch all users and their ranks
            Statement stmt = conn.createStatement();
            String query = "SELECT * FROM ranks";
            ResultSet rs = stmt.executeQuery(query);
            
            // Display the ranks in a table format
            out.println("<table border='1'>");
            out.println("<tr><th>Username</th><th>Rank</th><th>Action</th></tr>");
            while (rs.next()) {
                String username = rs.getString("username");
                int rank = rs.getInt("rank");
                out.println("<tr>");
                out.println("<td>" + username + "</td>");
                out.println("<td>" + rank + "</td>");
                out.println("<td><a href='editRank.jsp?username=" + username + "&rank=" + rank + "'>Edit Rank</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Close the database connection
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle rank updates
        String username = request.getParameter("username");
        int newRank = Integer.parseInt(request.getParameter("rank"));

        try {
            // Establish connection to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Update rank in the database
            String updateQuery = "UPDATE ranks SET rank=? WHERE username=?";
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setInt(1, newRank);
            pstmt.setString(2, username);
            pstmt.executeUpdate();

            // Close the database connection
            conn.close();

            // Redirect back to the index page after the update
            response.sendRedirect("http://localhost:8080/AdventureMap1/main/Admin%20login%20page/index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
