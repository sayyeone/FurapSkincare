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

    public void saveCart(com.furapskin.model.Cart cart) {
        if (cart == null) return;
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            // Delete old cart entirely
            clearCartByCustomerId(cart.getCustomerId());
            
            if (cart.getItems().isEmpty()) {
                conn.commit();
                return;
            }
            
            // Create new cart
            String insertCartSql = "INSERT INTO carts (customer_id) VALUES (?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertCartSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, cart.getCustomerId());
                stmt.executeUpdate();
                
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int cartId = rs.getInt(1);
                        cart.setId(cartId);
                        
                        // Insert items
                        String insertItemSql = "INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)";
                        try (PreparedStatement itemStmt = conn.prepareStatement(insertItemSql)) {
                            for (com.furapskin.model.CartItem item : cart.getItems()) {
                                itemStmt.setInt(1, cartId);
                                itemStmt.setInt(2, item.getProduct().getId());
                                itemStmt.setInt(3, item.getQuantity());
                                itemStmt.addBatch();
                            }
                            itemStmt.executeBatch();
                        }
                    }
                }
            }
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public com.furapskin.model.Cart getCartByCustomerId(int customerId) {
        com.furapskin.model.Cart cart = null;
        String cartSql = "SELECT * FROM carts WHERE customer_id = ?";
        String itemSql = "SELECT ci.*, p.*, c.name AS category_name, c.description AS category_desc " +
                         "FROM cart_items ci " +
                         "JOIN products p ON ci.product_id = p.id " +
                         "JOIN categories c ON p.category_id = c.id " +
                         "WHERE ci.cart_id = ?";
                         
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement cartStmt = conn.prepareStatement(cartSql)) {
            cartStmt.setInt(1, customerId);
            try (ResultSet rs = cartStmt.executeQuery()) {
                if (rs.next()) {
                    cart = new com.furapskin.model.Cart();
                    cart.setId(rs.getInt("id"));
                    cart.setCustomerId(rs.getInt("customer_id"));
                    cart.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                        itemStmt.setInt(1, cart.getId());
                        try (ResultSet itemRs = itemStmt.executeQuery()) {
                            while (itemRs.next()) {
                                com.furapskin.model.Product p = new com.furapskin.model.Product();
                                p.setId(itemRs.getInt("p.id"));
                                p.setName(itemRs.getString("p.name"));
                                p.setDescription(itemRs.getString("p.description"));
                                p.setPrice(itemRs.getDouble("p.price"));
                                p.setStock(itemRs.getInt("p.stock"));
                                p.setBrand(itemRs.getString("p.brand"));
                                p.setBpomId(itemRs.getString("p.bpom_id"));
                                p.setImageUrl(itemRs.getString("p.image_url"));
                                p.setCreatedAt(itemRs.getTimestamp("p.created_at"));
                                
                                com.furapskin.model.Category cat = new com.furapskin.model.Category();
                                cat.setId(itemRs.getInt("p.category_id"));
                                cat.setName(itemRs.getString("category_name"));
                                cat.setDescription(itemRs.getString("category_desc"));
                                p.setCategory(cat);
                                
                                com.furapskin.model.CartItem item = new com.furapskin.model.CartItem();
                                item.setProduct(p);
                                item.setQuantity(itemRs.getInt("quantity"));
                                cart.addItem(item);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }
}
