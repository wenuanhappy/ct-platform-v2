@echo off
setlocal enabledelayedexpansion

echo.
echo ================================================
echo   MySQL Service Starter
echo ================================================
echo.

set "PROJECT_ROOT=%~dp0"
set "MYSQL_HOME=%PROJECT_ROOT%\mysql-portable\mysql-8.0.36-winx64"

:: Check if MySQL is already running
netstat | findstr ":3306" >nul
if not errorlevel 1 (
    echo   MySQL is already running!
    echo   Port 3306 is in use
    pause
    exit /b 0
)

:: Start MySQL
echo   Starting MySQL...
start "MySQL Server" "%MYSQL_HOME%\bin\mysqld.exe" --defaults-file="%MYSQL_HOME%\my.ini" --console

echo.
echo   MySQL is starting...
echo   Waiting 10 seconds...
timeout /t 10 /nobreak >nul

:: Verify connection
"%MYSQL_HOME%\bin\mysql.exe" -u root -proot123 -e "SELECT 'MySQL is running!' as status;" 2>nul
if not errorlevel 1 (
    echo.
    echo   MySQL started successfully!
    echo.
    echo   Database Info:
    echo     Host:     localhost:3306
    echo     User:     root
    echo     Password: root123
    echo     Database: ct_platform
) else (
    echo.
    echo   MySQL startup failed, please check logs
)

echo.
pause
