package com.furapskin.dao;

import com.furapskin.model.Admin;
import com.furapskin.model.Customer;
import com.furapskin.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDAO {
    
    /**
     * Authenticate user against database records.
     * Maps ResultSet fields into subclass via Single-Table Inheritance based on role column.
     */
    public User authenticate(String email, String plainPassword) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (BCrypt.checkpw(plainPassword, hashedPassword)) {
                        return mapResultSetToUser(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerCustomer(Customer customer) {
        String sql = "INSERT INTO users (username, password, email, full_name, role, phone_number, address) VALUES (?, ?, ?, ?, 'CUSTOMER', ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getUsername());
            String hashed = BCrypt.hashpw(customer.getPassword(), BCrypt.gensalt());
            stmt.setString(2, hashed);
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getFullName());
            stmt.setString(5, customer.getPhoneNumber());
            stmt.setString(6, customer.getAddress());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        User user;
        // Map Single-Table Inheritance rows to proper Object type
        if ("ADMIN".equals(role)) {
            user = new Admin();
        } else {
            user = new Customer();
            ((Customer) user).setPhoneNumber(rs.getString("phone_number"));
            ((Customer) user).setAddress(rs.getString("address"));
        }
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password")); 
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
