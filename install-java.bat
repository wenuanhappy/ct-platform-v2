@echo off
chcp 65001 >nul
echo ================================================
echo   安装 Java JDK 17
echo ================================================
echo.
echo   正在通过 Chocolatey 安装 OpenJDK 17...
echo   如果提示需要管理员权限，请选择"是"
echo.
powershell.exe -Command "Start-Process cmd -ArgumentList '/c choco install openjdk17 -y --no-progress' -Verb RunAs -Wait"
echo.
echo   安装完成！请关闭此窗口并重新运行 start-all-services.bat
echo.
pause
