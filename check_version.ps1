# ChatLog Version Checker
# Checks for updates from GitHub and returns update information

try {
    # Get current version
    $currentVersion = "1.0.0"
    $versionFile = Join-Path $PSScriptRoot "assets\VERSION.txt"
    if (Test-Path $versionFile) {
        $currentVersion = Get-Content $versionFile -Raw | ForEach-Object { $_.Trim() }
    }
    
    Write-Host "Current version: $currentVersion"
    
    # Check for internet connection
    try {
        $response = Invoke-WebRequest -Uri "https://github.com" -TimeoutSec 5 -UseBasicParsing
    } catch {
        Write-Host "No internet connection. Skipping update check."
        exit 0
    }
    
    # Get latest version from GitHub
    try {
        $latestVersion = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SandorHaden/ChatLog/master/assets/VERSION.txt" -UseBasicParsing | ForEach-Object { $_.Content.Trim() }
        Write-Host "Latest version: $latestVersion"
        
        # Compare versions
        if ([System.Version]$latestVersion -gt [System.Version]$currentVersion) {
            Write-Host "UPDATE_AVAILABLE:$latestVersion"
            Write-Host "IMPORTANT: A backup of your current installation will be created before updating."
            Write-Host "You can rollback to this version if needed by running rollback_chatlog.bat"
        } else {
            Write-Host "UP_TO_DATE"
        }
    } catch {
        Write-Host "Could not check for updates. GitHub may be unreachable."
        exit 1
    }
} catch {
    Write-Host "Error checking for updates: $($_.Exception.Message)"
    exit 1
}