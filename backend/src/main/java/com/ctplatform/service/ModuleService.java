package com.ctplatform.service;

import com.ctplatform.dto.ApiResponse;
import com.ctplatform.dto.ModuleInfo;

import java.util.List;

public interface ModuleService {

    /**
     * 获取所有模块列表
     */
    ApiResponse<List<ModuleInfo>> getAllModules();

    /**
     * 获取指定模块详情
     */
    ApiResponse<ModuleInfo> getModuleById(String moduleId);
}
