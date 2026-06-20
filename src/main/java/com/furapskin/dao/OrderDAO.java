package com.furapskin.dao;

import com.furapskin.model.Order;
import com.furapskin.model.OrderItem;
import com.furapskin.model.Payment;
import com.furapskin.model.Shipment;

import java.sql.*;

public class OrderDAO {

    public boolean createOrder(Order order) {
        String insertOrderSql = "INSERT INTO orders (customer_id, total_amount, status) VALUES (?, ?, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String insertPaymentSql = "INSERT INTO payments (order_id, amount, payment_method, status, bukti_bayar, transaction_id) VALUES (?, ?, ?, ?, ?, ?)";
        String insertShipmentSql = "INSERT INTO shipments (order_id, shipping_address, status) VALUES (?, ?, 'PREPARING')";

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Transaction start for strict composition enforcement
            conn.setAutoCommit(false); 
            
            try (PreparedStatement orderStmt = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, order.getCustomer().getId());
                orderStmt.setDouble(2, order.getTotalAmount());
                orderStmt.setString(3, order.getStatus().name());
                orderStmt.executeUpdate();
                
                try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        order.setId(orderId);
                        
                        // Insert Order Items (Composition)
                        try (PreparedStatement itemStmt = conn.prepareStatement(insertItemSql)) {
                            for (OrderItem item : order.getItems()) {
                                itemStmt.setInt(1, orderId);
                                itemStmt.setInt(2, item.getProduct().getId());
                                itemStmt.setInt(3, item.getQuantity());
                                itemStmt.setDouble(4, item.getPrice());
                                itemStmt.addBatch();
                            }
                            itemStmt.executeBatch();
                        }
                        
                        // Insert Payment (Composition)
                        Payment p = order.getPayment();
                        if (p != null) {
                            try (PreparedStatement payStmt = conn.prepareStatement(insertPaymentSql)) {
                                payStmt.setInt(1, orderId);
                                payStmt.setDouble(2, p.getAmount());
                                payStmt.setString(3, p.getPaymentMethod());
                                payStmt.setString(4, p.getStatus().name());
                                
                                if ("BANK_TRANSFER".equals(p.getPaymentMethod())) {
                                    payStmt.setString(5, ((com.furapskin.model.BankTransfer) p).getBuktiBayar());
                                    payStmt.setNull(6, Types.VARCHAR);
                                } else {
                                    payStmt.setNull(5, Types.VARCHAR);
                                    payStmt.setString(6, ((com.furapskin.model.EWallet) p).getTransactionId());
                                }
                                payStmt.executeUpdate();
                            }
                        }
                        
                        // Insert Shipment (Composition)
                        Shipment s = order.getShipment();
                        if (s != null) {
                            try (PreparedStatement shipStmt = conn.prepareStatement(insertShipmentSql)) {
                                shipStmt.setInt(1, orderId);
                                shipStmt.setString(2, s.getShippingAddress());
                                shipStmt.executeUpdate();
                            }
                        }
                        
                        conn.commit();
                        return true;
                    }
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

    public java.util.List<Order> getAllPaidOrders() {
        java.util.List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.id, o.order_date, o.total_amount, o.status, u.full_name as customer_name " +
                     "FROM orders o JOIN users u ON o.customer_id = u.id " +
                     "WHERE o.status IN ('PAID', 'SHIPPED', 'COMPLETED') ORDER BY o.order_date DESC";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(com.furapskin.model.OrderStatus.valueOf(rs.getString("status")));
                
                com.furapskin.model.Customer c = new com.furapskin.model.Customer();
                c.setFullName(rs.getString("customer_name"));
                o.setCustomer(c);
                
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalRevenue() {
        double total = 0;
        String sql = "SELECT SUM(total_amount) FROM orders WHERE status IN ('PAID', 'SHIPPED', 'COMPLETED')";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public int getTotalOrdersCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE status IN ('PAID', 'SHIPPED', 'COMPLETED')";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
