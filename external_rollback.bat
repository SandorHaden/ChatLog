@echo off
REM External ChatLog Rollback Utility
REM Standalone rollback script that can be run even if ChatLog is broken

setlocal enabledelayedexpansion

echo External ChatLog Rollback Utility
echo =================================
echo This script can be run independently to restore ChatLog from backup
echo even if the main ChatLog skill is broken or corrupted.
echo.

REM Set directories
set "CHATLOG_DIR=%USERPROFILE%\.agents\skills\chatlog"
set "BACKUP_DIR=%USERPROFILE%\.agents\skills\chatlog_backup"

echo ChatLog directory: %CHATLOG_DIR%
echo Backup directory: %BACKUP_DIR%
echo.

REM Check if backup directory exists
if not exist "%BACKUP_DIR%" (
    echo [ERROR] Backup directory not found: %BACKUP_DIR%
    echo No backups available for rollback.
    echo.
    echo To create a backup, run the ChatLog backup utility first.
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
echo WARNING: This will completely replace your current ChatLog installation!
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
    if !errorlevel! NEQ 0 (
        echo [WARNING] Some files could not be removed. Proceeding anyway...
    )
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
    
    echo.
    echo You can now restart your ChatLog session.
) else (
    echo [ERROR] Failed to restore from backup
    echo Please check that you have sufficient permissions and try again.
    exit /b 1
)

echo.
echo Press any key to exit...
pause >nul