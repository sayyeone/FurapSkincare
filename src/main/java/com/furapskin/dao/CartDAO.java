package com.furapskin.dao;

import java.sql.*;

public class CartDAO {

    public void clearCartByCustomerId(int customerId) {
        String sql = "DELETE FROM carts WHERE customer_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
