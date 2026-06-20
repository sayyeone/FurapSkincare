package com.furapskin.servlet;

import com.furapskin.dao.ProductDAO;
import com.furapskin.model.Cart;
import com.furapskin.model.CartItem;
import com.furapskin.model.Product;
import com.furapskin.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            cart.setCustomerId(user.getId());
            session.setAttribute("cart", cart);
        }

        if ("/add".equals(pathInfo)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product p = productDAO.getProductById(productId);
            if (p != null) {
                int currentQty = 0;
                for (CartItem ci : cart.getItems()) {
                    if (ci.getProduct().getId() == productId) {
                        currentQty += ci.getQuantity();
                    }
                }
                
                if (currentQty + quantity > p.getStock()) {
                    response.sendRedirect(request.getContextPath() + "/catalog?error=stock&limit=" + p.getStock());
                    return;
                }
                
                boolean found = false;
                for (CartItem ci : cart.getItems()) {
                    if (ci.getProduct().getId() == productId) {
                        ci.setQuantity(ci.getQuantity() + quantity);
                        found = true;
                        break;
                    }
                }
                
                if (!found) {
                    CartItem item = new CartItem();
                    item.setProduct(p);
                    item.setQuantity(quantity);
                    cart.addItem(item);
                }
            }
            response.sendRedirect(request.getContextPath() + "/catalog?success=add");
        } else if ("/clear".equals(pathInfo)) {
            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
