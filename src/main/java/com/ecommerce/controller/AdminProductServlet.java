package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class AdminProductServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getServletPath();

        switch (action) {
            case "/admin/products" -> {
                try {
                    req.setAttribute("products", productDAO.getAll());
                    req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/product/add" -> {
                try {
                    req.setAttribute("categories", categoryDAO.getAll());
                    req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/product/edit" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Product product = productDAO.getById(id);
                    List<Category> categories = categoryDAO.getAll();
                    req.setAttribute("product",    product);
                    req.setAttribute("categories", categories);
                    req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/product/delete" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    productDAO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/products?msg=deleted");
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/product/toggle" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Product p = productDAO.getById(id);
                    if (p != null) {
                        p.setActive(!p.isActive());
                        productDAO.update(p);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/products");
                } catch (Exception e) { throw new ServletException(e); }
            }
            default -> resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam     = req.getParameter("id");
        String name        = req.getParameter("name");
        String description = req.getParameter("description");
        String priceParam  = req.getParameter("price");
        String stockParam  = req.getParameter("stock");
        String catParam    = req.getParameter("categoryId");
        String imageUrl    = req.getParameter("imageUrl");
        boolean isActive   = "on".equals(req.getParameter("isActive"));

        // Sunucu tarafı validasyon
        String error = validateProduct(name, priceParam, stockParam, catParam);
        if (error != null) {
            try {
                req.setAttribute("error",      error);
                req.setAttribute("categories", categoryDAO.getAll());
                if (idParam != null && !idParam.isEmpty()) {
                    req.setAttribute("product", productDAO.getById(Integer.parseInt(idParam)));
                }
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
            } catch (Exception ex) { throw new ServletException(ex); }
            return;
        }

        try {
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description);
            product.setPrice(new BigDecimal(priceParam));
            product.setStock(Integer.parseInt(stockParam));
            product.setCategoryId(Integer.parseInt(catParam));
            product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            product.setActive(isActive);

            if (idParam != null && !idParam.isEmpty()) {
                product.setId(Integer.parseInt(idParam));
                productDAO.update(product);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=updated");
            } else {
                productDAO.save(product);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=added");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String validateProduct(String name, String price, String stock, String catId) {
        if (name == null || name.trim().isEmpty()) return "Ürün adı boş olamaz.";
        if (catId == null || catId.isEmpty())      return "Kategori seçilmelidir.";
        try {
            BigDecimal p = new BigDecimal(price);
            if (p.compareTo(BigDecimal.ZERO) <= 0) return "Fiyat 0'dan büyük olmalıdır.";
        } catch (Exception e) { return "Geçerli bir fiyat giriniz."; }
        try {
            int s = Integer.parseInt(stock);
            if (s < 0) return "Stok miktarı negatif olamaz.";
        } catch (Exception e) { return "Geçerli bir stok miktarı giriniz."; }
        return null;
    }
}
