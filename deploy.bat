@echo off
setlocal

echo.
echo ================================================
echo    CT Platform - Deployment Script
echo ================================================
echo.

set "PROJECT_ROOT=%~dp0"
set "BACKEND_DIR=%PROJECT_ROOT%backend"
set "FRONTEND_DIR=%PROJECT_ROOT%frontend"
set "MYSQL_PWD=123456"

:: ========== Step 1: Check Environment ==========
echo [1/4] Checking environment...

:: Check Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java not found. Please install JDK 17+
    pause
    exit /b 1
)
echo    Java: OK

:: Check Maven
call mvn -v >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Maven not found. Please install Maven 3.8+
    pause
    exit /b 1
)
echo    Maven: OK

:: Check Node.js
node -v >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found. Please install Node.js 18+
    pause
    exit /b 1
)
echo    Node.js: OK

:: Check MySQL (try connection directly)
mysql -u root -p%MYSQL_PWD% -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Cannot connect to MySQL. Please check if MySQL is running
    pause
    exit /b 1
)
echo    MySQL: OK

echo.

:: ========== Step 2: Initialize Database ==========
echo [2/4] Initializing database...

:: Create database
mysql -u root -p%MYSQL_PWD% -e "CREATE DATABASE IF NOT EXISTS ct_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
echo    Database ct_platform: OK

:: Import schema
mysql -u root -p%MYSQL_PWD% ct_platform < "%BACKEND_DIR%\src\main\resources\schema.sql" 2>nul
if errorlevel 1 (
    echo [ERROR] Failed to import schema
    pause
    exit /b 1
)
echo    Schema imported: OK
echo.

:: ========== Step 3: Build Backend ==========
echo [3/4] Building backend...

cd /d "%BACKEND_DIR%"
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo [ERROR] Backend build failed
    pause
    exit /b 1
)
echo    Backend built: OK
echo.

:: ========== Step 4: Frontend Dependencies ==========
echo [4/4] Checking frontend dependencies...

cd /d "%FRONTEND_DIR%"
if not exist "node_modules" (
    echo    Installing npm dependencies...
    call npm install
    if errorlevel 1 (
        echo [ERROR] npm install failed
        pause
        exit /b 1
    )
    echo    npm install: OK
) else (
    echo    Dependencies already installed
)
echo.

echo ================================================
echo    Deployment completed successfully!
echo ================================================
echo.
echo    Run start.bat to launch all services
echo.

pause
