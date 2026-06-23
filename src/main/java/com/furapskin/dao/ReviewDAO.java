package com.furapskin.dao;

import com.furapskin.model.Product;
import com.furapskin.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(int productId, int customerId, int rating, String comment, int orderItemId) {
        String sql = "INSERT INTO reviews (product_id, customer_id, rating, comment, order_item_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, customerId);
            stmt.setInt(3, rating);
            stmt.setString(4, comment);
            stmt.setInt(5, orderItemId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getTopRatedProducts(int limit) {
        return getRatedProducts(limit, "DESC", "HAVING avg_rating >= 4.0");
    }

    public List<Product> getWorstRatedProducts(int limit) {
        return getRatedProducts(limit, "ASC", "HAVING avg_rating < 4.0");
    }

    private List<Product> getRatedProducts(int limit, String sortOrder, String havingClause) {
        List<Product> products = new ArrayList<>();
        // Fetch products, calculate average rating, and count total reviews
        String sql = "SELECT p.*, AVG(r.rating) as avg_rating, COUNT(r.id) as review_count " +
                     "FROM products p " +
                     "JOIN reviews r ON p.id = r.product_id " +
                     "GROUP BY p.id " +
                     havingClause + " " +
                     "ORDER BY avg_rating " + sortOrder + ", review_count DESC " +
                     "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setImageUrl(rs.getString("image_url"));
                    
                    // We can populate an aggregate representation inside Product's reviews list,
                    // or we can simply use the returned avg_rating in a dummy Review object to pass it to JSP easily.
                    // Since Product has getAverageRating() which calculates from its list, we can inject dummy reviews
                    // to reflect the correct average in the UI.
                    double avgRating = rs.getDouble("avg_rating");
                    int count = rs.getInt("review_count");
                    
                    List<Review> dummyReviews = new ArrayList<>();
                    // To make getAverageRating() return avgRating, we just insert one review with rating = avgRating.
                    // Wait, Review.rating is int. Let's just create a temporary hack or use a Map in JSP.
                    // Actually, let's just insert one dummy review with the rounded avgRating.
                    Review dummy = new Review();
                    dummy.setRating((int) Math.round(avgRating));
                    dummy.setComment(count + " reviews"); // store count in comment for easy retrieval
                    dummyReviews.add(dummy);
                    p.setReviews(dummyReviews);
                    
                    products.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
