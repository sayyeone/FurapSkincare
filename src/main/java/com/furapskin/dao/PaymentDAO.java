package com.furapskin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PaymentDAO {

    /**
     * Admin approval mechanism: simultaneously UPDATE the payments.status to 'SUCCESS' 
     * and the corresponding orders.status to 'PAID'.
     */
    public boolean approvePayment(int orderId) {
        String updatePaymentSql = "UPDATE payments SET status = 'SUCCESS' WHERE order_id = ?";
        String updateOrderSql = "UPDATE orders SET status = 'PAID' WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // DB Transaction
            
            try (PreparedStatement payStmt = conn.prepareStatement(updatePaymentSql);
                 PreparedStatement orderStmt = conn.prepareStatement(updateOrderSql)) {
                
                payStmt.setInt(1, orderId);
                int pRows = payStmt.executeUpdate();
                
                orderStmt.setInt(1, orderId);
                int oRows = orderStmt.executeUpdate();
                
                // Only commit if both the payment and the order were successfully updated
                if (pRows > 0 && oRows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
