package com.ctplatform.service;

import com.ctplatform.dto.*;

public interface AuthService {

    /**
     * 用户注册
     */
    ApiResponse<?> register(RegisterRequest request);

    /**
     * 用户登录
     */
    ApiResponse<LoginResponse> login(LoginRequest request);

    /**
     * 退出登录
     */
    ApiResponse<?> logout(String token);

    /**
     * 刷新 Token
     */
    ApiResponse<LoginResponse> refresh(String refreshToken);

    /**
     * 获取当前用户信息
     */
    ApiResponse<LoginResponse.UserInfo> getCurrentUser(String token);
}
