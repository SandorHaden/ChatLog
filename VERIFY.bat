@echo off
echo ChatLog Verification Script
echo ==========================
echo.

REM Define ChatLog directory
set "CHATLOG_DIR=%USERPROFILE%\.agents\skills\chatlog"

echo Checking if ChatLog is properly installed...
echo.

REM Check if the directory exists
if exist "%CHATLOG_DIR%" (
    echo [OK] ChatLog directory found: %CHATLOG_DIR%
) else (
    echo [ERROR] ChatLog directory not found: %CHATLOG_DIR%
    echo Please run INSTALL.bat to install ChatLog
    pause
    exit /b
)

REM Check for required files
set "ERRORS=0"

if exist "%CHATLOG_DIR%\SKILL.md" (
    echo [OK] SKILL.md found
) else (
    echo [ERROR] SKILL.md not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\docs\ChatLog-Convention.md" (
    echo [OK] docs\ChatLog-Convention.md found
) else (
    echo [ERROR] docs\ChatLog-Convention.md not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\assets\ChatLog-Splash.txt" (
    echo [OK] assets\ChatLog-Splash.txt found
) else (
    echo [ERROR] assets\ChatLog-Splash.txt not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\assets\VERSION.txt" (
    echo [OK] assets\VERSION.txt found
) else (
    echo [ERROR] assets\VERSION.txt not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\check_version.ps1" (
    echo [OK] check_version.ps1 found
) else (
    echo [ERROR] check_version.ps1 not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\backup_chatlog.bat" (
    echo [OK] backup_chatlog.bat found
) else (
    echo [ERROR] backup_chatlog.bat not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\rollback_chatlog.bat" (
    echo [OK] rollback_chatlog.bat found
) else (
    echo [ERROR] rollback_chatlog.bat not found
    set /a ERRORS+=1
)

if exist "%CHATLOG_DIR%\external_rollback.bat" (
    echo [OK] external_rollback.bat found
) else (
    echo [ERROR] external_rollback.bat not found
    set /a ERRORS+=1
)

echo.
if %ERRORS% == 0 (
    echo Verification successful! ChatLog is properly installed.
    echo.
    echo To use ChatLog in a project:
    echo 1. Create a docs\conversations directory in your project
    echo 2. Add the ChatLog configuration to your project's MEMORY.md
    echo 3. Start a new Qwen Code session
    echo.
    echo You should see the ChatLog splash art at session start.
) else (
    echo Verification failed! %ERRORS% files missing.
    echo Please run INSTALL.bat to reinstall ChatLog.
)

echo.
pause