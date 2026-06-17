@echo off
REM ChatLog Rollback Utility
REM Restores ChatLog from a previous backup

setlocal enabledelayedexpansion

echo ChatLog Rollback Utility
echo =======================

REM Set directories
set "CHATLOG_DIR=%USERPROFILE%\.agents\skills\chatlog"
set "BACKUP_DIR=%USERPROFILE%\.agents\skills\chatlog_backup"

REM Check if backup directory exists
if not exist "%BACKUP_DIR%" (
    echo [ERROR] Backup directory not found: %BACKUP_DIR%
    echo No backups available for rollback.
    pause
    exit /b 1
)

echo Available backups:
echo =================

set "backup_count=0"
for /f "delims=" %%i in ('dir "%BACKUP_DIR%" /ad /b 2^>nul') do (
    set /a backup_count+=1
    echo !backup_count!. %%i
    set "backup_!backup_count!=%%i"
)

if !backup_count! EQU 0 (
    echo No backups found.
    pause
    exit /b 1
)

echo.
echo Select backup to restore (1-!backup_count!):
set /p "choice=Choice: "

REM Validate choice
if not defined backup_%choice% (
    echo Invalid choice.
    pause
    exit /b 1
)

for %%i in (!choice!) do set "selected_backup=!backup_%%i!"

echo.
echo Selected backup: !selected_backup!
echo.

REM Confirm rollback
echo WARNING: This will replace your current ChatLog installation!
echo All current files will be deleted and replaced with the backup.
echo.
echo Are you sure you want to proceed? (Y/N)
set /p "confirm="
if /i not "!confirm!"=="Y" (
    echo Rollback cancelled.
    pause
    exit /b 0
)

REM Perform rollback
echo Performing rollback...
echo Source: %BACKUP_DIR%\!selected_backup!
echo Destination: %CHATLOG_DIR%

REM Remove current installation
if exist "%CHATLOG_DIR%" (
    echo Removing current installation...
    rmdir /s /q "%CHATLOG_DIR%" >nul 2>&1
)

REM Restore from backup
echo Restoring from backup...
xcopy "%BACKUP_DIR%\!selected_backup!" "%CHATLOG_DIR%" /E /I /Q /Y >nul 2>&1

if !errorlevel! EQU 0 (
    echo [SUCCESS] Rollback completed successfully!
    echo ChatLog has been restored to the selected backup version.
    
    REM Display backup info if available
    if exist "%BACKUP_DIR%\!selected_backup!\backup_info.txt" (
        echo.
        echo Backup information:
        type "%BACKUP_DIR%\!selected_backup!\backup_info.txt"
    )
) else (
    echo [ERROR] Failed to restore from backup
    exit /b 1
)

echo.
pause