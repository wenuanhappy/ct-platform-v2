# 计算思维交互式仿真学习平台 - 部署使用文档

> 本文档详细说明了"计算思维交互式仿真学习平台"项目的部署流程、环境配置和常见问题解决。

---

## 目录

1. [项目结构](#1-项目结构)
2. [环境要求](#2-环境要求)
3. [快速部署](#3-快速部署)
4. [后端部署](#4-后端部署)
5. [前端部署](#5-前端部署)
6. [生产环境部署](#6-生产环境部署)
7. [常见问题](#7-常见问题)
8. [Windows 一键部署](#8-windows-一键部署)

---

## 1. 项目结构

```
simulation-platform/
├── backend/                          # Spring Boot 后端项目
│   ├── src/main/java/com/ctplatform/
│   │   ├── CtApplication.java        # 启动类
│   │   ├── config/                   # 配置类（CORS、JWT）
│   │   ├── controller/               # REST API 控制器
│   │   ├── service/                  # 业务逻辑层
│   │   ├── mapper/                   # MyBatis Mapper
│   │   ├── entity/                   # 实体类
│   │   ├── dto/                      # 数据传输对象
│   │   ├── util/                     # 工具类
│   │   └── exception/                # 异常处理
│   └── src/main/resources/
│       ├── application.yml           # 应用配置
│       └── schema.sql                # 数据库脚本
│
├── frontend/                         # Vue3 前端项目
│   ├── src/
│   │   ├── api/                      # API 接口封装
│   │   ├── assets/styles/            # CSS 样式
│   │   ├── components/               # 公共组件
│   │   │   ├── AppHeader.vue         # 顶部导航栏
│   │   │   ├── AppSidebar.vue        # 侧边栏导航
│   │   │   └── ModuleCard.vue        # 模块卡片
│   │   ├── router/                   # 路由配置
│   │   ├── stores/                   # Pinia 状态管理
│   │   ├── utils/                    # 工具函数
│   │   └── views/                    # 页面组件
│   │       ├── LoginView.vue         # 登录页
│   │       ├── RegisterView.vue      # 注册页
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
│   ├── vite.config.js                # Vite 构建配置
│   └── package.json                  # npm 依赖配置
│
├── docs/
│   ├── SPEC.md                       # 设计规格文档
│   └── DEPLOY.md                     # 部署使用文档
│
├── CLAUDE.md                         # Claude Code 开发指南
├── README.md                         # 项目主 README
├── deploy.bat                        # 部署脚本
├── start.bat                         # 启动脚本
└── stop.bat                          # 停止脚本
```

---

## 2. 环境要求

### 2.1 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| CPU | 2 核 | 4 核 |
| 内存 | 4 GB | 8 GB |
| 硬盘 | 10 GB | 20 GB SSD |

### 2.2 软件要求

| 软件 | 版本要求 | 说明 |
|------|---------|------|
| JDK | 17+ | Spring Boot 3 要求 |
| Node.js | 18+ | 前端构建需要 |
| npm | 9+ | 随 Node.js 安装 |
| Maven | 3.8+ | 后端构建需要 |
| MySQL | 8.0+ | 数据库 |

### 2.3 开发工具推荐

- **后端 IDE**: IntelliJ IDEA
- **前端 IDE**: VS Code
- **数据库工具**: DBeaver / Navicat / MySQL Workbench
- **API 测试**: Postman / Apifox

---

## 3. 快速部署

### 3.1 一键部署（Windows）

```bash
# 第1步：部署（首次运行或代码更新后执行）
deploy.bat

# 第2步：启动所有服务
start.bat
```

启动后自动打开浏览器访问 http://localhost:5173

### 3.2 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | Pass1234! |
| 教师 | teacher01 | Pass1234! |
| 学生 | student01 | Pass1234! |

---

## 4. 后端部署

### 4.1 数据库配置

1. **创建数据库**

```sql
CREATE DATABASE IF NOT EXISTS ct_platform
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

2. **导入表结构**

```bash
mysql -u root -p ct_platform < backend/src/main/resources/schema.sql
```

3. **修改配置文件**

编辑 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    password: 你的MySQL密码
```

### 4.2 启动后端服务

**方式一：使用 Maven**
```bash
cd backend
mvn spring-boot:run
```

**方式二：运行 JAR 包**
```bash
cd backend
mvn clean package -DskipTests
java -jar target/ct-platform-backend-1.0.0.jar
```

### 4.3 验证后端启动

```bash
# 测试健康检查接口
curl http://localhost:8080/api/health
```

成功响应：
```json
{"code":200,"message":"操作成功","data":{"status":"UP"},"timestamp":...}
```

### 4.4 JWT 配置

```yaml
jwt:
  secret: your-64-character-secret-key-here-minimum
  access-token-expiration: 7200000    # 2小时（毫秒）
  refresh-token-expiration: 604800000 # 7天（毫秒）
```

> ⚠️ **重要**: 生产环境必须使用强随机字符串作为 JWT 密钥。

---

## 5. 前端部署

### 5.1 安装依赖

```bash
cd frontend
npm install
```

### 5.2 开发环境运行

```bash
npm run dev
```

访问 `http://localhost:5173` 即可看到登录页面。

### 5.3 构建生产版本

```bash
npm run build
```

构建产物输出到 `frontend/dist/` 目录。

---

## 6. 生产环境部署

### 6.1 架构概述

```
                    ┌─────────────┐
   用户请求 ──────►  │   Nginx     │
   (:443 HTTPS)     │  反向代理    │
                    └──────┬──────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
            ▼              ▼              ▼
     ┌───────────┐  ┌───────────┐  ┌───────────┐
     │  静态资源  │  │  API 代理  │  │  静态资源  │
     │  (前端dist)│  │ (后端:8080)│  │  (备选)   │
     └───────────┘  └───────────┘  └───────────┘
```

### 6.2 后端部署

```bash
# 1. 构建 JAR 包
cd backend
mvn clean package -DskipTests

# 2. 上传到服务器
scp target/ct-platform-backend-1.0.0.jar user@server:/opt/ct-platform/

# 3. 创建启动脚本
cat > /opt/ct-platform/start.sh << 'EOF'
#!/bin/bash
java -jar ct-platform-backend-1.0.0.jar
EOF

chmod +x start.sh

# 4. 使用 systemd 管理服务
sudo cat > /etc/systemd/system/ct-platform.service << 'EOF'
[Unit]
Description=Computational Thinking Platform
After=network.target mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/ct-platform
ExecStart=/usr/bin/java -jar ct-platform-backend-1.0.0.jar
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ct-platform
sudo systemctl start ct-platform
```

### 6.3 前端部署

```bash
# 1. 构建生产版本
cd frontend
npm run build

# 2. 上传到服务器
scp -r dist/* user@server:/var/www/ct-platform/
```

### 6.4 Nginx 配置

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;

    root /var/www/ct-platform;
    index index.html;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

---

## 7. 常见问题

### Q1: 后端启动失败，提示数据库连接错误

**解决方案：**
1. 检查 MySQL 服务是否启动
2. 验证数据库用户名和密码是否正确
3. 确认数据库 `ct_platform` 已创建

```bash
# 测试 MySQL 连接
mysql -u root -p -e "SELECT 1"
```

### Q2: 前端调用后端接口报 CORS 错误

**解决方案：**
1. 检查 `CorsConfig.java` 是否允许前端域名
2. 确认使用正确的协议（HTTP/HTTPS）

### Q3: JWT Token 过期

前端已实现自动刷新 Token 机制，当 Access Token 过期时会自动使用 Refresh Token 获取新的 Access Token。

### Q4: 提示 "Unknown column 'deleted'"

这是因为数据库表缺少 `deleted` 字段。请重新导入数据库：
```bash
mysql -u root -p ct_platform < backend/src/main/resources/schema.sql
```

或在现有数据库中添加字段：
```bash
mysql -u root -p ct_platform -e "ALTER TABLE users ADD COLUMN deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除';"
```

### Q5: 前端构建失败

```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### Q6: 端口被占用

**Windows:**
```bash
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

**Linux:**
```bash
lsof -i :8080
kill -9 <PID>
```

### Q7: 页面布局异常

检查是否修改了布局参数。当前布局配置：
- 顶部导航栏高度：80px
- 左侧导航栏宽度：240px
- 主内容区左边距：240px

---

## 8. Windows 一键部署

### 8.1 使用部署脚本

```bash
# 一键部署
deploy.bat
```

### 8.2 一键启动

```bash
start.bat
```

### 8.3 停止服务

```bash
stop.bat
```

### 8.4 单独启动 MySQL

```bash
start-mysql.bat
```

---

## 9. 快速验证清单

### 9.1 后端验证

- [ ] 访问 http://localhost:8080/api/health 返回成功
- [ ] 用户注册功能正常
- [ ] 用户登录功能正常，返回 JWT Token
- [ ] 登录后访问 `/api/auth/me` 返回用户信息

### 9.2 前端验证

- [ ] 访问 http://localhost:5173 显示登录页面
- [ ] 使用测试账号登录成功
- [ ] 登录后跳转到应用中心页面
- [ ] 左侧导航栏显示 8 个学习模块
- [ ] 点击模块卡片可以进入模块详情页

### 9.3 8个学习模块

| 模块 | 功能验证 |
|------|---------|
| 图灵机 | 纸带可视化、单步执行 |
| 算法复杂度 | 复杂度曲线对比图 |
| 元胞自动机 | 规则选择、网格动画 |
| 逻辑电路 | 门电路拖拽、真值表 |
| 数据结构 | 数组/链表/栈/队列/树可视化 |
| 算法 | 排序算法动画演示 |
| 程序设计 | 代码编辑器、执行追踪 |
| 人工智能 | 感知机/KNN/决策树模拟器 |

---

## 10. 常用命令汇总

```bash
# 后端
mvn clean package -DskipTests    # 构建
mvn spring-boot:run              # 运行开发版本
java -jar target/ct-platform-backend-1.0.0.jar  # 运行生产版本

# 前端
npm install                       # 安装依赖
npm run dev                       # 开发环境
npm run build                     # 生产构建
npm run preview                   # 预览构建结果

# 数据库
mysql -u root -p                  # 连接 MySQL
SOURCE backend/src/main/resources/schema.sql  # 初始化数据库

# 系统服务 (Linux)
sudo systemctl start ct-platform     # 启动
sudo systemctl stop ct-platform      # 停止
sudo systemctl restart ct-platform   # 重启
sudo systemctl status ct-platform    # 状态
```

---

**文档版本：** v3.0 | **最后更新：** 2026-06-02
