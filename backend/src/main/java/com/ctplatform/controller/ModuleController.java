package com.ctplatform.controller;

import com.ctplatform.dto.ApiResponse;
import com.ctplatform.dto.ModuleInfo;
import com.ctplatform.service.ModuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/modules")
public class ModuleController {

    @Autowired
    private ModuleService moduleService;

    /**
     * 获取所有模块列表
     */
    @GetMapping
    public ApiResponse<List<ModuleInfo>> getAllModules() {
        return moduleService.getAllModules();
    }

    /**
     * 获取指定模块详情
     */
    @GetMapping("/{id}")
    public ApiResponse<ModuleInfo> getModuleById(@PathVariable("id") String moduleId) {
        return moduleService.getModuleById(moduleId);
    }
}
