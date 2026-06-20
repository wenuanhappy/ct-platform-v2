@echo off
chcp 65001 >nul 2>&1
setlocal

echo ================================================
echo   Java Environment Setup
echo ================================================
echo.

set "JDK_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot"
set "JDK_BIN=%JDK_HOME%\bin"

:: Check if JDK exists
if not exist "%JDK_HOME%\bin\java.exe" (
    echo ERROR: JDK not found at:
    echo   %JDK_HOME%
    echo.
    echo Please verify the JDK installation path
    pause
    exit /b 1
)

echo Found JDK at: %JDK_HOME%
echo.

:: Check if already in PATH
echo Checking current PATH...
echo %PATH% | findstr /i "jdk-17" >nul
if not errorlevel 1 (
    echo JDK is already in PATH
    goto :verify
)

:: Add to User PATH
echo.
echo Adding JDK to User PATH...
setx PATH "%JDK_BIN%;%PATH%" >nul 2>&1

:: Also set JAVA_HOME
echo Setting JAVA_HOME...
setx JAVA_HOME "%JDK_HOME%" >nul 2>&1

:verify
echo.
echo ================================================
echo   Setup Complete!
echo ================================================
echo.
echo JDK Path: %JDK_HOME%
echo.
echo IMPORTANT: You need to restart your terminal/CMD
echo            for the changes to take effect.
echo.
echo Please close this window and open a new CMD,
echo then run: java -version
echo.

:: Verify in current session
set "PATH=%JDK_BIN%;%PATH%"
echo.
echo Verifying in new session:
java -version 2>&1 | findstr /i "version"
echo.
if errorlevel 1 (
    echo Please restart CMD and try again
) else (
    echo SUCCESS! Java is now configured
)

pause
