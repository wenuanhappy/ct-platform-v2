# 计算思维交互式仿真学习平台 - 项目设计文档

> 本文档详细描述了"计算思维交互式仿真学习平台"全栈Web应用的技术架构、设计方案与实现细节。

---

## 1. 项目概述

### 1.1 项目背景

本项目基于已有的一套计算思维学习平台前端登录界面，将其从静态页面扩展为一套完整的全栈Web应用，实现用户注册、登录及8个教学子模块的功能完整系统。

### 1.2 项目目标

- 将原有静态 HTML 前端重构为 Vue3 单页应用（SPA）
- 构建 Spring Boot + MySQL 后端服务，提供 RESTful API
- 实现基于 JWT 的无状态身份认证与会话管理
- 完成8个子功能模块的前后端集成
- 提供完整的设计文档与部署使用文档

### 1.3 技术栈

| 层级 | 技术选型 | 版本说明 |
|------|---------|---------|
| 前端框架 | Vue 3 + Vite | Composition API，全家桶 |
| 状态管理 | Pinia | 轻量级 Vue3 状态管理 |
| HTTP 客户端 | Axios | 请求拦截器 + JWT 自动附加 |
| UI 组件库 | Element Plus | Vue3 组件库 |
| 后端框架 | Spring Boot 3.2.5 | Java 17+ |
| 数据库 | MySQL 8.0 | 关系型数据库 |
| ORM 框架 | MyBatis-Plus 3.5.6 | 简化 CRUD 操作 |
| 认证方式 | JWT (jjwt 0.12.5) | 无状态 Token 认证 |
| 构建工具 | Maven | 后端依赖管理 |
| 包管理器 | npm | 前端依赖管理 |

---

## 2. 系统架构

### 2.1 整体架构图

```
┌─────────────────────────────────────────────────────┐
│                    用户浏览器                        │
│              (Vue3 SPA 前端应用)                      │
└──────────────────────┬──────────────────────────────┘
                       │ HTTP/HTTPS + JWT
                       ▼
┌─────────────────────────────────────────────────────┐
│                  Spring Boot                         │
│                  REST API (:8080)                    │
│                  - Auth API                          │
│                  - User API                          │
│                  - Module API                        │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                    MySQL 8                          │
│                 Database (:3306)                    │
│                 - ct_platform                       │
└─────────────────────────────────────────────────────┘
```

### 2.2 前端架构

#### 2.2.1 路由设计

```
/login              -> LoginView.vue          [公开]
/register           -> RegisterView.vue       [公开]
/dashboard          -> DashboardView.vue      [需认证]
/module/:id         -> ModuleView.vue         [需认证]
/profile            -> ProfileView.vue        [需认证]
```

> 所有需要认证的路由，均通过 Vue Router 的导航守卫（`beforeEach`）检查 Token 有效性。

#### 2.2.2 状态管理（Pinia）

```javascript
// auth.js store
- token: 访问令牌
- refreshToken: 刷新令牌
- user: 当前用户信息
- isAuthenticated: 是否已登录（computed）
- actions: login(), logout(), refreshToken(), fetchUser()
```

#### 2.2.3 Axios 请求拦截器

```javascript
// 请求拦截器：自动附加 JWT
axios.interceptors.request.use(config => {
  const token = localStorage.getItem('accessToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器：处理 401（Token 过期）
axios.interceptors.response.use(
  response => response,
  async error => {
    if (error.response?.status === 401 && !isRefreshing) {
      const refreshed = await authStore.refreshToken()
      if (refreshed) {
        return axios(error.config)
      } else {
        router.push('/login')
      }
    }
    return Promise.reject(error)
  }
)
```

### 2.3 后端架构

#### 2.3.1 包结构

```
com.ctplatform
├── CtApplication.java          # 启动类
├── config/
│   └── CorsConfig.java         # CORS 跨域配置
├── controller/
│   ├── AuthController.java     # 认证接口（注册/登录/刷新/退出）
│   ├── UserController.java     # 用户信息接口
│   ├── ModuleController.java   # 模块数据接口
│   └── HealthController.java   # 健康检查接口
├── service/
│   ├── AuthService.java        # 认证业务接口
│   ├── UserService.java        # 用户业务接口
│   ├── ModuleService.java      # 模块业务接口
│   └── impl/
│       ├── AuthServiceImpl.java
│       ├── UserServiceImpl.java
│       └── ModuleServiceImpl.java
├── mapper/
│   ├── UserMapper.java         # MyBatis Mapper
│   └── UserSessionMapper.java
├── entity/
│   ├── User.java               # 用户实体类
│   └── UserSession.java        # 会话实体类
├── dto/
│   ├── ApiResponse.java        # 统一响应格式
│   ├── LoginRequest.java
│   ├── LoginResponse.java
│   ├── RegisterRequest.java
│   ├── ChangePasswordRequest.java
│   ├── UpdateProfileRequest.java
│   └── ModuleInfo.java
├── util/
│   ├── JwtUtil.java            # JWT 工具类
│   └── PasswordUtil.java       # 密码加密工具
└── exception/
    ├── BusinessException.java
    └── GlobalExceptionHandler.java
```

---

## 3. 数据库设计

### 3.1 ER 图

```
┌─────────────────┐
│     users       │
├─────────────────┤
│ id (PK, BIGINT) │
│ username        │
│ email           │
│ password (hash) │
│ role            │
│ avatar          │
│ status          │
│ deleted         │
│ created_at      │
│ updated_at      │
└────────┬────────┘
         │ 1:N
         ▼
┌─────────────────┐
│  user_sessions  │
├─────────────────┤
│ id (PK)         │
│ user_id (FK)    │
│ token_jti       │
│ device_info     │
│ ip_address      │
│ created_at      │
│ expires_at      │
└─────────────────┘
```

### 3.2 表结构

#### users 表

```sql
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
```

#### user_sessions 表

```sql
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户会话表';
```

---

## 4. API 设计

### 4.1 统一响应格式

所有 API 响应遵循以下 JSON 格式：

```json
{
  "code": 200,          // 业务状态码：200成功，401未授权，403禁止，404未找到，500服务器错误
  "message": "操作成功", // 提示信息
  "data": { ... },      // 响应数据体
  "timestamp": 1748450000000  // 时间戳（毫秒）
}
```

### 4.2 认证接口（Auth）

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| POST | `/api/auth/register` | 用户注册 | 否 |
| POST | `/api/auth/login` | 用户登录（返回 JWT） | 否 |
| POST | `/api/auth/logout` | 退出登录（Token 加入黑名单） | 是 |
| POST | `/api/auth/refresh` | 刷新 Token | 是 |
| GET  | `/api/auth/me` | 获取当前用户信息 | 是 |

#### POST /api/auth/register

**请求体：**
```json
{
  "username": "zhangsan",
  "email": "zhangsan@example.com",
  "password": "Pass1234!"
}
```

**响应（200）：**
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "userId": 1,
    "username": "zhangsan"
  }
}
```

#### POST /api/auth/login

**请求体：**
```json
{
  "username": "zhangsan",
  "password": "Pass1234!"
}
```

**响应（200）：**
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
    "tokenType": "Bearer",
    "expiresIn": 7200,
    "user": {
      "id": 1,
      "username": "zhangsan",
      "email": "zhangsan@example.com",
      "role": "student",
      "avatar": null
    }
  }
}
```

### 4.3 用户信息接口（User）

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| GET | `/api/user/profile` | 获取个人资料 | 是 |
| PUT | `/api/user/profile` | 更新个人资料 | 是 |
| PUT | `/api/user/password` | 修改密码 | 是 |

### 4.4 模块数据接口（Module）

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| GET | `/api/modules` | 获取所有模块列表 | 是 |
| GET | `/api/modules/{id}` | 获取指定模块详情 | 是 |

### 4.5 健康检查接口

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| GET | `/api/health` | 健康检查 | 否 |
| GET | `/api/health/detailed` | 详细健康检查 | 否 |

---

## 5. JWT 设计

### 5.1 Token 结构

**Access Token（访问令牌）：**
- 有效期：2 小时（7200000 毫秒）
- 载荷（Payload）：`userId`, `username`, `role`, `jti`（Token 唯一ID）
- 签名算法：HS256

**Refresh Token（刷新令牌）：**
- 有效期：7 天（604800000 毫秒）
- 载荷：`userId`, `jti`, type: "refresh"
- 用途：Access Token 过期后，无需重新登录

### 5.2 Token 安全策略

1. **密码传输**：前端使用 HTTPS，所有密码均POST到后端
2. **密码存储**：后端使用 BCrypt 加密存储
3. **Token 传递**：使用 `Authorization: Bearer <token>` 请求头
4. **Token 撤销**：将 `jti` 存入数据库 `user_sessions` 表
5. **Refresh 机制**：Access Token 过期时，前端使用 Refresh Token 申请新 Access Token

---

## 6. 前端页面布局

### 6.1 整体布局

```
┌──────────────────────────────────────────────────────────┐
│                     顶部导航栏 (80px)                      │
│   [Logo] 计算思维交互式仿真学习平台          [Dashboard] [头像] │
├────────────┬─────────────────────────────────────────────┤
│            │                                             │
│  左侧导航   │              主内容区域                       │
│  (240px)   │                                             │
│            │   ┌─────────────────────────────────────┐   │
│ 应用中心    │   │           欢迎卡片                   │   │
│  ├ 应用中心 │   └─────────────────────────────────────┘   │
│            │                                             │
│ 学习模块    │   ┌────┐ ┌────┐ ┌────┐ ┌────┐            │
│  ├ 图灵机   │   │模块1│ │模块2│ │模块3│ │模块4│            │
│  ├ 算法复杂度│   └────┘ └────┘ └────┘ └────┘            │
│  ├ 元胞自动机│   ┌────┐ ┌────┐ ┌────┐ ┌────┐            │
│  ├ 逻辑电路 │   │模块5│ │模块6│ │模块7│ │模块8│            │
│  ├ 数据结构 │   └────┘ └────┘ └────┘ └────┘            │
│  ├ 算法     │                                             │
│  ├ 程序设计 │   ┌─────────────────────────────────────┐   │
│  └ 人工智能 │   │           学习提示卡片                │   │
│            │   └─────────────────────────────────────┘   │
└────────────┴─────────────────────────────────────────────┘
```

### 6.2 布局参数

| 组件 | 参数 | 值 |
|------|------|-----|
| 顶部导航栏 | 高度 | 80px |
| 顶部导航栏 | 标题字体 | 22px, font-weight: 700 |
| 左侧导航栏 | 宽度 | 240px |
| 左侧导航栏 | 定位 | fixed, top: 80px |
| 左侧导航栏 | 菜单字体 | 18px, font-weight: 500 |
| 主内容区 | 左边距 | 240px |
| 主内容区 | 上边距 | 80px |
| 主内容区 | 最大宽度 | 1200px |
| 主内容区 | 内边距 | 24px 32px |

### 6.3 模块详情页布局（ModuleView）

模块详情页采用可调节的左右分栏布局，优先展示交互模拟区域：

```
┌─────────────────────────────────────────────────────────────────────┐
│                     顶部导航栏 (80px)                                │
├────────────┬────────────────────────────────────────────────────────┤
│            │  面包屑 / 首页 / 图灵机                                  │
│            ├────────────────────────────────────────────────────────┤
│  左侧导航   │  ┌─ 紧凑模块标题横幅 ─────────────────────────────┐     │
│  (240px)   │  │ [图标] 图灵机                进度环 0%          │     │
│            │  │           理解计算的终极模型                      │     │
│            │  └────────────────────────────────────────────────┘     │
│            ├────────────────────────────────────────────────────────┤
│            │  ┌─ 可折叠理论面板 ──┐ ┌─ 分隔条 ─┐ ┌─ 交互模拟面板 ─┐  │
│            │  │ [理论知识]    >  │ │  ┌┐    │ │ [交互模拟]     │  │
│            │  │                   │ │  ┌┘    │ │               │  │
│            │  │ · 图灵机组成      │ │          │ │  模拟器内容   │  │
│            │  │ · 工作原理       │ │  可拖动  │ │               │  │
│            │  │ · 转换规则       │ │          │ │               │  │
│            │  │                   │ │          │ │               │  │
│            │  │ [收起按钮 <]      │ │          │ │               │  │
│            │  └──────────────────┘ └──────────┘ └───────────────┘  │
│            │                              ↑                          │
│            │                      拖动调整宽度                        │
│            ├────────────────────────────────────────────────────────┤
│            │  ┌─ 练习测验 ─────────────────────────────────────┐    │
│            │  │ [1 基础概念] [2 应用练习] [3 综合挑战]          │    │
│            │  └────────────────────────────────────────────────┘    │
└────────────┴────────────────────────────────────────────────────────┘
```

**模块详情页布局参数：**

| 区域 | 参数 | 默认值 | 范围 |
|------|------|--------|------|
| 模块标题横幅 | 内边距 | 14px 20px | - |
| 模块标题 | 字体大小 | 18px | - |
| 模块副标题 | 字体大小 | 12px | - |
| 进度环 | 尺寸 | 40px | - |
| 理论面板 | 宽度 | 380px | 200px ~ 600px |
| 理论面板 | 折叠宽度 | 48px | - |
| 交互模拟区 | 最小高度 | 450px | - |
| 练习测验 | 内边距 | 14px 18px | - |

**核心特性：**

1. **可折叠理论面板**
   - 点击标题栏或箭头按钮切换展开/收起状态
   - 收起时仅显示标题栏（48px 宽）
   - 交互模拟区域自动扩展占用释放的空间

2. **可调节宽度分隔条**
   - 拖动中间的分隔条可调整理论面板宽度
   - 宽度范围：200px ~ 600px
   - 鼠标悬停时变为蓝色高亮显示

3. **交互模拟区优先**
   - 交互模拟区域占据主内容区的剩余空间
   - 最大可用空间，提升学习体验

4. **理论知识内容**
   - 8个模块各自包含理论知识点
   - 使用HTML格式内嵌在ModuleView中
   - 支持列表、表格、提示框等格式

### 6.4 响应式断点

| 断点 | 宽度 | 布局变化 |
|------|------|---------|
| 大屏 | ≥1200px | 4列模块网格，理论/模拟并排显示 |
| 中屏 | 900-1200px | 3列模块网格，理论/模拟并排显示 |
| 小屏 | <900px | 2列模块网格，模块详情页垂直堆叠 |
| 移动端 | <768px | 左侧导航隐藏，模块单列，全宽显示 |

---

## 7. 8个学习模块

### 7.1 模块列表

| 模块 ID | 模块名称 | 路由路径 | 主要功能 |
|--------|---------|---------|---------|
| turing | 图灵机 | `/module/turing` | 图灵机可视化模拟器 |
| complexity | 算法复杂度 | `/module/complexity` | 复杂度可视化对比 |
| cellular | 元胞自动机 | `/module/cellular` | 一维/二维元胞自动机模拟 |
| circuit | 逻辑电路 | `/module/circuit` | 拖拽式逻辑门搭建 |
| datastruct | 数据结构 | `/module/datastruct` | 数据结构动态可视化 |
| algorithm | 算法 | `/module/algorithm` | 经典算法分步演示 |
| programming | 程序设计 | `/module/programming` | 在线编程/执行追踪 |
| ai | 人工智能 | `/module/ai` | ML/神经网络可视化 |

### 7.2 模块组件

每个模块组件位于 `frontend/src/views/modules/` 目录下：
- `TuringModule.vue` - 图灵机模拟器
- `ComplexityModule.vue` - 复杂度可视化
- `CellularModule.vue` - 元胞自动机
- `CircuitModule.vue` - 逻辑电路
- `DataStructModule.vue` - 数据结构可视化
- `AlgorithmModule.vue` - 排序算法演示
- `ProgrammingModule.vue` - 代码执行追踪
- `AIModule.vue` - 感知机/KNN/决策树可视化

---

## 8. 安全性设计

### 8.1 后端安全措施

| 措施 | 实现方式 |
|------|---------|
| CORS | Spring Boot 配置 CorsFilter，允许指定来源 |
| 参数校验 | 使用 `@Valid` + Hibernate Validator 注解 |
| SQL 注入 | MyBatis-Plus 的 `QueryWrapper` 自动防注入 |
| 密码加密 | BCrypt（强度因子 12） |
| 敏感信息 | 生产环境使用环境变量注入数据库密码/JWT 密钥 |

### 8.2 前端安全措施

| 措施 | 实现方式 |
|------|---------|
| Token 存储 | 存储在 `localStorage` 中 |
| 请求拦截 | Axios 统一处理 401，自动跳转登录页 |
| 路由守卫 | Vue Router 的 `beforeEach` 检查认证状态 |

---

## 9. 配置文件

### 9.1 application.yml

```yaml
server:
  port: 8080

spring:
  application:
    name: ct-platform

  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/ct_platform?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
    username: root
    password: your_password

  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8

mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      id-type: auto
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0

jwt:
  secret: your-secret-key-at-least-64-characters-long!!
  access-token-expiration: 7200000
  refresh-token-expiration: 604800000

cors:
  allowed-origins:
    - http://localhost:5173
    - http://localhost:3000
    - http://127.0.0.1:5173
  allowed-methods: GET,POST,PUT,DELETE,OPTIONS
  max-age: 3600
```

### 9.2 vite.config.js

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 5173,
    host: true,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      }
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false
  }
})
```

---

## 10. 部署架构

### 10.1 开发环境

```
前端:   http://localhost:5173   (Vite Dev Server)
后端:   http://localhost:8080   (Spring Boot)
数据库: localhost:3306          (MySQL)
```

### 10.2 生产环境（推荐）

```
                            ┌─────────────┐
  用户请求 ──►  Nginx        │  静态资源   │
             (:80/:443)      │  (前端dist) │
                  │          └──────┬──────┘
                  │                 │ Proxy Pass
                  │                 ▼
                  │          ┌─────────────┐
                  └─────────►│ Spring Boot  │
                  (API)      │   :8080      │
                             └──────┬──────┘
                                    │
                                    ▼
                             ┌─────────────┐
                             │   MySQL     │
                             │   :3306     │
                             └─────────────┘
```

---

## 11. 启动脚本说明

### 11.1 Windows 启动脚本

| 脚本 | 功能 |
|------|------|
| `deploy.bat` | 检查环境、初始化数据库、构建后端、安装前端依赖 |
| `start.bat` | 启动 MySQL、后端、前端所有服务 |
| `stop.bat` | 停止所有服务 |
| `start-mysql.bat` | 单独启动 MySQL 服务 |

### 11.2 启动顺序

1. 启动 MySQL 数据库
2. 初始化数据库（如需要）
3. 启动 Spring Boot 后端（端口 8080）
4. 启动 Vue3 前端开发服务器（端口 5173）

---

## 12. 项目约束与注意事项

1. **JDK 版本**：Spring Boot 3 要求 JDK 17 及以上
2. **MySQL 版本**：推荐 MySQL 8.0+
3. **Node.js 版本**：推荐 Node.js 18+
4. **JWT 密钥**：生产环境必须使用强随机字符串（建议 64 位以上）
5. **HTTPS**：生产环境必须启用 HTTPS，否则 JWT Token 存在被窃取风险

---

## 13. 后续扩展方向

1. **学习记录**：新增 `user_progress` 表，记录每个用户在各模块的学习进度
2. **Redis 缓存**：引入 Redis 实现 Token 黑名单、热点数据缓存
3. **WebSocket 实时通信**：在程序设计模块支持在线代码执行结果推送
4. **文件上传**：用户头像上传，图片存储至 OSS
5. **邮件通知**：注册激活、密码重置通过邮件发送验证码
6. **管理员后台**：后台管理系统，支持用户管理、模块内容管理

---

*本文档版本：v1.1 | 更新日期：2026-06-02*
