@echo off
chcp 65001 >nul 2>&1
setlocal

set "DB_USER=root"
set "DB_PASS=Redrise0513#"
set "DB_NAME=ct_platform"
set "BACKEND_DIR=C:\dky\仿真项目实现-交互式计算思维学习平台\backend"

echo ================================================
echo   System Health Check
echo ================================================
echo.

:: Check Java
echo [1] Java:
java -version 2>&1 | findstr /i "version"
if errorlevel 1 echo   NOT FOUND
echo.

:: Check Maven
echo [2] Maven:
mvn -version 2>&1 | findstr /i "apache"
if errorlevel 1 echo   NOT FOUND
echo.

:: Check Node.js
echo [3] Node.js:
node -v 2>nul
if errorlevel 1 echo   NOT FOUND
echo.

:: Check MySQL
echo [4] MySQL:
netstat | findstr ":3306"
if errorlevel 1 echo   NOT RUNNING
echo.

:: Check database
echo [5] Database:
mysql -u%DB_USER% -p%DB_PASS% -e "USE %DB_NAME%; SELECT COUNT(*) as users FROM users;" 2>nul
if errorlevel 1 echo   FAILED - database may not exist
echo.

:: Check ports
echo [6] Service ports:
netstat | findstr ":8080" && echo   Backend RUNNING || echo   Backend NOT running
netstat | findstr ":5173" && echo   Frontend RUNNING || echo   Frontend NOT running
echo.

:: Check backend API
echo [7] Backend API:
curl -s http://localhost:8080/api/health 2>nul || echo   Backend not responding
echo.

:: Environment variables
echo [8] Environment:
echo   JAVA_HOME: %JAVA_HOME%
echo   MAVEN_HOME: %MAVEN_HOME%
echo.

echo ================================================
echo   Check Complete
echo ================================================
pause
