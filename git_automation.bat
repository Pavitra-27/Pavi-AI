@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Git Automation Script for WMS Project
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git is not installed or not in PATH
    echo Please install Git from: https://git-scm.com/downloads
    pause
    exit /b 1
)

echo ✅ Git is available
echo.

REM Check if we're in a Git repository
git status >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Not in a Git repository
    echo Please navigate to your Git repository directory
    pause
    exit /b 1
)

echo ✅ In Git repository
echo.

:menu
echo Choose an operation:
echo 1. Pull latest changes from remote
echo 2. Stage and commit changes
echo 3. Push changes to remote
echo 4. Full workflow (Pull + Commit + Push)
echo 5. Show current status
echo 6. Show commit history
echo 7. Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto pull_changes
if "%choice%"=="2" goto commit_changes
if "%choice%"=="3" goto push_changes
if "%choice%"=="4" goto full_workflow
if "%choice%"=="5" goto show_status
if "%choice%"=="6" goto show_history
if "%choice%"=="7" goto end
echo Invalid choice. Please try again.
goto menu

:pull_changes
echo.
echo ========================================
echo Pulling latest changes from remote...
echo ========================================
echo.

git fetch origin
if %errorlevel% neq 0 (
    echo ❌ Failed to fetch from remote
    pause
    goto menu
)

git status --porcelain | findstr "^" >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  You have local changes. Stashing them before pull...
    git stash push -m "Auto-stash before pull - %date% %time%"
    if %errorlevel% neq 0 (
        echo ❌ Failed to stash changes
        pause
        goto menu
    )
)

git pull origin main
if %errorlevel% neq 0 (
    echo ❌ Failed to pull changes
    if exist ".git/refs/stash" (
        echo Restoring stashed changes...
        git stash pop
    )
    pause
    goto menu
)

if exist ".git/refs/stash" (
    echo Restoring stashed changes...
    git stash pop
    if %errorlevel% neq 0 (
        echo ⚠️  Warning: Could not restore stashed changes
        echo Use 'git stash list' and 'git stash pop' to restore manually
    )
)

echo ✅ Successfully pulled latest changes
pause
goto menu

:commit_changes
echo.
echo ========================================
echo Staging and committing changes...
echo ========================================
echo.

REM Check if there are changes to commit
git status --porcelain | findstr "^" >nul 2>&1
if %errorlevel% neq 0 (
    echo ℹ️  No changes to commit
    pause
    goto menu
)

echo Current changes:
git status --short
echo.

REM Stage all changes
echo Staging all changes...
git add .
if %errorlevel% neq 0 (
    echo ❌ Failed to stage changes
    pause
    goto menu
)

echo ✅ Changes staged successfully
echo.

REM Get commit message
set /p commit_msg="Enter commit message (or press Enter for default): "
if "!commit_msg!"=="" (
    set commit_msg="WMS PL/SQL updates - %date% %time%"
) else (
    set commit_msg="!commit_msg!"
)

echo.
echo Committing with message: !commit_msg!
git commit -m !commit_msg!
if %errorlevel% neq 0 (
    echo ❌ Failed to commit changes
    pause
    goto menu
)

echo ✅ Changes committed successfully
pause
goto menu

:push_changes
echo.
echo ========================================
echo Pushing changes to remote...
echo ========================================
echo.

REM Check if there are commits to push
git log --oneline origin/main..HEAD | findstr "^" >nul 2>&1
if %errorlevel% neq 0 (
    echo ℹ️  No commits to push
    pause
    goto menu
)

echo Commits to push:
git log --oneline origin/main..HEAD
echo.

echo Pushing to remote...
git push origin main
if %errorlevel% neq 0 (
    echo ❌ Failed to push changes
    echo This might be due to:
    echo - Network issues
    echo - Authentication problems
    echo - Remote repository access issues
    pause
    goto menu
)

echo ✅ Changes pushed successfully
pause
goto menu

:full_workflow
echo.
echo ========================================
echo Running full workflow (Pull + Commit + Push)
echo ========================================
echo.

echo Step 1: Pulling latest changes...
call :pull_changes
if %errorlevel% neq 0 (
    echo ❌ Pull failed, stopping workflow
    pause
    goto menu
)

echo.
echo Step 2: Committing changes...
call :commit_changes
if %errorlevel% neq 0 (
    echo ❌ Commit failed, stopping workflow
    pause
    goto menu
)

echo.
echo Step 3: Pushing changes...
call :push_changes
if %errorlevel% neq 0 (
    echo ❌ Push failed, stopping workflow
    pause
    goto menu
)

echo.
echo ✅ Full workflow completed successfully!
pause
goto menu

:show_status
echo.
echo ========================================
echo Current Git Status
echo ========================================
echo.

git status
echo.
pause
goto menu

:show_history
echo.
echo ========================================
echo Recent Commit History
echo ========================================
echo.

git log --oneline -10
echo.
pause
goto menu

:end
echo.
echo Thank you for using Git Automation Script!
echo.
exit /b 0 