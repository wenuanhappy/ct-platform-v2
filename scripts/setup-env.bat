@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

set "PROJECT_ROOT=%~dp0.."
set "BACKEND_DIR=%PROJECT_ROOT%\backend"
set "FRONTEND_DIR=%PROJECT_ROOT%\frontend"
set "MYSQL_HOME=%PROJECT_ROOT%\mysql-portable\mysql-8.0.36-winx64"

:: Common installation paths
set "JDK_PATH=C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot"
set "MAVEN_PATH=C:\apache-maven-3.9.16"

:: Refresh environment variables from registry
set "JAVA_HOME_TEMP=%JAVA_HOME%"
set "MAVEN_HOME_TEMP=%MAVEN_HOME%"

:: Try to get JAVA_HOME from system if not set
if "%JAVA_HOME_TEMP%"=="" (
    for /f "tokens=2,* delims==" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v JAVA_HOME 2^>nul') do set "JAVA_HOME_TEMP=%%a"
    set "JAVA_HOME_TEMP=!JAVA_HOME_TEMP:~1!"
)

:: Try to get MAVEN_HOME from system if not set
if "%MAVEN_HOME_TEMP%"=="" (
    for /f "tokens=2,* delims==" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MAVEN_HOME 2^>nul') do set "MAVEN_HOME_TEMP=%%a"
    set "MAVEN_HOME_TEMP=!MAVEN_HOME_TEMP:~1!"
)

:: Use system values if available
if not "%JAVA_HOME_TEMP%"=="" set "JAVA_HOME=%JAVA_HOME_TEMP%"
if not "%MAVEN_HOME_TEMP%"=="" set "MAVEN_HOME=%MAVEN_HOME_TEMP%"

:: If still empty, use default paths
if "%JAVA_HOME%"=="" set "JAVA_HOME=%JDK_PATH%"
if "%MAVEN_HOME%"=="" set "MAVEN_HOME=%MAVEN_PATH%"

echo ================================================
echo   Computational Thinking Platform
echo   Startup Script v1.4
echo ================================================
echo.

:: Step 1: Check Java
echo [1/6] Checking Java...
if exist "%JAVA_HOME%\bin\java.exe" (
    echo   Using: %JAVA_HOME%
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    java -version 2>&1 | findstr /i "version"
) else (
    echo   ERROR: Java not found at %JAVA_HOME%
    echo   Please install JDK 17+
    pause
    exit /b 1
)
echo.

:: Step 2: Check Node.js
echo [2/6] Checking Node.js...
node -v >nul 2>&1
if errorlevel 1 (
    echo   ERROR: Node.js not found!
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node -v') do echo   %%v
echo.

:: Step 3: Check Maven
echo [3/6] Checking Maven...
if exist "%MAVEN_HOME%\bin\mvn.cmd" (
    echo   Using: %MAVEN_HOME%
    set "PATH=%MAVEN_HOME%\bin;%PATH%"
) else (
    echo   ERROR: Maven not found at %MAVEN_HOME%
    pause
    exit /b 1
)
echo.

:: Step 4: Check MySQL
echo [4/6] Checking MySQL...
netstat | findstr ":3306" >nul
if errorlevel 1 (
    echo   Starting MySQL...
    start /min "" "%MYSQL_HOME%\bin\mysqld.exe" --defaults-file="%MYSQL_HOME%\my.ini" --console
    timeout /t 10 /nobreak >nul
) else (
    echo   MySQL is running
)
echo.

:: Step 5: Check database
echo [5/6] Verifying database...
"%MYSQL_HOME%\bin\mysql.exe" -u root -proot123 -e "USE ct_platform; SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo   Running init-database.bat...
    call "%PROJECT_ROOT%\scripts\init-database.bat"
)
echo   Database OK
echo.

:: Step 6: Start backend
echo [6/6] Starting services...
cd /d "%BACKEND_DIR%"
start "Backend - Spring Boot" cmd /k "title Backend && mvn spring-boot:run"
echo   Backend starting...
echo.

cd /d "%FRONTEND_DIR%"
start "Frontend - Vite" cmd /k "title Frontend && npm run dev"
echo   Frontend starting...
echo.

echo ================================================
echo   All services starting!
echo ================================================
echo.
echo   Access URLs:
echo     Frontend:   http://localhost:5173
echo     Backend:    http://localhost:8080
echo.
echo   Test accounts (password: Pass1234!):
echo     admin / teacher01 / student01
echo.
pause
