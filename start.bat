@echo off
setlocal

echo.
echo ================================================
echo    CT Platform - Start Script
echo ================================================
echo.

set "PROJECT_ROOT=%~dp0"
set "BACKEND_DIR=%PROJECT_ROOT%backend"
set "FRONTEND_DIR=%PROJECT_ROOT%frontend"
set "BACKEND_JAR=%BACKEND_DIR%\target\ct-platform-backend-1.0.0.jar"

:: ========== Step 1: Start MySQL ==========
echo [1/4] Starting MySQL service...

netstat | findstr ":3306" >nul
if not errorlevel 1 (
    echo    MySQL is already running
) else (
    net start MySQL >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] Cannot start MySQL automatically
        echo    Please start MySQL service manually
    ) else (
        echo    MySQL started
    )
)
echo.

:: ========== Step 2: Start Backend ==========
echo [2/4] Starting backend service...

if not exist "%BACKEND_JAR%" (
    echo [ERROR] JAR file not found: ct-platform-backend-1.0.0.jar
    echo    Please run deploy.bat first
    pause
    exit /b 1
)

:: Kill existing process on port 8080
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo    Starting Spring Boot on http://localhost:8080
start "CT-Backend" cmd /k "cd /d "%BACKEND_DIR%" && java -jar "%BACKEND_JAR%""
echo    Backend starting...
timeout /t 12 /nobreak >nul
echo.

:: ========== Step 3: Start Frontend ==========
echo [3/4] Starting frontend service...

:: Kill existing process on port 5173
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo    Starting Vite dev server on http://localhost:5173
start "CT-Frontend" cmd /k "cd /d "%FRONTEND_DIR%" && npm run dev"
echo.

:: ========== Step 4: Complete ==========
echo [4/4] All services started!
echo.
echo ================================================
echo    CT Platform is running!
echo ================================================
echo.
echo    Frontend: http://localhost:5173
echo    Backend:  http://localhost:8080
echo.
echo    Test Account:
echo      Username: student01
echo      Password: Pass1234
echo.

pause >nul
start http://localhost:5173
