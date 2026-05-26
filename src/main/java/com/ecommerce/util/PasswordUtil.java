package com.ecommerce.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * BCrypt tabanlı şifre hashleme yardımcı sınıfı.
 */
public class PasswordUtil {

    private static final int WORK_FACTOR = 10;

    /**
     * Düz metin şifreyi BCrypt ile hashler.
     */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Düz metin şifreyi hash ile karşılaştırır.
     * @return true — şifre doğruysa
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    private PasswordUtil() {}
}
