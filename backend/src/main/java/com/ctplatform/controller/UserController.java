package com.ctplatform.controller;

import com.ctplatform.dto.*;
import com.ctplatform.service.UserService;
import com.ctplatform.util.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * 获取个人资料
     */
    @GetMapping("/profile")
    public ApiResponse<LoginResponse.UserInfo> getProfile(@RequestHeader("Authorization") String authHeader) {
        Long userId = extractUserId(authHeader);
        return userService.getProfile(userId);
    }

    /**
     * 更新个人资料
     */
    @PutMapping("/profile")
    public ApiResponse<?> updateProfile(
            @RequestHeader("Authorization") String authHeader,
            @Valid @RequestBody UpdateProfileRequest request) {
        Long userId = extractUserId(authHeader);
        return userService.updateProfile(userId, request);
    }

    /**
     * 修改密码
     */
    @PutMapping("/password")
    public ApiResponse<?> changePassword(
            @RequestHeader("Authorization") String authHeader,
            @Valid @RequestBody ChangePasswordRequest request) {
        Long userId = extractUserId(authHeader);
        return userService.changePassword(userId, request);
    }

    /**
     * 从 Authorization Header 中提取用户ID
     */
    private Long extractUserId(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new com.ctplatform.exception.BusinessException(401, "未提供有效的认证令牌");
        }
        String token = authHeader.substring(7);
        return jwtUtil.getUserId(token);
    }
}
