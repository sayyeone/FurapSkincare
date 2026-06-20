package com.furapskin.model;

public class CartItem {
    private int id;
    private int cartId;
    private Product product; // Composition with product details
    private int quantity;
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public int getSubtotal() {
        return (product != null) ? (int) product.getPrice() * quantity : 0;
    }
}
