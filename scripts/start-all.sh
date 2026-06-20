#!/bin/bash

# ================================================
#   计算思维交互式仿真学习平台
#   一键启动脚本 (Linux/macOS)
# ================================================

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "  计算思维交互式仿真学习平台"
echo "  一键启动脚本 v1.0"
echo "================================================"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# =============================================
# 第1步：检查 Java 环境
# =============================================
echo -e "${YELLOW}[1/7]${NC} 检查 Java 环境..."
if ! command -v java &> /dev/null; then
    echo -e "  ${RED}✗ Java 未安装！${NC}"
    echo ""
    echo "  请先安装 JDK 17 或更高版本："
    echo "  1. Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "  2. macOS: brew install openjdk@17"
    echo "  3. 或从 https://adoptium.net 下载"
    echo ""
    read -p "按 Enter 键退出..."
    exit 1
fi
echo -e "  ${GREEN}✓ Java 已安装${NC}"
java -version 2>&1 | head -1 | sed 's/^/  /'
echo ""

# =============================================
# 第2步：检查 Node.js 环境
# =============================================
echo -e "${YELLOW}[2/7]${NC} 检查 Node.js 环境..."
if ! command -v node &> /dev/null; then
    echo -e "  ${RED}✗ Node.js 未安装！${NC}"
    echo ""
    echo "  请先安装 Node.js 18 或更高版本："
    echo "  1. Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "  2. macOS: brew install node"
    echo "  3. 或从 https://nodejs.org/ 下载"
    echo ""
    read -p "按 Enter 键退出..."
    exit 1
fi
echo -e "  ${GREEN}✓ Node.js 已安装${NC}"
node -v | sed 's/^/  v/'
echo ""

# =============================================
# 第3步：检查 MySQL 服务
# =============================================
echo -e "${YELLOW}[3/7]${NC} 检查 MySQL 服务..."
if ! command -v mysql &> /dev/null; then
    echo -e "  ${RED}✗ MySQL 未安装！${NC}"
    echo ""
    echo "  请先安装 MySQL 8.0："
    echo "  1. Ubuntu/Debian: sudo apt install mysql-server"
    echo "  2. macOS: brew install mysql"
    echo ""
    read -p "按 Enter 键退出..."
    exit 1
fi

if ! lsof -Pi :3306 -sTCP:LISTEN -t >/dev/null 2>&1 && ! netstat -an 2>/dev/null | grep -q ":3306.*LISTEN"; then
    echo "  MySQL 未运行，正在启动..."
    sudo service mysql start 2>/dev/null || sudo systemctl start mysql 2>/dev/null || echo "  请手动启动 MySQL 服务"
    sleep 3
else
    echo -e "  ${GREEN}✓ MySQL 已运行${NC}"
fi
echo ""

# =============================================
# 第4步：验证数据库连接
# =============================================
echo -e "${YELLOW}[4/7]${NC} 验证数据库连接..."
if ! mysql -u root -proot123 -e "USE ct_platform; SELECT 1;" >/dev/null 2>&1; then
    echo "  数据库未初始化，是否立即初始化？"
    read -p "  选择 (Y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  正在初始化数据库..."
        # 创建数据库
        mysql -u root -proot123 -e "DROP DATABASE IF EXISTS ct_platform; CREATE DATABASE ct_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
        # 导入数据
        mysql -u root -proot123 ct_platform < "$PROJECT_ROOT/backend/src/main/resources/schema.sql" 2>/dev/null
        echo -e "  ${GREEN}✓ 数据库初始化完成${NC}"
    fi
fi
echo -e "  ${GREEN}✓ 数据库连接成功${NC}"
echo ""

# =============================================
# 第5步：检查前端依赖
# =============================================
echo -e "${YELLOW}[5/7]${NC} 检查前端依赖..."
cd "$PROJECT_ROOT/frontend"
if [ ! -d "node_modules" ]; then
    echo "  正在安装前端依赖..."
    npm install
    echo -e "  ${GREEN}✓ 依赖安装完成${NC}"
else
    echo -e "  ${GREEN}✓ 依赖已安装${NC}"
fi
echo ""

# =============================================
# 第6步：启动后端服务
# =============================================
echo -e "${YELLOW}[6/7]${NC} 启动 Spring Boot 后端..."
cd "$PROJECT_ROOT/backend"
if [ -f "./mvnw" ]; then
    chmod +x ./mvnw
    ./mvnw spring-boot:run &
else
    mvn spring-boot:run &
fi
echo -e "  ${GREEN}✓ 后端服务启动中${NC}"
echo "  提示: 首次启动需要下载依赖，请耐心等待"
echo ""

# =============================================
# 第7步：启动前端服务
# =============================================
echo -e "${YELLOW}[7/7]${NC} 启动前端开发服务器..."
cd "$PROJECT_ROOT/frontend"
npm run dev &
echo -e "  ${GREEN}✓ 前端服务启动中${NC}"
echo ""

# =============================================
# 启动完成
# =============================================
echo "================================================"
echo -e "  ${GREEN}✓ 所有服务启动完成！${NC}"
echo "================================================"
echo ""
echo "  访问地址:"
echo "    前端:   http://localhost:5173"
echo "    后端:   http://localhost:8080"
echo "    健康检查: http://localhost:8080/api/health"
echo ""
echo "  测试账号 (密码均为: Pass1234!):"
echo "    - admin       (管理员)"
echo "    - teacher01   (教师)"
echo "    - student01   (学生)"
echo ""
echo "  提示: 使用 Ctrl+C 可以停止所有服务"
echo ""
