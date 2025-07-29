@echo off
echo ========================================
echo Quick Git Operations for WMS Project
echo ========================================
echo.

REM Check if Git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git is not installed or not in PATH
    pause
    exit /b 1
)

REM Check if we're in a Git repository
git status >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Not in a Git repository
    pause
    exit /b 1
)

echo Choose operation:
echo 1. Quick Commit & Push (all changes)
echo 2. Pull latest changes
echo 3. Show status
echo 4. Show recent commits
echo.
set /p choice="Enter choice (1-4): "

if "%choice%"=="1" goto quick_commit_push
if "%choice%"=="2" goto quick_pull
if "%choice%"=="3" goto show_status
if "%choice%"=="4" goto show_commits
echo Invalid choice
pause
exit /b 1

:quick_commit_push
echo.
echo ========================================
echo Quick Commit & Push
echo ========================================
echo.

REM Check if there are changes
git status --porcelain | findstr "^" >nul 2>&1
if %errorlevel% neq 0 (
    echo ℹ️  No changes to commit
    pause
    exit /b 0
)

echo Staging all changes...
git add .
if %errorlevel% neq 0 (
    echo ❌ Failed to stage changes
    pause
    exit /b 1
)

echo Committing changes...
git commit -m "WMS PL/SQL updates - %date% %time%"
if %errorlevel% neq 0 (
    echo ❌ Failed to commit changes
    pause
    exit /b 1
)

echo Pushing to remote...
git push origin main
if %errorlevel% neq 0 (
    echo ❌ Failed to push changes
    pause
    exit /b 1
)

echo ✅ Successfully committed and pushed changes
pause
exit /b 0

:quick_pull
echo.
echo ========================================
echo Quick Pull
echo ========================================
echo.

echo Pulling latest changes...
git pull origin main
if %errorlevel% neq 0 (
    echo ❌ Failed to pull changes
    pause
    exit /b 1
)

echo ✅ Successfully pulled latest changes
pause
exit /b 0

:show_status
echo.
echo ========================================
echo Git Status
echo ========================================
echo.

git status
echo.
pause
exit /b 0

:show_commits
echo.
echo ========================================
echo Recent Commits
echo ========================================
echo.

git log --oneline -10
echo.
pause
exit /b 0 