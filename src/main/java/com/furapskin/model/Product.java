package com.furapskin.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product implements Reviewable {
    private int id;
    private Category category; // Concrete object type
    private String name;
    private String description;
    private double price;
    private int stock;
    private String brand;
    private String bpomId;
    private String imageUrl;
    private Timestamp createdAt;
    
    // In-memory representation for the interface
    private List<Review> reviews = new ArrayList<>();

    @Override
    public void addReview(Review review) {
        if (review != null) {
            reviews.add(review);
        }
    }

    @Override
    public double getAverageRating() {
        if (reviews == null || reviews.isEmpty()) {
            return 0.0;
        }
        double sum = 0;
        for (Review r : reviews) {
            sum += r.getRating();
        }
        return sum / reviews.size();
    }

    @Override
    public List<Review> getAllReviews() {
        return reviews;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getBpomId() { return bpomId; }
    public void setBpomId(String bpomId) { this.bpomId = bpomId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public void setReviews(List<Review> reviews) { this.reviews = reviews; }
}
