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

        if (user == null || cart == null || cart.getItems().isEmpty() || selectedIds == null || selectedIds.isEmpty()) {
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

        // Strict Composition: Payment Subclass Instance Creation
        Payment payment;
        if ("BANK_TRANSFER".equals(paymentMethod)) {
            payment = new BankTransfer();
        } else {
            payment = new EWallet();
        }
        payment.setAmount(total);
        payment.prosesPembayaran(); // Execute subclass-specific mocked payment logic
        order.setPayment(payment);

        // Strict Composition: Shipment Instance Creation
        Shipment shipment = new Shipment();
        shipment.setShippingAddress(shippingAddress);
        order.setShipment(shipment);

        // Persist complex aggregated tree in a single transaction
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
