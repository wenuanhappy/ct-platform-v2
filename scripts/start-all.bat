@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

set "DB_USER=root"
set "DB_PASS=Redrise0513#"
set "DB_NAME=ct_platform"
set "BACKEND_DIR=C:\dky\仿真项目实现-交互式计算思维学习平台\backend"
set "FRONTEND_DIR=C:\dky\仿真项目实现-交互式计算思维学习平台\frontend"

echo ================================================
echo   计算思维交互式仿真学习平台
echo   启动脚本 v2.0
echo ================================================
echo.

:: Step 1: Check Java
echo [1/6] Checking Java...
java -version 2>&1 | findstr /i "version"
if errorlevel 1 (
    echo   ERROR: Java not found!
    echo   Please set JAVA_HOME environment variable
    pause
    exit /b 1
)
echo   JAVA_HOME: %JAVA_HOME%
echo.

:: Step 2: Check Node.js
echo [2/6] Checking Node.js...
node -v
if errorlevel 1 (
    echo   ERROR: Node.js not found!
    pause
    exit /b 1
)
echo.

:: Step 3: Check Maven
echo [3/6] Checking Maven...
mvn -version 2>&1 | findstr /i "apache"
if errorlevel 1 (
    echo   ERROR: Maven not found!
    pause
    exit /b 1
)
echo.

:: Step 4: Check MySQL
echo [4/6] Checking MySQL...
echo   MYSQL_HOME: %MYSQL_HOME%
netstat | findstr ":3306" >nul
if errorlevel 1 (
    echo   MySQL is not running
    echo   Please start MySQL service
    pause
    exit /b 1
) else (
    echo   MySQL is running
)
echo.

:: Step 5: Check database
echo [5/6] Checking database %DB_NAME%...
mysql -u%DB_USER% -p%DB_PASS% -e "USE %DB_NAME%; SELECT 'OK' as status;" >nul 2>&1
if errorlevel 1 (
    echo   Database not found, creating...
    mysql -u%DB_USER% -p%DB_PASS% -e "CREATE DATABASE %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo   Importing schema...
    mysql -u%DB_USER% -p%DB_PASS% %DB_NAME% < "%BACKEND_DIR%\src\main\resources\schema.sql"
    echo   Database created and initialized
) else (
    echo   Database OK
)
echo.

:: Step 6: Start services
echo [6/6] Starting services...

:: Stop existing services on these ports
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080.*LISTENING"') do taskkill /F /PID %%a 2>nul >nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173.*LISTENING"') do taskkill /F /PID %%a 2>nul >nul
timeout /t 2 /nobreak >nul

:: Start Backend
echo   Starting Spring Boot backend...
cd /d "%BACKEND_DIR%"
start "Backend - Spring Boot" cmd /k "title Backend - Spring Boot && mvn spring-boot:run"
echo   Backend window opened - please wait for "Started CtApplication"
echo.

:: Start Frontend
echo   Starting Frontend dev server...
cd /d "%FRONTEND_DIR%"
start "Frontend - Vite" cmd /k "title Frontend - Vite && npm run dev"
echo   Frontend window opened
echo.

echo ================================================
echo   所有服务启动中!
echo ================================================
echo.
echo   访问地址:
echo     前端:   http://localhost:5173
echo     后端:   http://localhost:8080
echo     健康检查: http://localhost:8080/api/health
echo.
echo   测试账号 (密码: Pass1234!):
echo     admin / teacher01 / student01
echo.
echo   注意: 首次启动需要5-10分钟下载依赖
echo         请等待后端窗口显示 "Started CtApplication"
echo.
pause
