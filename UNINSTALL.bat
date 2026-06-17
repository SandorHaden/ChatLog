@echo off
echo ChatLog Uninstallation Script
echo ============================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as administrator
) else (
    echo This script needs to be run as administrator
    echo Please right-click and select "Run as administrator"
    pause
    exit /b
)

echo This script will uninstall ChatLog from your Qwen Code skills directory.
echo.

REM Define ChatLog directory
set "CHATLOG_DIR=C:\Users\Háden Sándor\.agents\skills\chatlog"

echo ChatLog directory: %CHATLOG_DIR%
echo.

REM Confirm uninstallation
echo Are you sure you want to uninstall ChatLog? (Y/N)
set /p CONFIRM=""
if /i "%CONFIRM%" neq "Y" (
    echo Uninstallation cancelled.
    pause
    exit /b
)

echo.
echo Uninstalling ChatLog...

REM Check if ChatLog directory exists
if exist "%CHATLOG_DIR%" (
    echo Removing ChatLog directory...
    rmdir /s /q "%CHATLOG_DIR%"
    echo [OK] ChatLog directory removed
) else (
    echo [INFO] ChatLog directory not found, nothing to remove
)

echo.
echo Uninstallation complete!
echo.
echo Note: This only removes the ChatLog skill files.
echo Any conversation logs in your projects will remain intact.
echo.
pause