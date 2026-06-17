@echo off
echo ChatLog Installation Script
echo ==========================
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

echo This script will install ChatLog to your Qwen Code skills directory.
echo.

REM Define source and destination directories
set "SOURCE_DIR=%~dp0"
set "DEST_DIR=%USERPROFILE%\.agents\skills\chatlog"

echo Source directory: %SOURCE_DIR%
echo Destination directory: %DEST_DIR%
echo.

REM Confirm installation
echo Do you want to proceed with the installation? (Y/N)
set /p CONFIRM=""
if /i "%CONFIRM%" neq "Y" (
    echo Installation cancelled.
    pause
    exit /b
)

echo.
echo Installing ChatLog...

REM Create destination directory if it doesn't exist
if not exist "%DEST_DIR%" (
    echo Creating directory: %DEST_DIR%
    mkdir "%DEST_DIR%"
)

REM Copy files
echo Copying SKILL.md...
copy "%SOURCE_DIR%SKILL.md" "%DEST_DIR%" >nul

if not exist "%DEST_DIR%\docs" (
    echo Creating docs directory
    mkdir "%DEST_DIR%\docs"
)

echo Copying ChatLog-Convention.md...
copy "%SOURCE_DIR%docs\ChatLog-Convention.md" "%DEST_DIR%\docs" >nul

if not exist "%DEST_DIR%\assets" (
    echo Creating assets directory
    mkdir "%DEST_DIR%\assets"
)

echo Copying ChatLog-Splash.txt...
copy "%SOURCE_DIR%assets\ChatLog-Splash.txt" "%DEST_DIR%\assets" >nul

echo.
echo Installation complete!
echo.
echo To use ChatLog in a project:
echo 1. Create a docs\conversations directory in your project
echo 2. Add the ChatLog configuration to your project's MEMORY.md
echo 3. Start a new Qwen Code session
echo.
echo You should now see the ChatLog splash art at session start.
echo.
pause