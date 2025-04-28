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

/**
 * Servlet implementation class Adminlogin
 */
@WebServlet("/Adminlogin")
public class Adminlogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String  adminID= request.getParameter("username");
        String password = request.getParameter("password");

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
            pst = con.prepareStatement("SELECT * FROM admin WHERE adminID = ? AND password = ?");
            pst.setString(1, adminID);
            pst.setString(2, password);

            // Execute query
            rs = pst.executeQuery();

            if (rs.next()) {
                // If login is successful, store user email in session
                session.setAttribute("name", adminID);

                // Redirect to main page
                response.sendRedirect("http://localhost:8080/AdventureMap1/main/Admin%20login%20page/index.jsp");

            } else {
                // If login fails, set attribute to show failure and redirect back to login page
                session.setAttribute("status", "Failed");
                response.sendRedirect("http://localhost:8080/AdventureMap1/main/Admin%20login%20page/adminLogin.jsp");
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
