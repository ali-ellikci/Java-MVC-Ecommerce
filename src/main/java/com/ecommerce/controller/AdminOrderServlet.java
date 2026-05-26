package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    private static final List<String> VALID_STATUSES = Arrays.asList(
        "Beklemede", "Hazırlanıyor", "Kargoya Verildi", "Tamamlandı", "İptal Edildi"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getServletPath();

        switch (action) {
            case "/admin/orders" -> {
                try {
                    req.setAttribute("orders", orderDAO.getAll());
                    req.setAttribute("statuses", VALID_STATUSES);
                    req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/order-detail" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Order order = orderDAO.getById(id);
                    List<OrderItem> items = orderDAO.getOrderItems(id);
                    if (order != null) order.setItems(items);
                    req.setAttribute("order",    order);
                    req.setAttribute("statuses", VALID_STATUSES);
                    req.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            default -> resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Durum güncelleme
        try {
            int    orderId = Integer.parseInt(req.getParameter("orderId"));
            String status  = req.getParameter("status");
            if (VALID_STATUSES.contains(status)) {
                orderDAO.updateStatus(orderId, status);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/order-detail?id=" + orderId + "&msg=updated");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
