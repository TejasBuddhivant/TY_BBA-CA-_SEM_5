package com.registration;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/UploadLocation")
@MultipartConfig // Enables file uploading
public class UploadLocation extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String locationName = request.getParameter("locationName");
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");
        
        // Get the image file part
        Part imagePart = request.getPart("image");

        // Define the path where images will be saved
        String imageSavePath = "D:/TY-BBACA-SEM5-PROJECT/AdventureMap1/src/main/webapp/main/images/"; // Make sure this directory exists on your server
       
        
        // Extract image name
        String imageName = extractFileName(imagePart);
        String fullImagePath = imageSavePath + imageName;

        // Save image to disk
        saveImageToFile(imagePart, fullImagePath);
        
        // Save location data to the database
        Connection con = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/adventure", "root", "Tejas@412301");
            String insertQuery = "INSERT INTO locations (location_name, latitude, longitude, image_path) VALUES (?, ?, ?, ?)";
            pst = con.prepareStatement(insertQuery);
            pst.setString(1, locationName);
            pst.setString(2, latitude);
            pst.setString(3, longitude);
            pst.setString(4, fullImagePath);  // Save the image path to the database
            pst.executeUpdate();

            // Redirect or send success response
            response.sendRedirect("http://localhost:8080/AdventureMap1/main/Admin%20login%20page/index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            //response.sendRedirect("error.jsp");
            System.out.println("errror found !!!");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to extract file name
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }

    // Helper method to save the image to the server
    private void saveImageToFile(Part part, String fullImagePath) throws IOException {
        try (InputStream inputStream = part.getInputStream();
             FileOutputStream outputStream = new FileOutputStream(new File(fullImagePath))) {
            byte[] buffer = new byte[1024];
            int bytesRead = -1;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
