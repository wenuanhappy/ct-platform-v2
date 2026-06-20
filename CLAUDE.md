# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

计算思维交互式仿真学习平台 - 基于 Vue3 + Spring Boot 的全栈 Web 应用，包含 8 个计算思维核心模块的交互式学习内容。

**技术栈**:
- 前端: Vue 3 + Vite + Pinia + Element Plus
- 后端: Spring Boot 3.2.5 + MyBatis-Plus 3.5.6 + MySQL + JWT (jjwt 0.12.5)

## 开发命令

### 前端
```bash
cd frontend
npm install          # 安装依赖
npm run dev          # 启动开发服务器 (http://localhost:5173)
npm run build        # 生产构建
npm run preview      # 预览构建结果
```

### 后端
```bash
cd backend
mvn spring-boot:run          # 启动后端
mvn clean package -DskipTests # 构建 JAR (输出: target/ct-platform-backend-1.0.0.jar)
```

### 一键启动
```bash
deploy.bat    # 首次部署：初始化数据库 + 构建后端 + 安装前端依赖
start.bat     # 启动所有服务 (MySQL + 后端 + 前端)
stop.bat      # 停止所有服务
```

## 架构要点

### 前端架构 (Vue 3 + Composition API)

**页面布局参数**（重要，不要随意修改）：

| 组件 | 参数 | 值 |
|------|------|-----|
| 顶部导航栏 | 高度 | 80px，position: fixed |
| 左侧导航栏 | 宽度 | 240px，position: fixed, top: 80px |
| 主内容区 | 左边距 | margin-left: 240px |
| 主内容区 | 上边距 | padding-top: 80px |
| 主内容区 | 最大宽度 | 1200px（首页）/ 1600px（模块详情页）|

**模块详情页特殊布局**：
- 理论面板：可折叠（默认展开），宽度可拖动调节（200px~600px，默认380px）
- 交互模拟区：占据主内容区剩余空间，优先展示
- 练习测验：固定在底部

**路由**: `@/router/index.js` - 使用 `beforeEach` 路由守卫检查认证状态
**状态管理**: `@/stores/auth.js` - Pinia store 管理 token/user/localStorage 同步
**HTTP 请求**: `@/utils/request.js` - Axios 实例，自动附加 JWT，自动刷新过期 token
**API 层**: `@/api/auth.js` 等封装了各模块的接口调用
**模块组件**: `@/views/ModuleView.vue` - 主容器，管理理论面板和模拟器显示

### 模块加载机制

8 个学习模块：
- **理论内容**：在 `ModuleView.vue` 中通过 `theoryContents` 对象定义（HTML格式）
- **模拟器组件**：在 `ModuleView.vue` 中通过动态 import 加载：

```javascript
const modules = {
  turing: () => import('./modules/TuringModule.vue'),
  complexity: () => import('./modules/ComplexityModule.vue'),
  cellular: () => import('./modules/CellularModule.vue'),
  circuit: () => import('./modules/CircuitModule.vue'),
  datastruct: () => import('./modules/DataStructModule.vue'),
  algorithm: () => import('./modules/AlgorithmModule.vue'),
  programming: () => import('./modules/ProgrammingModule.vue'),
  ai: () => import('./modules/AIModule.vue')
}
```

### 后端架构 (Spring Boot 3)

- **包结构**: `com.ctplatform` - controller/service/mapper/entity/dto/util/exception/config
- **JWT 工具**: `util/JwtUtil.java` - 生成/验证 token，使用 HS256 算法
- **CORS 配置**: `config/CorsConfig.java` - 使用 CorsFilter + YamlPropertiesFactoryBean
- **数据库**: MyBatis-Plus + MySQL，表结构在 `backend/src/main/resources/schema.sql`
- **逻辑删除**: 配置了 `logic-delete-field: deleted`，查询自动添加 `WHERE deleted=0`

### API 设计
统一响应格式: `{ code: 200, message: "...", data: {...}, timestamp: ... }`

**认证接口**:
- POST `/api/auth/register` - 用户注册
- POST `/api/auth/login` - 用户登录（返回 JWT）
- POST `/api/auth/logout` - 退出登录
- POST `/api/auth/refresh` - 刷新 Token
- GET `/api/auth/me` - 获取当前用户信息

**用户接口**: `/api/user/profile`, `/api/user/password`
**模块接口**: `/api/modules`
**健康检查**: `/api/health`

### 数据库
- 数据库名: `ct_platform`
- 核心表: `users`, `user_sessions`
- 测试账号: `student01` / `Pass1234!`
- 密码使用 BCrypt 加密

## 端口配置
- 前端开发服务器: `5173`
- 后端 API: `8080`
- MySQL: `3306`

## 常用配置文件
- `frontend/vite.config.js` - Vite 配置，包含 `@` 别名和 API 代理
- `frontend/src/components/AppHeader.vue` - 顶部导航栏（高度 80px）
- `frontend/src/components/AppSidebar.vue` - 侧边栏导航（宽度 240px）
- `frontend/src/views/ModuleView.vue` - 模块详情页（含可折叠理论面板）
- `frontend/src/views/modules/TuringModule.vue` - 图灵机模拟器组件示例
- `backend/src/main/resources/application.yml` - Spring Boot 配置
- `backend/src/main/resources/schema.sql` - 数据库初始化脚本

## 添加新模块步骤
1. 在 `ModuleView.vue` 的 `moduleConfig` 中添加模块配置（名称、副标题、颜色）
2. 在 `ModuleView.vue` 的 `theoryContents` 中添加理论知识点（HTML格式）
3. 在 `ModuleView.vue` 的 `modules` 对象中添加模拟器组件的动态导入
4. 在 `ModuleView.vue` 的 `icons` 中添加模块图标
5. 在 `DashboardView.vue` 的 `modules` 数组中添加卡片展示信息
6. 在 `AppSidebar.vue` 的 `modules` 数组中添加导航项
7. 在 `frontend/src/views/modules/` 目录下创建新的 Vue 模拟器组件

## 已知问题修复记录
- `CorsConfig` 使用 CorsFilter + YamlPropertiesFactoryBean 解决 YAML 列表读取问题
- 数据库表必须包含 `deleted` 字段（逻辑删除标记）
- 布局参数统一：顶部 80px、左侧 240px、主内容区自适应

## 代码规范
- 使用 Composition API (`<script setup>`)
- CSS 变量统一管理在 `frontend/src/assets/styles/variables.css`
- 组件样式使用 `scoped`
- 颜色使用 CSS 变量或模块配置颜色
