# Git Automation Script for WMS Project
# PowerShell Version

param(
    [string]$Action = "",
    [string]$CommitMessage = "",
    [switch]$AutoCommit = $false,
    [switch]$Force = $false
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Test-GitInstallation {
    try {
        $gitVersion = git --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ Git is available: $gitVersion" "Green"
            return $true
        }
    }
    catch {
        Write-ColorOutput "❌ Git is not installed or not in PATH" "Red"
        Write-ColorOutput "Please install Git from: https://git-scm.com/downloads" "Yellow"
        return $false
    }
    return $false
}

function Test-GitRepository {
    try {
        git status 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ In Git repository" "Green"
            return $true
        }
    }
    catch {
        Write-ColorOutput "❌ Not in a Git repository" "Red"
        return $false
    }
    return $false
}

function Get-GitStatus {
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Current Git Status" "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    git status
    Write-ColorOutput ""
}

function Show-GitHistory {
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Recent Commit History" "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    git log --oneline -10
    Write-ColorOutput ""
}

function Invoke-GitPull {
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Pulling latest changes from remote..." "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    # Check for local changes
    $hasChanges = git status --porcelain 2>$null
    if ($hasChanges) {
        Write-ColorOutput "⚠️  You have local changes. Stashing them before pull..." "Yellow"
        $stashMessage = "Auto-stash before pull - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git stash push -m $stashMessage
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "❌ Failed to stash changes" "Red"
            return $false
        }
    }
    
    # Fetch and pull
    Write-ColorOutput "Fetching from remote..." "Yellow"
    git fetch origin
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Failed to fetch from remote" "Red"
        return $false
    }
    
    Write-ColorOutput "Pulling changes..." "Yellow"
    git pull origin main
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Failed to pull changes" "Red"
        # Restore stashed changes if pull failed
        if (Test-Path ".git/refs/stash") {
            Write-ColorOutput "Restoring stashed changes..." "Yellow"
            git stash pop
        }
        return $false
    }
    
    # Restore stashed changes if they exist
    if (Test-Path ".git/refs/stash") {
        Write-ColorOutput "Restoring stashed changes..." "Yellow"
        git stash pop
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "⚠️  Warning: Could not restore stashed changes" "Yellow"
            Write-ColorOutput "Use 'git stash list' and 'git stash pop' to restore manually" "Yellow"
        }
    }
    
    Write-ColorOutput "✅ Successfully pulled latest changes" "Green"
    return $true
}

function Invoke-GitCommit {
    param([string]$Message = "")
    
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Staging and committing changes..." "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    # Check if there are changes to commit
    $hasChanges = git status --porcelain 2>$null
    if (-not $hasChanges) {
        Write-ColorOutput "ℹ️  No changes to commit" "Blue"
        return $true
    }
    
    Write-ColorOutput "Current changes:" "Yellow"
    git status --short
    Write-ColorOutput ""
    
    # Stage all changes
    Write-ColorOutput "Staging all changes..." "Yellow"
    git add .
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Failed to stage changes" "Red"
        return $false
    }
    
    Write-ColorOutput "✅ Changes staged successfully" "Green"
    Write-ColorOutput ""
    
    # Get commit message
    if (-not $Message) {
        if ($AutoCommit) {
            $Message = "WMS PL/SQL updates - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        } else {
            $Message = Read-Host "Enter commit message (or press Enter for default)"
            if (-not $Message) {
                $Message = "WMS PL/SQL updates - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            }
        }
    }
    
    Write-ColorOutput "Committing with message: $Message" "Yellow"
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Failed to commit changes" "Red"
        return $false
    }
    
    Write-ColorOutput "✅ Changes committed successfully" "Green"
    return $true
}

function Invoke-GitPush {
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Pushing changes to remote..." "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    # Check if there are commits to push
    $commitsToPush = git log --oneline origin/main..HEAD 2>$null
    if (-not $commitsToPush) {
        Write-ColorOutput "ℹ️  No commits to push" "Blue"
        return $true
    }
    
    Write-ColorOutput "Commits to push:" "Yellow"
    $commitsToPush
    Write-ColorOutput ""
    
    Write-ColorOutput "Pushing to remote..." "Yellow"
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Failed to push changes" "Red"
        Write-ColorOutput "This might be due to:" "Yellow"
        Write-ColorOutput "- Network issues" "Yellow"
        Write-ColorOutput "- Authentication problems" "Yellow"
        Write-ColorOutput "- Remote repository access issues" "Yellow"
        return $false
    }
    
    Write-ColorOutput "✅ Changes pushed successfully" "Green"
    return $true
}

function Invoke-FullWorkflow {
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput "Running full workflow (Pull + Commit + Push)" "Cyan"
    Write-ColorOutput "========================================" "Cyan"
    Write-ColorOutput ""
    
    Write-ColorOutput "Step 1: Pulling latest changes..." "Yellow"
    if (-not (Invoke-GitPull)) {
        Write-ColorOutput "❌ Pull failed, stopping workflow" "Red"
        return $false
    }
    
    Write-ColorOutput "`nStep 2: Committing changes..." "Yellow"
    if (-not (Invoke-GitCommit)) {
        Write-ColorOutput "❌ Commit failed, stopping workflow" "Red"
        return $false
    }
    
    Write-ColorOutput "`nStep 3: Pushing changes..." "Yellow"
    if (-not (Invoke-GitPush)) {
        Write-ColorOutput "❌ Push failed, stopping workflow" "Red"
        return $false
    }
    
    Write-ColorOutput "`n✅ Full workflow completed successfully!" "Green"
    return $true
}

function Show-Menu {
    Write-ColorOutput "`nChoose an operation:" "Cyan"
    Write-ColorOutput "1. Pull latest changes from remote" "White"
    Write-ColorOutput "2. Stage and commit changes" "White"
    Write-ColorOutput "3. Push changes to remote" "White"
    Write-ColorOutput "4. Full workflow (Pull + Commit + Push)" "White"
    Write-ColorOutput "5. Show current status" "White"
    Write-ColorOutput "6. Show commit history" "White"
    Write-ColorOutput "7. Exit" "White"
    Write-ColorOutput ""
}

# Main execution
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "Git Automation Script for WMS Project" "Cyan"
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput ""

# Check prerequisites
if (-not (Test-GitInstallation)) {
    exit 1
}

if (-not (Test-GitRepository)) {
    exit 1
}

# Handle command line arguments
if ($Action) {
    switch ($Action.ToLower()) {
        "pull" { Invoke-GitPull }
        "commit" { Invoke-GitCommit -Message $CommitMessage }
        "push" { Invoke-GitPush }
        "full" { Invoke-FullWorkflow }
        "status" { Get-GitStatus }
        "history" { Show-GitHistory }
        default { Write-ColorOutput "Unknown action: $Action" "Red" }
    }
    exit 0
}

# Interactive mode
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-7)"
    
    switch ($choice) {
        "1" { Invoke-GitPull }
        "2" { Invoke-GitCommit }
        "3" { Invoke-GitPush }
        "4" { Invoke-FullWorkflow }
        "5" { Get-GitStatus }
        "6" { Show-GitHistory }
        "7" { 
            Write-ColorOutput "`nThank you for using Git Automation Script!" "Green"
            exit 0 
        }
        default { Write-ColorOutput "Invalid choice. Please try again." "Red" }
    }
    
    if ($choice -ne "7") {
        Read-Host "`nPress Enter to continue"
    }
} while ($choice -ne "7") 