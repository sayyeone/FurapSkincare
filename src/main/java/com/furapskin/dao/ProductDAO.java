package com.furapskin.dao;

import com.furapskin.model.Category;
import com.furapskin.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, c.description AS category_desc " +
                     "FROM products p JOIN categories c ON p.category_id = c.id";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int id) {
        String sql = "SELECT p.*, c.name AS category_name, c.description AS category_desc " +
                     "FROM products p JOIN categories c ON p.category_id = c.id WHERE p.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setStock(rs.getInt("stock"));
        p.setBrand(rs.getString("brand"));
        p.setBpomId(rs.getString("bpom_id"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Hydrate Category object for the Product composition requirement
        Category cat = new Category();
        cat.setId(rs.getInt("category_id"));
        cat.setName(rs.getString("category_name"));
        cat.setDescription(rs.getString("category_desc"));
        p.setCategory(cat);
        
        return p;
    }

    public void insertProduct(Product p) {
        String sql = "INSERT INTO products (category_id, name, description, price, stock, brand, bpom_id, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getCategory().getId());
            stmt.setString(2, p.getName());
            stmt.setString(3, p.getDescription());
            stmt.setDouble(4, p.getPrice());
            stmt.setInt(5, p.getStock());
            stmt.setString(6, p.getBrand() != null ? p.getBrand() : "FurapSkin");
            stmt.setString(7, p.getBpomId() != null ? p.getBpomId() : "NA000000000");
            stmt.setString(8, p.getImageUrl());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProduct(Product p) {
        String sql = "UPDATE products SET category_id=?, name=?, description=?, price=?, stock=?, brand=?, bpom_id=?, image_url=? WHERE id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getCategory().getId());
            stmt.setString(2, p.getName());
            stmt.setString(3, p.getDescription());
            stmt.setDouble(4, p.getPrice());
            stmt.setInt(5, p.getStock());
            stmt.setString(6, p.getBrand());
            stmt.setString(7, p.getBpomId());
            stmt.setString(8, p.getImageUrl());
            stmt.setInt(9, p.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Product> getLowStockProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, c.description AS category_desc " +
                     "FROM products p JOIN categories c ON p.category_id = c.id WHERE p.stock < 5";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                categories.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, c.description AS category_desc " +
                     "FROM products p JOIN categories c ON p.category_id = c.id WHERE c.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
