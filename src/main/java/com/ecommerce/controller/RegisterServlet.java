package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");
        String address  = req.getParameter("address");

        // Sunucu tarafı validasyon
        String error = validate(fullName, email, password);
        if (error != null) {
            req.setAttribute("error",    error);
            req.setAttribute("fullName", fullName);
            req.setAttribute("email",    email);
            req.setAttribute("phone",    phone);
            req.setAttribute("address",  address);
            req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Email unique kontrolü
            if (userDAO.emailExists(email.trim().toLowerCase())) {
                req.setAttribute("error", "Bu e-posta adresi zaten kayıtlı.");
                req.setAttribute("fullName", fullName);
                req.setAttribute("phone",    phone);
                req.setAttribute("address",  address);
                req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
                return;
            }

            // Kullanıcı oluştur
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPassword(PasswordUtil.hash(password));
            user.setPhone(phone != null ? phone.trim() : "");
            user.setAddress(address != null ? address.trim() : "");
            user.setRole("customer");

            int newId = userDAO.save(user);
            user.setId(newId);

            // Otomatik giriş
            req.getSession().setAttribute("loggedUser", user);
            resp.sendRedirect(req.getContextPath() + "/home");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String validate(String fullName, String email, String password) {
        if (fullName == null || fullName.trim().isEmpty()) return "Ad soyad boş olamaz.";
        if (email    == null || email.trim().isEmpty())    return "E-posta boş olamaz.";
        if (!email.matches("^[\\w.+-]+@[\\w-]+\\.[\\w.]+$")) return "Geçerli bir e-posta adresi giriniz.";
        if (password == null || password.length() < 6)    return "Şifre en az 6 karakter olmalıdır.";
        return null;
    }
}
