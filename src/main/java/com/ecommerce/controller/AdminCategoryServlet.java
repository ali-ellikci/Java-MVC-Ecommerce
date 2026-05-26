package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminCategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getServletPath();

        switch (action) {
            case "/admin/categories" -> {
                try {
                    req.setAttribute("categories", categoryDAO.getAll());
                    req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/category/add" -> {
                req.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(req, resp);
            }
            case "/admin/category/edit" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Category cat = categoryDAO.getById(id);
                    req.setAttribute("category", cat);
                    req.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(req, resp);
                } catch (Exception e) { throw new ServletException(e); }
            }
            case "/admin/category/delete" -> {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean deleted = categoryDAO.delete(id);
                    String msg = deleted ? "deleted" : "deactivated";
                    resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=" + msg);
                } catch (Exception e) { throw new ServletException(e); }
            }
            default -> resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam      = req.getParameter("id");
        String name         = req.getParameter("name");
        String description  = req.getParameter("description");
        boolean isActive    = "on".equals(req.getParameter("isActive"));

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Kategori adı boş olamaz.");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    req.setAttribute("category", categoryDAO.getById(Integer.parseInt(idParam)));
                } catch (Exception ex) { throw new ServletException(ex); }
            }
            req.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(req, resp);
            return;
        }

        try {
            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description);
            category.setActive(isActive);

            if (idParam != null && !idParam.isEmpty()) {
                category.setId(Integer.parseInt(idParam));
                categoryDAO.update(category);
                resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=updated");
            } else {
                categoryDAO.save(category);
                resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=added");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
