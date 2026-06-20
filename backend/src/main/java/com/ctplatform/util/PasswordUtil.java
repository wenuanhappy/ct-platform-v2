package com.ctplatform.util;

import org.springframework.stereotype.Component;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

@Component
public class PasswordUtil {

    private static final int BCRYPT_ROUND = 12;

    /**
     * 使用 BCrypt 算法加密密码（实际项目推荐使用 Spring Security 的 BCryptPasswordEncoder）
     * 这里提供一个简单的 BCrypt 风格实现
     */
    public String encode(String rawPassword) {
        // 生成盐值
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);

        // 使用简单的哈希+盐的方式（生产环境推荐使用 BCrypt）
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(rawPassword.getBytes());

            // 组合盐值和哈希值
            byte[] combined = new byte[salt.length + hashed.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashed, 0, combined, salt.length, hashed.length);

            return "$2a$12$" + Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("密码加密失败", e);
        }
    }

    /**
     * 验证密码
     */
    public boolean matches(String rawPassword, String encodedPassword) {
        if (encodedPassword == null || !encodedPassword.startsWith("$2a$12$")) {
            return false;
        }

        try {
            // 提取存储的盐值和哈希
            byte[] combined = Base64.getDecoder().decode(encodedPassword.substring(7));
            byte[] salt = new byte[16];
            byte[] storedHash = new byte[combined.length - 16];
            System.arraycopy(combined, 0, salt, 0, 16);
            System.arraycopy(combined, 16, storedHash, 0, storedHash.length);

            // 使用相同的盐值哈希输入密码
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(rawPassword.getBytes());

            // 比较哈希值
            if (hashed.length != storedHash.length) {
                return false;
            }

            for (int i = 0; i < hashed.length; i++) {
                if (hashed[i] != storedHash[i]) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
