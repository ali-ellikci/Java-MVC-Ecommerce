package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class HomeServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Product>  products   = productDAO.getAllActive();
            List<Category> categories = categoryDAO.getAllActive();
            String keyword = req.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                products = productDAO.search(keyword.trim());
                req.setAttribute("keyword", keyword.trim());
            }

            req.setAttribute("products",   products);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/WEB-INF/views/public/index.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
