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
    public java.util.List<Order> getOrdersToShip() {
        java.util.List<Order> list = new java.util.ArrayList<>();
        String sql = "SELECT o.id, o.order_date, o.total_amount, o.status, u.full_name as customer_name " +
                     "FROM orders o JOIN users u ON o.customer_id = u.id " +
                     "WHERE o.status = 'PAID' ORDER BY o.order_date ASC";
                     
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
                    
                    // Fetch Shipment
                    String sSql = "SELECT * FROM shipments WHERE order_id = ?";
                    try (PreparedStatement sStmt = conn.prepareStatement(sSql)) {
                        sStmt.setInt(1, o.getId());
                        try (ResultSet srs = sStmt.executeQuery()) {
                            if (srs.next()) {
                                Shipment s = new Shipment();
                                s.setId(srs.getInt("id"));
                                s.setTrackingNumber(srs.getString("tracking_number"));
                                s.setCarrier(srs.getString("carrier"));
                                s.setStatus(com.furapskin.model.ShipmentStatus.valueOf(srs.getString("status")));
                                s.setShippingAddress(srs.getString("shipping_address"));
                                s.setShippedDate(srs.getTimestamp("shipped_date"));
                                o.setShipment(s);
                            }
                        }
                    }
                    
                    // Fetch Items
                    String iSql = "SELECT i.*, p.name as product_name, p.image_url, " +
                                  "(SELECT COUNT(*) FROM reviews r WHERE r.order_item_id = i.id) as review_count " +
                                  "FROM order_items i JOIN products p ON i.product_id = p.id WHERE i.order_id = ?";
                    try (PreparedStatement iStmt = conn.prepareStatement(iSql)) {
                        iStmt.setInt(1, o.getId());
                        try (ResultSet irs = iStmt.executeQuery()) {
                            java.util.List<OrderItem> items = new java.util.ArrayList<>();
                            while (irs.next()) {
                                OrderItem item = new OrderItem();
                                item.setId(irs.getInt("id"));
                                item.setQuantity(irs.getInt("quantity"));
                                item.setPrice(irs.getDouble("price"));
                                item.setReviewed(irs.getInt("review_count") > 0);
                                
                                com.furapskin.model.Product p = new com.furapskin.model.Product();
                                p.setId(irs.getInt("product_id"));
                                p.setName(irs.getString("product_name"));
                                p.setImageUrl(irs.getString("image_url"));
                                item.setProduct(p);
                                
                                items.add(item);
                            }
                            o.setItems(items);
                        }
                    }
                    
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

    public boolean shipOrder(int orderId, String trackingNumber) {
        String updateOrder = "UPDATE orders SET status = 'SHIPPED' WHERE id = ?";
        String updateShipment = "UPDATE shipments SET tracking_number = ?, carrier = 'FurapExpress', status = 'IN_TRANSIT', shipped_date = NOW() WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement oStmt = conn.prepareStatement(updateOrder);
                 PreparedStatement sStmt = conn.prepareStatement(updateShipment)) {
                oStmt.setInt(1, orderId);
                oStmt.executeUpdate();
                
                sStmt.setString(1, trackingNumber);
                sStmt.setInt(2, orderId);
                sStmt.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean completeOrder(int orderId) {
        String updateOrder = "UPDATE orders SET status = 'COMPLETED' WHERE id = ?";
        String updateShipment = "UPDATE shipments SET status = 'DELIVERED' WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement oStmt = conn.prepareStatement(updateOrder);
                 PreparedStatement sStmt = conn.prepareStatement(updateShipment)) {
                oStmt.setInt(1, orderId);
                oStmt.executeUpdate();
                
                sStmt.setInt(1, orderId);
                sStmt.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Order getOrderById(int orderId) {
        Order o = null;
        String sql = "SELECT o.*, u.full_name as customer_name, u.email as customer_email " +
                     "FROM orders o JOIN users u ON o.customer_id = u.id WHERE o.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(com.furapskin.model.OrderStatus.valueOf(rs.getString("status")));
                    
                    com.furapskin.model.Customer c = new com.furapskin.model.Customer();
                    c.setId(rs.getInt("customer_id"));
                    c.setFullName(rs.getString("customer_name"));
                    c.setEmail(rs.getString("customer_email"));
                    o.setCustomer(c);
                    
                    // Fetch Payment
                    String pSql = "SELECT * FROM payments WHERE order_id = ?";
                    try (PreparedStatement pStmt = conn.prepareStatement(pSql)) {
                        pStmt.setInt(1, orderId);
                        try (ResultSet prs = pStmt.executeQuery()) {
                            if (prs.next()) {
                                String pMethod = prs.getString("payment_method");
                                if ("BANK_TRANSFER".equals(pMethod)) {
                                    com.furapskin.model.BankTransfer bt = new com.furapskin.model.BankTransfer();
                                    bt.setAmount(prs.getDouble("amount"));
                                    bt.setPaymentMethod(pMethod);
                                    bt.setStatus(com.furapskin.model.PaymentStatus.valueOf(prs.getString("status")));
                                    bt.setBuktiBayar(prs.getString("bukti_bayar"));
                                    o.setPayment(bt);
                                } else {
                                    com.furapskin.model.EWallet ew = new com.furapskin.model.EWallet();
                                    ew.setAmount(prs.getDouble("amount"));
                                    ew.setPaymentMethod(pMethod);
                                    ew.setStatus(com.furapskin.model.PaymentStatus.valueOf(prs.getString("status")));
                                    ew.setTransactionId(prs.getString("transaction_id"));
                                    o.setPayment(ew);
                                }
                            }
                        }
                    }
                    
                    // Fetch Shipment
                    String sSql = "SELECT * FROM shipments WHERE order_id = ?";
                    try (PreparedStatement sStmt = conn.prepareStatement(sSql)) {
                        sStmt.setInt(1, orderId);
                        try (ResultSet srs = sStmt.executeQuery()) {
                            if (srs.next()) {
                                Shipment s = new Shipment();
                                s.setId(srs.getInt("id"));
                                s.setTrackingNumber(srs.getString("tracking_number"));
                                s.setCarrier(srs.getString("carrier"));
                                s.setStatus(com.furapskin.model.ShipmentStatus.valueOf(srs.getString("status")));
                                s.setShippingAddress(srs.getString("shipping_address"));
                                s.setShippedDate(srs.getTimestamp("shipped_date"));
                                o.setShipment(s);
                            }
                        }
                    }
                    
                    // Fetch Items
                    String iSql = "SELECT i.*, p.name as product_name FROM order_items i JOIN products p ON i.product_id = p.id WHERE i.order_id = ?";
                    try (PreparedStatement iStmt = conn.prepareStatement(iSql)) {
                        iStmt.setInt(1, orderId);
                        try (ResultSet irs = iStmt.executeQuery()) {
                            java.util.List<OrderItem> items = new java.util.ArrayList<>();
                            while (irs.next()) {
                                OrderItem item = new OrderItem();
                                item.setId(irs.getInt("id"));
                                item.setQuantity(irs.getInt("quantity"));
                                item.setPrice(irs.getDouble("price"));
                                
                                com.furapskin.model.Product p = new com.furapskin.model.Product();
                                p.setId(irs.getInt("product_id"));
                                p.setName(irs.getString("product_name"));
                                item.setProduct(p);
                                
                                items.add(item);
                            }
                            o.setItems(items);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return o;
    }
}
