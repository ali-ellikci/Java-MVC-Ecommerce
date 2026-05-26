package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userDAO.findByEmail(email != null ? email.trim().toLowerCase() : "");
            if (user == null || !PasswordUtil.verify(password, user.getPassword())
                    || !"admin".equals(user.getRole())) {
                req.setAttribute("error", "Geçersiz admin bilgileri.");
                req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
                return;
            }
            req.getSession().setAttribute("adminUser", user);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
