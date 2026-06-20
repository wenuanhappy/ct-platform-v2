package com.ctplatform.service;

import com.ctplatform.dto.*;

public interface UserService {

    /**
     * 获取用户个人资料
     */
    ApiResponse<LoginResponse.UserInfo> getProfile(Long userId);

    /**
     * 更新个人资料
     */
    ApiResponse<?> updateProfile(Long userId, UpdateProfileRequest request);

    /**
     * 修改密码
     */
    ApiResponse<?> changePassword(Long userId, ChangePasswordRequest request);
}
