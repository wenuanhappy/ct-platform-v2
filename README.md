# 计算思维交互式仿真学习平台

> 一个基于 Vue3 + Spring Boot 的全栈 Web 应用，用于交互式学习计算思维概念。

## 📖 项目简介

本项目是一个教学平台，包含8个计算思维核心模块的交互式学习内容。用户通过注册登录后，可以访问各个模块进行理论学习和实践模拟。

### 核心功能

- **用户认证系统**：注册、登录、JWT Token 认证
- **8个学习模块**：
  1. 图灵机 - 理解计算的本质模型
  2. 算法复杂度 - 评估算法效率
  3. 元胞自动机 - 简单规则创造复杂系统
  4. 逻辑电路 - 数字逻辑基础
  5. 数据结构 - 数据组织与管理
  6. 算法 - 经典排序算法可视化
  7. 程序设计 - 代码执行追踪
  8. 人工智能 - 机器学习基础算法可视化

## 🛠️ 技术栈

### 前端
- **Vue 3** - 渐进式 JavaScript 框架 (Composition API)
- **Vite** - 下一代前端构建工具
- **Pinia** - Vue3 状态管理
- **Vue Router** - 官方路由管理器
- **Element Plus** - Vue3 UI 组件库
- **Axios** - HTTP 请求库

### 后端
- **Spring Boot 3.2.5** - 企业级 Java 开发框架
- **MyBatis-Plus 3.5.6** - ORM 框架
- **MySQL 8.0** - 关系型数据库
- **JWT (jjwt 0.12.5)** - JSON Web Token 认证
- **BCrypt** - 密码加密

## 🚀 快速开始

### 环境要求

- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Maven 3.8+

### 一键部署启动

```bash
# 第1步：部署（首次运行或代码更新后执行）
deploy.bat

# 第2步：启动所有服务
start.bat
```

启动后访问 http://localhost:5173

**测试账号：**
- 用户名：`student01`
- 密码：`Pass1234!`

### 手动部署（可选）

#### 1. 配置数据库

```bash
# 登录 MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE IF NOT EXISTS ct_platform
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入数据库脚本
USE ct_platform;
SOURCE backend/src/main/resources/schema.sql;

# 退出
EXIT;
```

#### 2. 启动后端服务

```bash
cd backend

# 方式一：使用 Maven
mvn spring-boot:run

# 方式二：运行 JAR 包
mvn clean package
java -jar target/ct-platform-backend-1.0.0.jar
```

后端服务将在 http://localhost:8080 启动。

#### 3. 启动前端服务

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端应用将在 http://localhost:5173 启动。

### 常用脚本说明

| 脚本 | 功能 |
|------|------|
| `deploy.bat` | 初始化数据库、构建后端、安装前端依赖 |
| `start.bat` | 启动 MySQL、后端、前端所有服务 |
| `stop.bat` | 停止所有服务 |
| `start-mysql.bat` | 单独启动 MySQL 服务 |

## 📁 项目结构

```
simulation-platform/
├── backend/                          # Spring Boot 后端项目
│   ├── src/main/java/com/ctplatform/
│   │   ├── CtApplication.java        # 启动类
│   │   ├── config/                   # 配置类（CORS、JWT）
│   │   ├── controller/               # REST API 控制器
│   │   │   ├── AuthController.java   # 认证接口
│   │   │   ├── UserController.java   # 用户信息接口
│   │   │   ├── ModuleController.java # 模块数据接口
│   │   │   └── HealthController.java # 健康检查接口
│   │   ├── service/                  # 业务逻辑层
│   │   │   ├── AuthService.java
│   │   │   ├── UserService.java
│   │   │   └── ModuleService.java
│   │   ├── service/impl/             # 业务逻辑实现
│   │   ├── mapper/                   # MyBatis Mapper
│   │   ├── entity/                   # 实体类
│   │   │   ├── User.java
│   │   │   └── UserSession.java
│   │   ├── dto/                      # 数据传输对象
│   │   │   ├── ApiResponse.java
│   │   │   ├── LoginRequest.java
│   │   │   ├── LoginResponse.java
│   │   │   └── RegisterRequest.java
│   │   ├── util/                     # 工具类
│   │   │   ├── JwtUtil.java
│   │   │   └── PasswordUtil.java
│   │   └── exception/                # 异常处理
│   │       ├── BusinessException.java
│   │       └── GlobalExceptionHandler.java
│   └── src/main/resources/
│       ├── application.yml           # 应用配置
│       └── schema.sql                # 数据库脚本
│
├── frontend/                         # Vue3 前端项目
│   ├── src/
│   │   ├── api/                      # API 接口封装
│   │   │   └── auth.js
│   │   ├── assets/styles/
│   │   │   ├── variables.css         # CSS 变量
│   │   │   └── global.css            # 全局样式
│   │   ├── components/               # 公共组件
│   │   │   ├── AppHeader.vue         # 顶部导航栏
│   │   │   ├── AppSidebar.vue        # 侧边栏
│   │   │   └── ModuleCard.vue        # 模块卡片
│   │   ├── router/
│   │   │   └── index.js              # 路由配置
│   │   ├── stores/
│   │   │   └── auth.js               # Pinia 认证状态
│   │   ├── utils/
│   │   │   └── request.js            # Axios 实例
│   │   └── views/                    # 页面组件
│   │       ├── LoginView.vue         # 登录页面
│   │       ├── RegisterView.vue      # 注册页面
│   │       ├── DashboardView.vue     # 应用中心/首页
│   │       ├── ProfileView.vue       # 个人资料
│   │       ├── ModuleView.vue        # 模块详情页
│   │       └── modules/              # 8个学习模块
│   │           ├── TuringModule.vue
│   │           ├── ComplexityModule.vue
│   │           ├── CellularModule.vue
│   │           ├── CircuitModule.vue
│   │           ├── DataStructModule.vue
│   │           ├── AlgorithmModule.vue
│   │           ├── ProgrammingModule.vue
│   │           └── AIModule.vue
│   ├── vite.config.js
│   └── package.json
│
├── docs/                             # 文档目录
│   └── SPEC.md                       # 设计规格文档
│
├── CLAUDE.md                         # Claude Code 开发指南
├── deploy.bat                        # 部署脚本
├── start.bat                         # 启动脚本
└── stop.bat                          # 停止脚本
```

## 🎨 界面预览

### Dashboard 首页
- 顶部导航栏（80px 高度）：Logo、平台名称、用户头像下拉菜单
- 左侧导航栏（240px 宽度）：应用中心 + 8个学习模块入口（字体 18px）
- 中间内容区：欢迎卡片、学习模块网格、学习提示

### 模块详情页（核心特性）
- **紧凑标题横幅**：模块名称 + 进度环，精简设计
- **可折叠理论面板**：点击展开/收起，节省空间给交互模拟区
- **可调节宽度分隔条**：拖动调整理论区和交互区的比例
- **交互模拟区优先**：占据主内容区最大空间
- **练习测验区**：固定在页面底部

### 登录页面
- 现代化的登录界面设计
- 表单验证和错误提示
- 注册/登录切换

### 界面布局参数

| 区域 | 参数 | 值 |
|------|------|-----|
| 顶部导航栏 | 高度 | 80px |
| 左侧导航栏 | 宽度 | 240px |
| 左侧导航栏 | 菜单字体 | 18px |
| 模块标题 | 字体 | 18px |
| 理论面板 | 默认宽度 | 380px（200px~600px 可调）|
| 交互模拟区 | 最小高度 | 450px |

## 🔧 开发指南

### 添加新的学习模块

1. 在 `frontend/src/views/modules/` 目录下创建新的 Vue 模拟器组件
2. 在 `ModuleView.vue` 的 `moduleConfig` 中添加模块配置（名称、副标题、颜色）
3. 在 `ModuleView.vue` 的 `theoryContents` 中添加理论知识点（HTML格式）
4. 在 `ModuleView.vue` 的 `modules` 对象中添加模拟器组件的动态导入
5. 在 `ModuleView.vue` 的 `icons` 中添加模块图标
6. 在 `DashboardView.vue` 的 `modules` 数组中添加卡片展示信息
7. 在 `AppSidebar.vue` 的 `modules` 数组中添加导航项

### API 请求示例

```javascript
// 使用封装好的 API
import { login, register } from '@/api/auth'

// 登录
const response = await login({
  username: 'student01',
  password: 'Pass1234!'
})

console.log(response.data.accessToken)
```

### 数据库操作

```sql
-- 查看所有用户
SELECT * FROM users;

-- 查看用户会话
SELECT * FROM user_sessions;

-- 删除用户会话（退出登录）
DELETE FROM user_sessions WHERE user_id = 1;
```

## 🐛 常见问题

### 1. 后端启动失败

检查以下配置：
- MySQL 服务是否启动
- 数据库 `ct_platform` 是否创建
- `application.yml` 中的数据库配置是否正确

### 2. 前端无法连接后端

检查：
- CORS 配置是否包含前端地址
- 后端服务是否正常运行在 8080 端口
- 浏览器控制台是否有跨域错误

### 3. JWT Token 过期

前端已实现自动刷新 Token 机制。如果刷新失败，请重新登录。

## 📄 许可证

本项目仅供学习和教育目的使用。

---

**版本**：v1.0.0  
**最后更新**：2026年6月
