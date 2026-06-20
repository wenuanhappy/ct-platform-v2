@echo off
setlocal enabledelayedexpansion

echo.
echo  ================================================
echo    CT Platform - Start All Services
echo  ================================================
echo.

set "PROJECT_ROOT=%~dp0"
set "BACKEND_DIR=%PROJECT_ROOT%backend"
set "FRONTEND_DIR=%PROJECT_ROOT%frontend"
set "BACKEND_JAR=%BACKEND_DIR%\target\ct-platform-backend-1.0.0.jar"

:: ========== Start MySQL ==========
echo [1/3] Starting MySQL service...
echo.

netstat | findstr ":3306" >nul
if not errorlevel 1 (
    echo    MySQL is already running
) else (
    echo    Starting MySQL...
    net start MySQL >nul 2>&1
    if errorlevel 1 (
        echo    [HINT] Cannot start MySQL automatically
    ) else (
        echo    MySQL started successfully
    )
)

:: ========== Start Backend ==========
echo.
echo [2/3] Starting backend service...
echo.

if not exist "%BACKEND_JAR%" (
    echo    [ERROR] JAR file not found. Run deploy.bat first.
    pause
    exit /b 1
)

echo    Starting backend on http://localhost:8080
echo.
start "CT-Platform Backend" cmd /k "cd /d "%BACKEND_DIR%" ^&^& java -jar "%BACKEND_JAR%""

timeout /t 10 /nobreak >nul

:: ========== Start Frontend ==========
echo.
echo [3/3] Starting frontend service...
echo.

echo    Starting frontend on http://localhost:5173
echo.
start "CT-Platform Frontend" cmd /k "cd /d "%FRONTEND_DIR%" ^&^& npm run dev"

:: ========== Done ==========
echo.
echo ================================================
echo    All services started!
echo ================================================
echo.
echo    Frontend: http://localhost:5173
echo    Backend:  http://localhost:8080
echo.
echo    Test Account: student01 / Pass1234
echo.

pause >nul
start http://localhost:5173
