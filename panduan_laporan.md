# 📄 Panduan Kode untuk Laporan Tugas Besar PBO
## Aplikasi FurapSkin — E-Commerce Skincare

> **Cara membaca dokumen ini:**
> - ✅ **SALIN PENUH** = tempel seluruh kode ke laporan
> - ✂️ **SALIN POTONGAN** = hanya tempel bagian yang ditandai saja
> - 📸 **SCREENSHOT SAJA** = tidak perlu kode, cukup screenshot tampilan di browser

---

# BAB 4.1 — LAYER MODEL (Konsep OOP)

> Layer Model berisi semua kelas Java yang merepresentasikan entitas bisnis.
> Di sinilah konsep OOP paling jelas terlihat.

---

## 4.1.1 Hierarki Pengguna — Inheritance & Encapsulation

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/User.java`
```java
package com.furapskin.model;

import java.sql.Timestamp;

public abstract class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String role;
    private Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
```
> **Konsep OOP:** `abstract class` — tidak bisa diinstansiasi langsung. Semua atribut bersifat `private` (Encapsulation), hanya bisa diakses lewat getter/setter.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Customer.java`
```java
package com.furapskin.model;

public class Customer extends User {
    private String phoneNumber;
    private String address;

    public Customer() {
        this.setRole("CUSTOMER");
    }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
```
> **Konsep OOP:** `extends User` — Inheritance. Customer mewarisi semua atribut User dan menambah `phoneNumber` dan `address` yang khas.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Admin.java`
```java
package com.furapskin.model;

public class Admin extends User {
    public Admin() {
        this.setRole("ADMIN");
    }
}
```
> **Konsep OOP:** Inheritance paling sederhana — Admin hanya perlu mewarisi User dan men-set role-nya. Tidak memerlukan atribut tambahan.

---

## 4.1.2 Abstraksi via Interface — Reviewable

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Reviewable.java`
```java
package com.furapskin.model;

import java.util.List;

public interface Reviewable {
    void addReview(Review review);
    double getAverageRating();
    List<Review> getAllReviews();
}
```
> **Konsep OOP:** Interface sebagai kontrak abstrak. Kelas apapun yang `implements Reviewable` wajib menyediakan ketiga method ini.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Product.java`
```java
package com.furapskin.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product implements Reviewable {
    private int id;
    private Category category;
    private String name;
    private String description;
    private double price;
    private int stock;
    private String brand;
    private String bpomId;
    private String imageUrl;
    private Timestamp createdAt;
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
```
> **Konsep OOP:** `implements Reviewable` (Interface), Asosiasi dengan `Category`, Encapsulation pada semua atribut private.

---

## 4.1.3 Hierarki Pembayaran — Abstract Class & Polymorphism

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Payment.java`
```java
package com.furapskin.model;

import java.sql.Timestamp;

public abstract class Payment {
    private int id;
    private int orderId;
    private double amount;
    private String paymentMethod;
    private PaymentStatus status;
    private Timestamp paymentDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public PaymentStatus getStatus() { return status; }
    public void setStatus(PaymentStatus status) { this.status = status; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    // Abstract method — wajib diimplementasikan oleh subclass
    public abstract void prosesPembayaran();
}
```
> **Konsep OOP:** Abstract Class dengan Abstract Method `prosesPembayaran()`. Kelas ini tidak bisa diinstansiasi langsung.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/BankTransfer.java`
```java
package com.furapskin.model;

public class BankTransfer extends Payment {
    private String buktiBayar;

    public BankTransfer() {
        this.setPaymentMethod("BANK_TRANSFER");
    }

    public String getBuktiBayar() { return buktiBayar; }
    public void setBuktiBayar(String buktiBayar) { this.buktiBayar = buktiBayar; }

    @Override
    public void prosesPembayaran() {
        this.setStatus(PaymentStatus.PENDING);
        this.setBuktiBayar("dummy_bank_instructions.txt");
    }
}
```
> **Konsep OOP:** Inheritance dari `Payment`, Override `prosesPembayaran()` — Polymorphism.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/EWallet.java`
```java
package com.furapskin.model;

import java.util.UUID;

public class EWallet extends Payment {
    private String transactionId;

    public EWallet() {
        this.setPaymentMethod("E_WALLET");
    }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    @Override
    public void prosesPembayaran() {
        this.setStatus(PaymentStatus.PENDING);
        this.setTransactionId("EWALLET-TX-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
    }
}
```
> **Konsep OOP:** Inheritance dari `Payment`, Override `prosesPembayaran()` dengan implementasi berbeda dari BankTransfer — inilah Polymorphism.

---

## 4.1.4 Enum Status

### ✅ SALIN PENUH (ketiga enum ini)
**Path:** `src/main/java/com/furapskin/model/OrderStatus.java`
```java
package com.furapskin.model;

public enum OrderStatus {
    PENDING,
    PAID,
    SHIPPED,
    COMPLETED,
    CANCELLED
}
```

**Path:** `src/main/java/com/furapskin/model/PaymentStatus.java`
```java
package com.furapskin.model;

public enum PaymentStatus {
    PENDING,
    SUCCESS,
    FAILED
}
```

**Path:** `src/main/java/com/furapskin/model/ShipmentStatus.java`
```java
package com.furapskin.model;

public enum ShipmentStatus {
    PREPARING,
    SHIPPED,
    DELIVERED
}
```

---

## 4.1.5 Model Pendukung — Composition

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Cart.java`
```java
package com.furapskin.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int id;
    private int customerId;
    private Timestamp createdAt;

    // Aggregation — Cart memiliki banyak CartItem
    private List<CartItem> items = new ArrayList<>();

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }

    public void addItem(CartItem item) {
        this.items.add(item);
    }

    public int getTotalPrice() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }
}
```
> **Konsep OOP:** Composition — `Cart` memiliki `List<CartItem>`. Method `getTotalPrice()` adalah contoh Encapsulation logika bisnis di dalam kelas.

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/CartItem.java`
```java
package com.furapskin.model;

public class CartItem {
    private int id;
    private int cartId;
    private Product product;
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
```

---

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/model/Order.java`
```java
package com.furapskin.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int id;
    private Customer customer;
    private Timestamp orderDate;
    private double totalAmount;
    private OrderStatus status;

    // Strict Composition
    private List<OrderItem> items = new ArrayList<>();
    private Payment payment;
    private Shipment shipment;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public OrderStatus getStatus() { return status; }
    public void setStatus(OrderStatus status) { this.status = status; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public Payment getPayment() { return payment; }
    public void setPayment(Payment payment) { this.payment = payment; }

    public Shipment getShipment() { return shipment; }
    public void setShipment(Shipment shipment) { this.shipment = shipment; }
}
```
> **Konsep OOP:** Strict Composition — satu Order mengandung Customer, List\<OrderItem\>, Payment, dan Shipment. Semua bagian bergantung pada Order.

---

# BAB 4.2 — LAYER DAO (Akses Database)

---

## 4.2.1 Koneksi Database

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/dao/DatabaseConnection.java`
```java
package com.furapskin.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    private static final String URL = "jdbc:mysql://furapskin-db:3306/furapskin_v2";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("CRITICAL: Failed to load MySQL JDBC Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```
> Static Factory Method untuk koneksi JDBC. Semua DAO menggunakan kelas ini sebagai satu-satunya titik koneksi ke database.

---

## 4.2.2 DAO Pengguna — Polymorphism saat Mapping

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/dao/UserDAO.java`
```java
package com.furapskin.dao;

import com.furapskin.model.Admin;
import com.furapskin.model.Customer;
import com.furapskin.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class UserDAO {

    public User authenticate(String email, String plainPassword) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (BCrypt.checkpw(plainPassword, hashedPassword)) {
                        return mapResultSetToUser(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean registerCustomer(Customer customer) {
        String sql = "INSERT INTO users (username, password, email, full_name, role, phone_number, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getUsername());
            String hashed = BCrypt.hashpw(customer.getPassword(), BCrypt.gensalt());
            stmt.setString(2, hashed);
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getFullName());
            stmt.setString(5, customer.getRole() != null ? customer.getRole() : "CUSTOMER");
            stmt.setString(6, customer.getPhoneNumber());
            stmt.setString(7, customer.getAddress());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        String role = rs.getString("role");
        User user;
        // Polymorphism: instansiasi kelas yang tepat berdasarkan role
        if ("ADMIN".equals(role)) {
            user = new Admin();
        } else {
            user = new Customer();
            ((Customer) user).setPhoneNumber(rs.getString("phone_number"));
            ((Customer) user).setAddress(rs.getString("address"));
        }
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
```
> **Konsep OOP:** Method `mapResultSetToUser()` mendemonstrasikan Polymorphism — variabel bertipe `User` (abstract) bisa menampung objek `Admin` atau `Customer` berdasarkan data di database (Upcasting).

---

## 4.2.3 DAO Produk — CRUD dengan PreparedStatement

### ✂️ SALIN POTONGAN
**Path:** `src/main/java/com/furapskin/dao/ProductDAO.java`
*(Salin bagian method getAllProducts() dan getProductById() saja)*
```java
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
```
> Menggunakan `PreparedStatement` untuk keamanan (mencegah SQL Injection).

---

## 4.2.4 DAO Order — Transaksi Multi-tabel

### ✂️ SALIN POTONGAN
**Path:** `src/main/java/com/furapskin/dao/OrderDAO.java`
*(Salin bagian method createOrder() — lines 12 s/d 85)*
```java
public boolean createOrder(Order order) {
    String insertOrderSql = "INSERT INTO orders (customer_id, total_amount, status) VALUES (?, ?, ?)";
    String insertItemSql  = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
    String insertPaymentSql = "INSERT INTO payments (order_id, amount, payment_method, status, bukti_bayar, transaction_id) VALUES (?, ?, ?, ?, ?, ?)";
    String insertShipmentSql = "INSERT INTO shipments (order_id, shipping_address, status) VALUES (?, ?, 'PREPARING')";

    try (Connection conn = DatabaseConnection.getConnection()) {
        conn.setAutoCommit(false); // Mulai transaksi

        try (PreparedStatement orderStmt = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
            orderStmt.setInt(1, order.getCustomer().getId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, order.getStatus().name());
            orderStmt.executeUpdate();

            try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    order.setId(orderId);

                    // Insert Order Items + kurangi stok
                    // Insert Payment (Composition dari Order)
                    // Insert Shipment (Composition dari Order)
                    // ... (lihat file lengkap)
                }
            }
        }
        conn.commit(); // Commit semua dalam satu transaksi
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
```
> Satu transaksi database (setAutoCommit false + commit) menjamin semua data Order, OrderItem, Payment, dan Shipment tersimpan bersama atau gagal semua — konsisten dengan relasi Composition di Model.

---

# BAB 4.3 — LAYER CONTROLLER (Servlet)

---

## 4.3.1 Controller Autentikasi

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/servlet/AuthServlet.java`
```java
package com.furapskin.servlet;

import com.furapskin.dao.UserDAO;
import com.furapskin.dao.CartDAO;
import com.furapskin.model.Customer;
import com.furapskin.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if ("/logout".equals(pathInfo)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                com.furapskin.model.Cart cart = (com.furapskin.model.Cart) session.getAttribute("cart");
                if (cart != null) {
                    cartDAO.saveCart(cart);
                }
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if ("/login".equals(pathInfo)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userDAO.authenticate(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                if ("CUSTOMER".equals(user.getRole())) {
                    com.furapskin.model.Cart dbCart = cartDAO.getCartByCustomerId(user.getId());
                    if (dbCart != null) {
                        session.setAttribute("cart", dbCart);
                    }
                }

                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer_dashboard.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } else if ("/register".equals(pathInfo)) {
            Customer customer = new Customer();
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(request.getParameter("password"));
            customer.setEmail(request.getParameter("email"));
            customer.setFullName(request.getParameter("fullName"));
            customer.setPhoneNumber(request.getParameter("phoneNumber"));
            customer.setAddress(request.getParameter("address"));

            String adminToken = request.getParameter("adminToken");
            if ("PBO2026".equals(adminToken)) {
                customer.setRole("ADMIN");
            } else {
                customer.setRole("CUSTOMER");
            }

            if (userDAO.registerCustomer(customer)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
            } else {
                request.setAttribute("error", "Registration failed. Username or email may already exist.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
}
```

---

## 4.3.2 Controller Checkout — Runtime Polymorphism

### ✅ SALIN PENUH
**Path:** `src/main/java/com/furapskin/servlet/CheckoutServlet.java`
```java
package com.furapskin.servlet;

import com.furapskin.dao.CartDAO;
import com.furapskin.dao.OrderDAO;
import com.furapskin.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");
        java.util.List<Integer> selectedIds = (java.util.List<Integer>) session.getAttribute("selectedCartItems");

        if (user == null || cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String shippingAddress = request.getParameter("address");

        Order order = new Order();
        order.setCustomer(user);
        order.setStatus(OrderStatus.PENDING);

        double total = 0;
        for (CartItem ci : cart.getItems()) {
            if (selectedIds.contains(ci.getProduct().getId())) {
                OrderItem oi = new OrderItem();
                oi.setProduct(ci.getProduct());
                oi.setQuantity(ci.getQuantity());
                oi.setPrice(ci.getProduct().getPrice());
                total += (oi.getPrice() * oi.getQuantity());
                order.getItems().add(oi);
            }
        }
        order.setTotalAmount(total);

        // *** RUNTIME POLYMORPHISM ***
        // Variabel bertipe abstract class Payment menampung subclass yang berbeda
        Payment payment;
        if ("BANK_TRANSFER".equals(paymentMethod)) {
            payment = new BankTransfer(); // Instansiasi subclass 1
        } else {
            payment = new EWallet();      // Instansiasi subclass 2
        }
        payment.setAmount(total);
        payment.prosesPembayaran(); // Java pilih method yang tepat saat runtime
        order.setPayment(payment);

        Shipment shipment = new Shipment();
        shipment.setShippingAddress(shippingAddress);
        order.setShipment(shipment);

        if (orderDAO.createOrder(order)) {
            cart.getItems().removeIf(ci -> selectedIds.contains(ci.getProduct().getId()));
            cartDAO.saveCart(cart);
            session.removeAttribute("selectedCartItems");
            response.sendRedirect(request.getContextPath() + "/customer_dashboard.jsp?orderSuccess=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=true");
        }
    }
}
```
> **Ini adalah contoh Runtime Polymorphism terjelas di seluruh proyek.** Baris `payment.prosesPembayaran()` memanggil implementasi yang berbeda tergantung apakah objeknya `BankTransfer` atau `EWallet`.

---

## 4.3.3 Controller Admin — CRUD & Otorisasi

### ✂️ SALIN POTONGAN
**Path:** `src/main/java/com/furapskin/servlet/AdminServlet.java`
*(Salin bagian pengecekan otorisasi dan ship-order saja)*
```java
@WebServlet("/admin/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize       = 1024 * 1024 * 10,
    maxRequestSize    = 1024 * 1024 * 50
)
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pengecekan Otorisasi Berbasis Role
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/dashboard".equals(pathInfo) || pathInfo == null) {
            request.setAttribute("ordersToShip", orderDAO.getOrdersToShip());
            request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
        }
        // ... (lihat file lengkap untuk path lainnya)
    }

    // Contoh Ship Order
    } else if ("/ship-order".equals(pathInfo)) {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String trackingNumber = "FURAP-" + (int)(Math.random() * 10000000);
        orderDAO.shipOrder(orderId, trackingNumber);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?shipped=true");
    }
}
```

---

# BAB 4.4 — LAYER VIEW

### 📸 SCREENSHOT SAJA (tidak perlu tempel kode)

Salin screenshot browser dari halaman-halaman berikut:

| Halaman | URL saat Aplikasi Jalan | Keterangan |
|---|---|---|
| Beranda | `http://localhost:8080/` | Tampilan utama toko |
| Login | `http://localhost:8080/login.jsp` | Form login |
| Register | `http://localhost:8080/register.jsp` | Form pendaftaran + field token admin |
| Katalog Produk | `http://localhost:8080/catalog` | Daftar semua produk |
| Keranjang | `http://localhost:8080/cart.jsp` | Isi keranjang belanja |
| Checkout | `http://localhost:8080/checkout.jsp` | Pilih metode pembayaran |
| Dashboard Customer | `http://localhost:8080/customer_dashboard.jsp` | Riwayat order customer |
| Dashboard Admin | `http://localhost:8080/admin/dashboard` | Panel admin utama |
| Manajemen Produk | `http://localhost:8080/admin/products` | CRUD produk admin |
| Laporan Penjualan | `http://localhost:8080/admin/sales` | Sales report admin |

---

# BAB 4.5 — STRUKTUR DATABASE

### ✅ SALIN PENUH
**Path:** `db/init/schema.sql`

> Tempel isi file `schema.sql` secara lengkap di laporan.
> Atau bisa juga screenshot ERD dari phpMyAdmin di `http://localhost:8081`.

---

# RINGKASAN FINAL

| Layer | Apa yang Masuk Laporan | Cara Masuknya |
|---|---|---|
| **Model** | Semua 11 file Java di folder `model/` | ✅ Full copy semua |
| **DAO** | `DatabaseConnection.java`, `UserDAO.java` full + potongan `ProductDAO`, `OrderDAO` | ✅ Full + ✂️ Potongan |
| **Controller** | `AuthServlet.java`, `CheckoutServlet.java` full + potongan `AdminServlet` | ✅ Full + ✂️ Potongan |
| **View** | Semua halaman JSP | 📸 Screenshot saja |
| **Database** | `db/init/schema.sql` | ✅ Full copy |
