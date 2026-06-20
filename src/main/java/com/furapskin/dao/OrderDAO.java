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
                        
                        // Insert Order Items and Update Stock (Composition)
                        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";
                        try (PreparedStatement itemStmt = conn.prepareStatement(insertItemSql);
                             PreparedStatement stockStmt = conn.prepareStatement(updateStockSql)) {
                            for (OrderItem item : order.getItems()) {
                                itemStmt.setInt(1, orderId);
                                itemStmt.setInt(2, item.getProduct().getId());
                                itemStmt.setInt(3, item.getQuantity());
                                itemStmt.setDouble(4, item.getPrice());
                                itemStmt.addBatch();
                                
                                stockStmt.setInt(1, item.getQuantity());
                                stockStmt.setInt(2, item.getProduct().getId());
                                stockStmt.addBatch();
                            }
                            itemStmt.executeBatch();
                            stockStmt.executeBatch();
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

    public java.util.List<Order> getOrdersByCustomerId(int customerId) {
        java.util.List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customer_id = ? ORDER BY order_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(com.furapskin.model.OrderStatus.valueOf(rs.getString("status")));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<Order> getPendingOrders() {
        java.util.List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS customer_name, p.status AS payment_status, p.payment_method " +
                     "FROM orders o " +
                     "JOIN users u ON o.customer_id = u.id " +
                     "JOIN payments p ON o.id = p.order_id " +
                     "WHERE o.status = 'PENDING'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(com.furapskin.model.OrderStatus.valueOf(rs.getString("status")));
                
                com.furapskin.model.Customer cust = new com.furapskin.model.Customer();
                cust.setFullName(rs.getString("customer_name"));
                o.setCustomer(cust);
                
                String pMethodStr = rs.getString("payment_method");
                if ("BANK_TRANSFER".equals(pMethodStr)) {
                    com.furapskin.model.BankTransfer bt = new com.furapskin.model.BankTransfer();
                    bt.setStatus(com.furapskin.model.PaymentStatus.valueOf(rs.getString("payment_status")));
                    o.setPayment(bt);
                } else {
                    com.furapskin.model.EWallet ew = new com.furapskin.model.EWallet();
                    ew.setStatus(com.furapskin.model.PaymentStatus.valueOf(rs.getString("payment_status")));
                    o.setPayment(ew);
                }
                
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
