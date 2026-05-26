package com.ecommerce.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Singleton veritabanı bağlantı yöneticisi.
 * WEB-INF/db.properties dosyasından bağlantı bilgilerini okur.
 */
public class DBConnection {

    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    static {
        Properties props = new Properties();
        try (InputStream is = DBConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (IOException e) {
            // Ignore, will check env vars next
        }

        driver   = System.getenv("DB_DRIVER");
        if (driver == null || driver.trim().isEmpty()) {
            driver = props.getProperty("db.driver", "org.postgresql.Driver");
        }

        url      = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = props.getProperty("db.url");
        }

        username = System.getenv("DB_USERNAME");
        if (username == null || username.trim().isEmpty()) {
            username = props.getProperty("db.username");
        }

        password = System.getenv("DB_PASSWORD");
        if (password == null) {
            password = props.getProperty("db.password");
        }

        if (url == null || username == null || password == null) {
            throw new RuntimeException("Veritabanı bağlantı bilgileri bulunamadı! " +
                    "Hem db.properties eksik hem de çevre değişkenleri (DB_URL, DB_USERNAME, DB_PASSWORD) tanımlanmamış.");
        }

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Veritabanı sürücüsü yüklenemedi: " + driver, e);
        }
    }

    /**
     * Yeni bir JDBC bağlantısı döndürür.
     * Her kullanım sonrası try-with-resources ile kapatılmalıdır.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    private DBConnection() {}
}
