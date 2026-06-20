@echo off
setlocal

echo.
echo ================================================
echo    CT Platform - Stop Services
echo ================================================
echo.

:: ========== Step 1: Stop Backend (port 8080) ==========
echo [1/2] Stopping backend (port 8080)...

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1 && echo    Backend stopped || echo    Backend not running
)
if errorlevel 1 echo    No backend process found on port 8080

echo.

:: ========== Step 2: Stop Frontend (port 5173) ==========
echo [2/2] Stopping frontend (port 5173)...

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1 && echo    Frontend stopped || echo    Frontend not running
)
if errorlevel 1 echo    No frontend process found on port 5173

echo.
echo ================================================
echo    All services stopped
echo ================================================
echo.
echo    MySQL is still running
echo    To stop MySQL: net stop MySQL
echo.

pause
