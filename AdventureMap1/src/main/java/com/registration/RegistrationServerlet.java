package com.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RegistrationServerlet
 */
@WebServlet("/register")
public class RegistrationServerlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		String uname = request.getParameter("name");
		String uemail = request.getParameter("email");
		String upassward = request.getParameter("pass");
		RequestDispatcher dispatcher =null;
		Connection con=null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure?useSSL=false","root","Tejas@412301");
			PreparedStatement pst = con.prepareStatement("insert into users(uname,upassward,uemail)values(?,?,?)");
			
			pst.setString(1,uname);
			pst.setString(2,upassward);
			pst.setString(3,uemail);
			
			int rowCount = pst.executeUpdate();
			dispatcher = request.getRequestDispatcher("login.jsp");
			if(rowCount >0) {
				request.setAttribute("status","Success");
	
			}
			else {
				request.setAttribute("status","Failed");
			}
			
			dispatcher.forward(request,response);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
			con.close();
			}catch (SQLException i) {
				i.printStackTrace();
			}
		}
		
	}

}


