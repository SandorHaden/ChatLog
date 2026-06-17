@echo off
echo ChatLog Portability Verification Script
echo =====================================
echo.

echo Searching for hardcoded paths...
echo.

REM Search for any remaining references to the hardcoded path
findstr /s /i "C:\\Users\\Háden Sándor" *.bat *.md *.txt 2>nul
if %errorlevel% == 0 (
    echo [WARNING] Found references to hardcoded paths. These should be reviewed.
) else (
    echo [OK] No hardcoded paths found.
)

echo.
echo Searching for any remaining absolute paths...
echo.

REM Search for any remaining absolute Windows paths
findstr /s /c:"C:\Users\" *.bat *.md *.txt 2>nul | findstr /v /i "Háden Sándor"
if %errorlevel% == 0 (
    echo [INFO] Found other absolute paths. These may need review for portability.
) else (
    echo [OK] No other absolute paths found.
)

echo.
echo Verification complete.
echo.
echo This script checks for hardcoded paths that would prevent ChatLog
echo from working on other users' systems. All paths should use
echo environment variables like %%USERPROFILE%% for portability.
echo.
pause