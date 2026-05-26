package com.ecommerce.controller;

import com.ecommerce.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO     userDAO     = new UserDAO();
    private final OrderDAO    orderDAO    = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalProducts",   productDAO.getTotalCount());
            req.setAttribute("totalCategories", categoryDAO.getTotalCount());
            req.setAttribute("totalUsers",       userDAO.getTotalCount());
            req.setAttribute("totalOrders",      orderDAO.getTotalCount());
            req.setAttribute("pendingOrders",    orderDAO.getPendingCount());
            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
