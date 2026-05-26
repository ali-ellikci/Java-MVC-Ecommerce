package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Sepet işlemleri: görüntüle, ekle, çıkar, güncelle.
 * Sepet session'da Map<Integer, CartItem> olarak tutulur.
 */
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Sepeti göster
        req.getRequestDispatcher("/WEB-INF/views/public/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getServletPath();

        switch (action) {
            case "/cart/add"    -> handleAdd(req, resp);
            case "/cart/remove" -> handleRemove(req, resp);
            case "/cart/update" -> handleUpdate(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    /** Sepete ürün ekle */
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String productIdParam = req.getParameter("productId");
        String qtyParam       = req.getParameter("quantity");

        if (productIdParam == null) { resp.sendRedirect(req.getContextPath() + "/home"); return; }

        int productId = Integer.parseInt(productIdParam);
        int qty       = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;

        try {
            Product product = productDAO.getById(productId);
            if (product == null || !product.isActive()) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            Map<Integer, CartItem> cart = getOrCreateCart(req);
            CartItem item = cart.get(productId);

            if (item == null) {
                // Yeni kalem
                item = new CartItem(productId, product.getName(), product.getPrice(),
                                    0, product.getImageUrl(), product.getStock());
                cart.put(productId, item);
            }

            // Stok kontrolü
            int newQty = item.getQuantity() + qty;
            if (newQty > product.getStock()) {
                newQty = product.getStock();
                req.getSession().setAttribute("cartMsg", "Maksimum stok miktarına ulaşıldı!");
            } else {
                req.getSession().setAttribute("cartMsg", null);
            }
            item.setQuantity(newQty);
            item.setMaxStock(product.getStock());

        } catch (Exception e) {
            throw new ServletException(e);
        }

        // Geldiği sayfaya geri dön
        String referer = req.getHeader("Referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
    }

    /** Sepetten ürün çıkar */
    private void handleRemove(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        Map<Integer, CartItem> cart = getOrCreateCart(req);
        cart.remove(productId);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    /** Ürün adedini güncelle */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        int qty       = Integer.parseInt(req.getParameter("quantity"));

        Map<Integer, CartItem> cart = getOrCreateCart(req);
        CartItem item = cart.get(productId);

        if (item != null) {
            if (qty <= 0) {
                cart.remove(productId);
            } else {
                try {
                    Product p = productDAO.getById(productId);
                    int maxStock = (p != null) ? p.getStock() : item.getMaxStock();
                    item.setQuantity(Math.min(qty, maxStock));
                    item.setMaxStock(maxStock);
                } catch (Exception e) {
                    throw new ServletException(e);
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    /** Session'dan sepeti al, yoksa oluştur */
    @SuppressWarnings("unchecked")
    public static Map<Integer, CartItem> getOrCreateCart(HttpServletRequest req) {
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart =
                (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    /** Sepet toplam tutarı hesapla */
    public static BigDecimal getCartTotal(Map<Integer, CartItem> cart) {
        return cart.values().stream()
                   .map(CartItem::getSubtotal)
                   .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
