//package com.registration;

/*import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String uemail = request.getParameter("username");
        String upassward = request.getParameter("password");

        HttpSession session = request.getSession();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection to database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
            
            // Prepare SQL query with corrected column name
            pst = con.prepareStatement("SELECT * FROM users WHERE uemail = ? AND upassward = ?");
            pst.setString(1, uemail);
            pst.setString(2, upassward);

            // Execute query
            rs = pst.executeQuery();
            
            if (rs.next()) {
                // If login is successful, store user email in session and redirect to index
                session.setAttribute("name", uemail);
                response.sendRedirect("main/index.jsp");
            } else {
                // If login fails, set attribute to show failure and redirect back to login page
                session.setAttribute("status", "Failed");
                response.sendRedirect("login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
*/






package com.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String uemail = request.getParameter("username");
        String upassward = request.getParameter("password");

        HttpSession session = request.getSession();
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection to database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");

            // Prepare SQL query to authenticate user
            pst = con.prepareStatement("SELECT * FROM users WHERE uemail = ? AND upassward = ?");
            pst.setString(1, uemail);
            pst.setString(2, upassward);

            // Execute query
            rs = pst.executeQuery();

            if (rs.next()) {
                // If login is successful, store user email in session
                session.setAttribute("name", uemail);

                // Get user's points from 'users' table
                int points = rs.getInt("points");
                session.setAttribute("totalPoints", points);

                // Fetch user's rank from 'ranksdb' table using username
                PreparedStatement rankStmt = con.prepareStatement("SELECT user_Ranks FROM ranksdb WHERE username = ?");
                rankStmt.setString(1, uemail);
                ResultSet rankRs = rankStmt.executeQuery();

                String userRank = "None"; // Default if no rank found
                if (rankRs.next()) {
                    userRank = rankRs.getString("user_Ranks");
                }
                session.setAttribute("earnedBadge", userRank);

                // Close rank statement and result set
                rankRs.close();
                rankStmt.close();

                // Redirect to main page
                response.sendRedirect("main/index.jsp");

            } else {
                // If login fails, set attribute to show failure and redirect back to login page
                session.setAttribute("status", "Failed");
                response.sendRedirect("login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
