package com.furapskin.servlet;

import com.furapskin.dao.PaymentDAO;
import com.furapskin.dao.ProductDAO;
import com.furapskin.dao.OrderDAO;
import com.furapskin.model.User;
import com.furapskin.model.Product;
import com.furapskin.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AdminServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/products".equals(pathInfo)) {
            request.setAttribute("products", productDAO.getAllProducts());
            request.setAttribute("categories", productDAO.getAllCategories());
            request.getRequestDispatcher("/admin_products.jsp").forward(request, response);
        } else if ("/sales".equals(pathInfo)) {
            request.setAttribute("orders", orderDAO.getAllPaidOrders());
            request.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
            request.setAttribute("totalOrders", orderDAO.getTotalOrdersCount());
            request.setAttribute("lowStockProducts", productDAO.getLowStockProducts());
            
            com.furapskin.dao.ReviewDAO reviewDAO = new com.furapskin.dao.ReviewDAO();
            request.setAttribute("topRated", reviewDAO.getTopRatedProducts(3));
            request.setAttribute("worstRated", reviewDAO.getWorstRatedProducts(3));
            
            request.getRequestDispatcher("/admin_sales.jsp").forward(request, response);
        } else if ("/dashboard".equals(pathInfo) || pathInfo == null || "/".equals(pathInfo)) {
            request.setAttribute("pendingOrders", orderDAO.getPendingOrders());
            request.setAttribute("ordersToShip", orderDAO.getOrdersToShip());
            request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if ("/approve-payment".equals(pathInfo)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            paymentDAO.approvePayment(orderId);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=true");
            
        } else if ("/ship-order".equals(pathInfo)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String trackingNumber = "FURAP-" + (int)(Math.random() * 10000000);
            orderDAO.shipOrder(orderId, trackingNumber);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?shipped=true");
            
        } else if ("/add-product".equals(pathInfo)) {
            Product p = new Product();
            p.setName(request.getParameter("name"));
            p.setDescription(request.getParameter("description"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setBrand(request.getParameter("brand"));
            p.setBpomId(request.getParameter("bpomId"));
            
            Category cat = new Category();
            // Defaulting category to 1 for simplicity, or we can fetch it if form has it
            String catParam = request.getParameter("categoryId");
            cat.setId(catParam != null ? Integer.parseInt(catParam) : 1);
            p.setCategory(cat);
            
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9.-]", "_");
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String savePath = uploadPath + File.separator + fileName;
                filePart.write(savePath);
                
                p.setImageUrl("uploads/" + fileName);
            } else {
                p.setImageUrl("uploads/default.jpg");
            }
            
            productDAO.insertProduct(p);
            response.sendRedirect(request.getContextPath() + "/admin/products?success=true");
            
        } else if ("/delete-product".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.deleteProduct(id);
            response.sendRedirect(request.getContextPath() + "/admin/products?deleted=true");
            
        } else if ("/update-product".equals(pathInfo)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = productDAO.getProductById(id);
            if (p != null) {
                p.setName(request.getParameter("name"));
                p.setDescription(request.getParameter("description"));
                p.setPrice(Double.parseDouble(request.getParameter("price")));
                p.setStock(Integer.parseInt(request.getParameter("stock")));
                p.setBrand(request.getParameter("brand"));
                p.setBpomId(request.getParameter("bpomId"));
                
                Category cat = new Category();
                String catParam = request.getParameter("categoryId");
                cat.setId(catParam != null ? Integer.parseInt(catParam) : p.getCategory().getId());
                p.setCategory(cat);
                
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9.-]", "_");
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    String savePath = uploadPath + File.separator + fileName;
                    filePart.write(savePath);
                    p.setImageUrl("uploads/" + fileName);
                }
                
                productDAO.updateProduct(p);
            }
            response.sendRedirect(request.getContextPath() + "/admin/products?updated=true");
            
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
