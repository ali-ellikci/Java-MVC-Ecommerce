package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Zaten giriş yapmışsa anasayfaya yönlendir
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Sunucu tarafı validasyon
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "E-posta ve şifre boş olamaz.");
            req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.findByEmail(email.trim().toLowerCase());
            if (user == null || !PasswordUtil.verify(password, user.getPassword())) {
                req.setAttribute("error", "E-posta veya şifre hatalı.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
                return;
            }

            // Session oluştur
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);

            // Gelmek istediği sayfaya yönlendir
            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.isEmpty()) {
                resp.sendRedirect(redirect);
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
