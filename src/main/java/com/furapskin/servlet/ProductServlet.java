package com.furapskin.servlet;

import com.furapskin.dao.ProductDAO;
import com.furapskin.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/catalog")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryIdParam = request.getParameter("categoryId");
        List<Product> products;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdParam);
            products = productDAO.getProductsByCategory(categoryId);
            request.setAttribute("selectedCategoryId", categoryId);
        } else {
            products = productDAO.getAllProducts();
        }
        
        List<com.furapskin.model.Category> categories = productDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.getRequestDispatcher("/catalog.jsp").forward(request, response);
    }
}
