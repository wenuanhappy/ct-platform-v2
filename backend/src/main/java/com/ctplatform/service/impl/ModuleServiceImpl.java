package com.ctplatform.service.impl;

import com.ctplatform.dto.ApiResponse;
import com.ctplatform.dto.ModuleInfo;
import com.ctplatform.exception.BusinessException;
import com.ctplatform.service.ModuleService;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class ModuleServiceImpl implements ModuleService {

    private static final List<ModuleInfo> MODULES = Arrays.asList(
            new ModuleInfo("turing", "图灵机", "探索计算理论的基石，通过可视化模拟理解图灵机的工作原理与停机问题",
                    "#4a90d9", "turing", "图灵机是计算理论中最基础的抽象计算模型。在这里，您将亲手操控一个可视化的图灵机模型，观察读写头如何在纸带上移动、读取和写入符号，直观理解状态转移、停机问题等核心概念。"),
            new ModuleInfo("complexity", "算法复杂度", "直观感受算法效率差异，通过动画对比理解时间与空间复杂度的实际意义",
                    "#5b9bd5", "complexity", "算法复杂度分析是评估算法效率的核心工具。通过交互式可视化工具，您将对比不同算法在不同规模数据下的运行表现，直观感受 O(1)、O(n)、O(n^2) 等复杂度的实际差异。"),
            new ModuleInfo("cellular", "元胞自动机", "一维与二维元胞自动机的可视化模拟，从简单规则中见证复杂系统的涌现",
                    "#3c7cc6", "cellular", "元胞自动机是由简单规则驱动的离散模型，能够产生令人惊叹的复杂行为。从一维的 Wolfram 规则到二维的生命游戏，您将亲手设置规则并观察系统如何从简单中涌现出复杂性。"),
            new ModuleInfo("circuit", "逻辑电路", "拖拽式搭建与门、或门、非门等逻辑电路，可视化布尔运算与组合逻辑",
                    "#6ba3d6", "circuit", "逻辑电路是数字系统的基础。在这个可视化实验室中，您可以拖拽组合各种逻辑门（与门、或门、非门、异或门等），搭建组合逻辑电路，实时观察输入与输出的关系。"),
            new ModuleInfo("datastruct", "数据结构", "数组、链表、栈、队列、树、图的动态可视化演示与交互操作",
                    "#2e6db5", "datastruct", "数据结构是程序设计的基础。通过交互式可视化工具，您可以动态操作各种数据结构——在数组中插入元素、遍历链表、压栈弹栈、构建二叉树——每一步操作都有清晰的视觉反馈。"),
            new ModuleInfo("algorithm", "算法", "排序、搜索、图遍历等经典算法的逐步可视化演示与分步调试",
                    "#7eb5e0", "algorithm", "经典算法是计算思维的精华。在这里，您可以看到冒泡排序的交换过程、快速排序的分区操作、Dijkstra 最短路径的逐步扩展——每个算法都配有分步调试和代码对照视图。"),
            new ModuleInfo("programming", "程序设计", "在线编程环境与可视化执行追踪，支持 C/Python 语言的交互式学习",
                    "#1a5da6", "programming", "程序设计模块提供一个轻量级的在线编程环境，支持 C 语言和 Python 的代码编写与执行追踪。配合可视化的变量监视器和执行流程图，帮助您深入理解程序的运行机制。"),
            new ModuleInfo("ai", "人工智能", "机器学习、神经网络、搜索算法的交互式演示与可视化训练过程",
                    "#4f8ed4", "ai", "人工智能模块涵盖从经典搜索算法（BFS、DFS、A*）到现代机器学习的基础概念。通过可视化训练过程、决策边界和网络结构，让抽象的 AI 概念变得触手可及。")
    );

    private static final Map<String, ModuleInfo> MODULE_MAP = MODULES.stream()
            .collect(Collectors.toMap(ModuleInfo::getId, Function.identity()));

    @Override
    public ApiResponse<List<ModuleInfo>> getAllModules() {
        return ApiResponse.success(MODULES);
    }

    @Override
    public ApiResponse<ModuleInfo> getModuleById(String moduleId) {
        ModuleInfo module = MODULE_MAP.get(moduleId);
        if (module == null) {
            throw new BusinessException(404, "模块不存在");
        }
        return ApiResponse.success(module);
    }
}
