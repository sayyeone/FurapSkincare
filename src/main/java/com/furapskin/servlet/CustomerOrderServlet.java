package com.furapskin.servlet;

import com.furapskin.dao.OrderDAO;
import com.furapskin.model.Order;
import com.furapskin.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/customer/*")
public class CustomerOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/invoice".equals(pathInfo)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            
            // Security check: only the owner or an ADMIN can view the invoice
            if (order != null && (order.getCustomer().getId() == user.getId() || "ADMIN".equals(user.getRole()))) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/invoice.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/receive-order".equals(pathInfo)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && order.getCustomer().getId() == user.getId()) {
                orderDAO.completeOrder(orderId);
            }
            response.sendRedirect(request.getContextPath() + "/customer_dashboard.jsp?received=true");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
