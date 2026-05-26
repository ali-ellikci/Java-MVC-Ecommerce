package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProductServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();
        List<Category> categories = null;
        try {
            categories = categoryDAO.getAllActive();
        } catch (Exception e) {
            throw new ServletException(e);
        }
        req.setAttribute("categories", categories);

        // Ürün detay sayfası
        if (uri.endsWith("/product-detail")) {
            String idParam = req.getParameter("id");
            if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/home"); return; }
            try {
                Product product = productDAO.getById(Integer.parseInt(idParam));
                if (product == null) { resp.sendRedirect(req.getContextPath() + "/home"); return; }
                req.setAttribute("product", product);
                req.getRequestDispatcher("/WEB-INF/views/public/product-detail.jsp")
                   .forward(req, resp);
            } catch (Exception e) { throw new ServletException(e); }
            return;
        }

        // Ürün listesi (kategoriye göre filtreli)
        try {
            String catParam = req.getParameter("categoryId");
            List<Product> products;
            Category selectedCategory = null;

            if (catParam != null && !catParam.isEmpty()) {
                int catId = Integer.parseInt(catParam);
                products = productDAO.getByCategory(catId);
                selectedCategory = categoryDAO.getById(catId);
            } else {
                products = productDAO.getAllActive();
            }
            req.setAttribute("products", products);
            req.setAttribute("selectedCategory", selectedCategory);
            req.getRequestDispatcher("/WEB-INF/views/public/products.jsp")
               .forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }
}
