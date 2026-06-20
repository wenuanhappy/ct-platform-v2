@echo off
chcp 65001 >nul 2>&1
setlocal

set "DB_USER=root"
set "DB_PASS=Redrise0513#"
set "DB_NAME=ct_platform"
set "BACKEND_DIR=C:\dky\仿真项目实现-交互式计算思维学习平台\backend"

echo ================================================
echo   Database Initialization
echo ================================================
echo.

echo [1/3] Checking MySQL...
netstat | findstr ":3306" >nul
if errorlevel 1 (
    echo   ERROR: MySQL is not running
    echo   Please start MySQL first
    pause
    exit /b 1
)
echo   MySQL is running
echo.

echo [2/3] Creating database...
mysql -u%DB_USER% -p%DB_PASS% -e "DROP DATABASE IF EXISTS %DB_NAME%; CREATE DATABASE %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
if errorlevel 1 (
    echo   ERROR: Failed to create database
    echo   Please check your MySQL password
    pause
    exit /b 1
)
echo   Database %DB_NAME% created
echo.

echo [3/3] Importing schema...
mysql -u%DB_USER% -p%DB_PASS% %DB_NAME% < "%BACKEND_DIR%\src\main\resources\schema.sql" 2>nul
if errorlevel 1 (
    echo   ERROR: Failed to import schema
    pause
    exit /b 1
)
echo   Schema imported
echo.

echo ================================================
echo   Database initialized successfully!
echo ================================================
echo.
echo   Database: %DB_NAME%
echo   User: %DB_USER%
echo.
echo   Test accounts (password: Pass1234!):
echo     admin / teacher01 / student01
echo.
pause
