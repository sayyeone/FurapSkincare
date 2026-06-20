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
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
