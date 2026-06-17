@echo off
echo ChatLog Development Workflow
echo ==========================
echo.

:MENU
echo What would you like to do?
echo 1. Create Git commit
echo 2. Push to GitHub
echo 3. Update ChatLog on system
echo 4. Run all (commit, push, update)
echo 5. Exit
echo.
set /p CHOICE="Enter your choice (1-5): "

if "%CHOICE%"=="1" goto COMMIT
if "%CHOICE%"=="2" goto PUSH
if "%CHOICE%"=="3" goto UPDATE
if "%CHOICE%"=="4" goto ALL
if "%CHOICE%"=="5" goto EXIT

echo Invalid choice. Please try again.
echo.
goto MENU

:COMMIT
echo.
echo Creating Git commit...
git add .
set /p COMMIT_MESSAGE="Enter commit message: "
git commit -m "%COMMIT_MESSAGE%"
echo.
echo Commit created successfully!
echo.
goto MENU

:PUSH
echo.
echo Pushing to GitHub...
git push
echo.
echo Changes pushed to GitHub successfully!
echo.
goto MENU

:UPDATE
echo.
echo Updating ChatLog on system...
REM Define source and destination directories
set "SOURCE_DIR=%~dp0"
set "DEST_DIR=C:\Users\Háden Sándor\.agents\skills\chatlog"

REM Copy files
echo Copying SKILL.md...
copy "%SOURCE_DIR%SKILL.md" "%DEST_DIR%" >nul

echo Copying ChatLog-Convention.md...
copy "%SOURCE_DIR%docs\ChatLog-Convention.md" "%DEST_DIR%\docs" >nul

echo Copying ChatLog-Splash.txt...
copy "%SOURCE_DIR%assets\ChatLog-Splash.txt" "%DEST_DIR%\assets" >nul

echo.
echo ChatLog updated on system successfully!
echo.
goto MENU

:ALL
echo.
echo Running all operations...
echo.

echo Creating Git commit...
git add .
set /p COMMIT_MESSAGE="Enter commit message: "
git commit -m "%COMMIT_MESSAGE%"

echo.
echo Pushing to GitHub...
git push

echo.
echo Updating ChatLog on system...
REM Define source and destination directories
set "SOURCE_DIR=%~dp0"
set "DEST_DIR=C:\Users\Háden Sándor\.agents\skills\chatlog"

REM Copy files
echo Copying SKILL.md...
copy "%SOURCE_DIR%SKILL.md" "%DEST_DIR%" >nul

echo Copying ChatLog-Convention.md...
copy "%SOURCE_DIR%docs\ChatLog-Convention.md" "%DEST_DIR%\docs" >nul

echo Copying ChatLog-Splash.txt...
copy "%SOURCE_DIR%assets\ChatLog-Splash.txt" "%DEST_DIR%\assets" >nul

echo.
echo All operations completed successfully!
echo.
goto MENU

:EXIT
echo.
echo Exiting development workflow.
echo.
pause
exit /b