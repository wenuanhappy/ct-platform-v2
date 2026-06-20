-- 创建数据库
CREATE DATABASE IF NOT EXISTS ct_platform
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ct_platform;

-- 用户表
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `email` VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
  `password` VARCHAR(255) NOT NULL COMMENT 'bcrypt加密后的密码',
  `role` VARCHAR(20) NOT NULL DEFAULT 'student' COMMENT '角色: student/teacher/admin',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
  `status` INT NOT NULL DEFAULT 1 COMMENT '账号状态: 1正常 0禁用',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0未删除 1已删除',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 用户会话表（用于JWT黑名单管理）
CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `token_jti` VARCHAR(64) NOT NULL UNIQUE COMMENT 'JWT ID（用于撤销）',
  `device_info` VARCHAR(255) DEFAULT NULL COMMENT '设备信息',
  `ip_address` VARCHAR(45) DEFAULT NULL COMMENT 'IP地址',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` DATETIME NOT NULL COMMENT 'Token过期时间',
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_token_jti` (`token_jti`),
  INDEX `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- 插入测试用户（密码为: Pass1234，使用BCrypt加密）
-- BCrypt加密后的密码: $2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.qV5zCnLIJ7H6LK
INSERT IGNORE INTO `users` (`username`, `email`, `password`, `role`, `status`) VALUES
('admin', 'admin@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.qV5zCnLIJ7H6LK', 'admin', 1),
('teacher01', 'teacher01@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.qV5zCnLIJ7H6LK', 'teacher', 1),
('student01', 'student01@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.qV5zCnLIJ7H6LK', 'student', 1);
