package com.furapskin.servlet;

import com.furapskin.dao.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/test-db")
public class TestConnectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                request.setAttribute("status", "CONNECTED");
            } else {
                request.setAttribute("status", "FAILED");
                request.setAttribute("error", "Koneksi database tertutup atau null.");
            }
        } catch (SQLException e) {
            request.setAttribute("status", "FAILED");
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            request.setAttribute("status", "FAILED");
            request.setAttribute("error", e.getMessage());
        }
        
        request.getRequestDispatcher("/test_konek.jsp").forward(request, response);
    }
}
