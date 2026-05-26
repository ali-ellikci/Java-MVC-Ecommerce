package com.ecommerce.util;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Uygulama ilk başlatıldığında admin kullanıcısını kontrol eder ve yoksa
 * oluşturur.
 */
@WebListener
public class AdminUserInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            UserDAO userDAO = new UserDAO();
            String adminEmail = "admin@admin.com";
            String correctPassword = PasswordUtil.hash("admin123");
            User existingAdmin = userDAO.findByEmail(adminEmail);

            if (existingAdmin == null) {
                // Admin kullanıcısı yoksa yeni oluştur
                User admin = new User();
                admin.setFullName("Admin Kullanıcı");
                admin.setEmail(adminEmail);
                admin.setPassword(correctPassword);
                admin.setPhone("05001234567");
                admin.setAddress("İstanbul, Türkiye");
                admin.setRole("admin");
                userDAO.save(admin);
                sce.getServletContext().log("Admin kullanıcı oluşturuldu: " + adminEmail);
            } else if (!"admin".equals(existingAdmin.getRole())) {
                // Email var ama admin rolü yok ise uyar
                sce.getServletContext().log("Uyarı: " + adminEmail + " kayıtlı ancak admin rolüne sahip değil.");
            } else {
                // Admin varsa şifresini doğru şifre ile güncelle (eski veritabanı desteği)
                try {
                    if (!PasswordUtil.verify("admin123", existingAdmin.getPassword())) {
                        userDAO.updatePassword(adminEmail, correctPassword);
                        sce.getServletContext().log("Admin şifresi güncellendi: " + adminEmail);
                    } else {
                        sce.getServletContext().log("Admin kullanıcı zaten mevcut ve şifresi doğru: " + adminEmail);
                    }
                } catch (Exception e) {
                    sce.getServletContext().log("Admin şifresi kontrolü sırasında hata: " + e.getMessage());
                }
            }
        } catch (Exception e) {
            sce.getServletContext().log("Admin kullanıcı kontrolü başarısız oldu.", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do.
    }
}
