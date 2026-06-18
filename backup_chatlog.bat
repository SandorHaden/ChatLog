@echo off
REM ChatLog Backup Utility
REM Creates a backup of the current ChatLog installation

setlocal enabledelayedexpansion

echo ChatLog Backup Utility
echo =====================

REM Set backup directory
set "CHATLOG_DIR=%USERPROFILE%\.agents\skills\chatlog"
set "BACKUP_DIR=%USERPROFILE%\.agents\skills\chatlog_backup"

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" (
    echo Creating backup directory...
    mkdir "%BACKUP_DIR%"
)

REM Create timestamp for backup
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "timestamp=%YYYY%%MM%%DD%_%HH%%Min%%Sec%"

REM Create backup folder with timestamp
set "BACKUP_FOLDER=%BACKUP_DIR%\backup_%timestamp%"
echo Creating backup: %BACKUP_FOLDER%

if exist "%CHATLOG_DIR%" (
    echo Backing up ChatLog files...
    xcopy "%CHATLOG_DIR%" "%BACKUP_FOLDER%" /E /I /Q /Y >nul 2>&1
    
    if !errorlevel! EQU 0 (
        echo [SUCCESS] Backup created successfully: %BACKUP_FOLDER%
        
        REM Create backup info file
        echo Backup created on %YYYY%-%MM%-%DD% at %HH%:%Min%:%Sec% > "%BACKUP_FOLDER%\backup_info.txt"
        echo Source: %CHATLOG_DIR% >> "%BACKUP_FOLDER%\backup_info.txt"
        echo Version: >> "%BACKUP_FOLDER%\backup_info.txt"
        if exist "%CHATLOG_DIR%\assets\VERSION.txt" (
            type "%CHATLOG_DIR%\assets\VERSION.txt" >> "%BACKUP_FOLDER%\backup_info.txt"
        ) else (
            echo 1.2.0 >> "%BACKUP_FOLDER%\backup_info.txt"
        )
        
        echo Backup completed successfully!
    ) else (
        echo [ERROR] Failed to create backup
        exit /b 1
    )
) else (
    echo [WARNING] ChatLog directory not found: %CHATLOG_DIR%
    echo No backup created.
)

echo.
pause