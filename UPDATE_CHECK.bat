@echo off
REM ChatLog Version Checker
REM Checks for updates from GitHub and offers to install them

setlocal enabledelayedexpansion

echo ChatLog Version Checker
echo ======================

REM Get current version
if exist "%~dp0assets\VERSION.txt" (
    set /p CURRENT_VERSION=<"%~dp0assets\VERSION.txt"
) else (
    set CURRENT_VERSION=1.2.0
    echo Current version file not found, assuming version 1.2.0
)

echo Current version: %CURRENT_VERSION%

REM Check for internet connection
ping github.com -n 1 -w 1000 >nul 2>&1
if errorlevel 1 (
    echo No internet connection. Skipping update check.
    exit /b
)

REM Download latest version info from GitHub
echo Checking for updates...
curl.exe -s -L -o "%TEMP%\chatlog_latest_version.txt" "https://raw.githubusercontent.com/SandorHaden/ChatLog/master/assets/VERSION.txt" 2>nul

if exist "%TEMP%\chatlog_latest_version.txt" (
    set /p LATEST_VERSION=<"%TEMP%\chatlog_latest_version.txt"
    del "%TEMP%\chatlog_latest_version.txt" >nul 2>&1
    
    echo Latest version: !LATEST_VERSION!
    
    REM Compare versions (simple string comparison for now)
    if "!LATEST_VERSION!" GTR "%CURRENT_VERSION%" (
        echo.
        echo A new version of ChatLog is available: !LATEST_VERSION!
        echo Your current version is: %CURRENT_VERSION%
        echo.
        echo IMPORTANT: A backup of your current installation will be created
        echo before updating. You can rollback to this version if needed.
        echo.
        echo Would you like to:
        echo 1. Create backup only
        echo 2. Update with backup
        echo 3. Update without backup (not recommended)
        echo 4. Cancel
        echo.
        echo Enter your choice (1-4):
        set /p UPDATE_CHOICE=""
        
        if "!UPDATE_CHOICE!"=="1" (
            echo Creating backup...
            call "%~dp0backup_chatlog.bat"
            echo Backup created. No update performed.
            pause
            exit /b
        ) else if "!UPDATE_CHOICE!"=="2" (
            echo Creating backup before update...
            call "%~dp0backup_chatlog.bat"
            
            echo Downloading update...
            curl.exe -L -o "%TEMP%\ChatLog-latest.zip" "https://github.com/SandorHaden/ChatLog/archive/refs/heads/master.zip" 2>nul
            
            if exist "%TEMP%\ChatLog-latest.zip" (
                echo Extracting update...
                powershell -Command "Expand-Archive -Path '%TEMP%\ChatLog-latest.zip' -DestinationPath '%TEMP%\ChatLog-update' -Force" >nul 2>&1
                
                echo Installing update...
                xcopy "%TEMP%\ChatLog-update\ChatLog-master\*" "%~dp0" /E /Y /Q >nul 2>&1
                
                echo Cleaning up...
                del "%TEMP%\ChatLog-latest.zip" >nul 2>&1
                rmdir /s /q "%TEMP%\ChatLog-update" >nul 2>&1
                
                echo Update completed successfully!
                echo ChatLog has been updated to version !LATEST_VERSION!
                echo A backup of your previous version has been saved.
                echo To rollback, run rollback_chatlog.bat
            ) else (
                echo Failed to download update.
            )
        ) else if "!UPDATE_CHOICE!"=="3" (
            echo.
            echo WARNING: Updating without backup!
            echo You will not be able to rollback to the previous version.
            echo.
            echo Are you sure you want to continue? (Y/N)
            set /p CONFIRM=""
            if /i "!CONFIRM!"=="Y" (
                echo Downloading update...
                curl.exe -L -o "%TEMP%\ChatLog-latest.zip" "https://github.com/SandorHaden/ChatLog/archive/refs/heads/master.zip" 2>nul
                
                if exist "%TEMP%\ChatLog-latest.zip" (
                    echo Extracting update...
                    powershell -Command "Expand-Archive -Path '%TEMP%\ChatLog-latest.zip' -DestinationPath '%TEMP%\ChatLog-update' -Force" >nul 2>&1
                    
                    echo Installing update...
                    xcopy "%TEMP%\ChatLog-update\ChatLog-master\*" "%~dp0" /E /Y /Q >nul 2>&1
                    
                    echo Cleaning up...
                    del "%TEMP%\ChatLog-latest.zip" >nul 2>&1
                    rmdir /s /q "%TEMP%\ChatLog-update" >nul 2>&1
                    
                    echo Update completed successfully!
                    echo ChatLog has been updated to version !LATEST_VERSION!
                ) else (
                    echo Failed to download update.
                )
            ) else (
                echo Update cancelled.
            )
        ) else (
            echo Update cancelled.
        )
    ) else (
        echo ChatLog is up to date.
    )
) else (
    echo Could not check for updates. GitHub may be unreachable.
)

echo.
pause