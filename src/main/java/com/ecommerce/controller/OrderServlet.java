package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getServletPath();
        User user = (User) req.getSession(false) != null
                ? (User) req.getSession(false).getAttribute("loggedUser") : null;

        switch (uri) {
            case "/my-orders" -> {
                if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
                try {
                    List<Order> orders = orderDAO.getByUserId(user.getId());
                    req.setAttribute("orders", orders);
                    req.getRequestDispatcher("/WEB-INF/views/public/my-orders.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/order-detail" -> {
                if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
                try {
                    int orderId = Integer.parseInt(req.getParameter("id"));
                    Order order = orderDAO.getById(orderId);
                    // Sadece kendi siparişlerini görebilir
                    if (order == null || order.getUserId() != user.getId()) {
                        resp.sendRedirect(req.getContextPath() + "/my-orders"); return;
                    }
                    List<OrderItem> items = orderDAO.getOrderItems(orderId);
                    order.setItems(items);
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/WEB-INF/views/public/order-detail.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            default -> resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Giriş kontrolü
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        // Sepeti al
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Toplam hesapla
        BigDecimal total = cart.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Order modeli
        Order order = new Order();
        order.setUserId(user.getId());
        order.setTotalAmount(total);
        order.setStatus("Beklemede");

        // OrderItem listesi
        List<OrderItem> items = new ArrayList<>();
        for (CartItem ci : cart.values()) {
            OrderItem oi = new OrderItem();
            oi.setProductId(ci.getProductId());
            oi.setQuantity(ci.getQuantity());
            oi.setUnitPrice(ci.getPrice());
            oi.setSubtotal(ci.getSubtotal());
            items.add(oi);
        }

        try {
            int orderId = orderDAO.saveOrderWithItems(order, items);
            // Sepeti temizle
            session.removeAttribute("cart");
            resp.sendRedirect(req.getContextPath() + "/order-detail?id=" + orderId + "&success=true");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
