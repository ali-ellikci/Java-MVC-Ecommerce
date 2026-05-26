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
        // Admin zaten giriş yapmışsa dashboard'a yönlendir
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        // Admin yoksa ilk ziyarette oluştur
        try {
            ensureAdminExists();
        } catch (Exception e) {
            // Hata varsa devam et, giriş sayfası açılsın
        }

        // Giriş sayfasını göster
        req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
    }

    private void ensureAdminExists() throws Exception {
        String adminEmail = "admin@admin.com";
        User existingAdmin = userDAO.findByEmail(adminEmail);
        String correctPassword = PasswordUtil.hash("admin123");

        if (existingAdmin == null) {
            // Admin yoksa oluştur
            User admin = new User();
            admin.setFullName("Admin Kullanıcı");
            admin.setEmail(adminEmail);
            admin.setPassword(correctPassword);
            admin.setPhone("05001234567");
            admin.setAddress("İstanbul, Türkiye");
            admin.setRole("admin");
            userDAO.save(admin);
        } else if (!"admin".equals(existingAdmin.getRole())) {
            // Admin rolü yok ise ekle
            userDAO.updateRole(adminEmail, "admin");
        } else if (!PasswordUtil.verify("admin123", existingAdmin.getPassword())) {
            // Şifre yanlış ise düzelt
            userDAO.updatePassword(adminEmail, correctPassword);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userDAO.findByEmail(email != null ? email.trim().toLowerCase() : "");
            if (user == null || !PasswordUtil.verify(password, user.getPassword())
                    || !"admin".equals(user.getRole())) {
                req.setAttribute("error", "Geçersiz admin bilgileri.");
                req.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession();
            session.setAttribute("adminUser", user);
            session.setAttribute("loggedUser", user);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
