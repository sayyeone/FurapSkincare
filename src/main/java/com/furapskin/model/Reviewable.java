package com.furapskin.model;

import java.util.List;

public interface Reviewable {
    void addReview(Review review);
    double getAverageRating();
    List<Review> getAllReviews();
}
