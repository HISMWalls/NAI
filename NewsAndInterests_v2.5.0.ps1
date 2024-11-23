# Gather info to validate Windows 11/10
$os = [System.Environment]::OSVersion.Version

# Ensure we're running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Insufficent Permissions(RunAs Administrator)"
    exit
}

# Function to modify News and Interests settings
function Set-NewsAndInterests {
    param (
        [string]$action
    )

    $isWindows10 = $os -match "9."
    $regPath10 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
    $regName10 = "EnableFeeds"
    $regPath11 = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
    $regName11 = "AllowNewsAndInterests"

    if ($action -eq "Enable") {
        Write-Host "Enabling News and Interests"
        Remove-ItemProperty -Path $regPath10 -Name $regName10 -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $regPath10 -Force -ErrorAction SilentlyContinue

        if (-not $isWindows10) {
            Remove-ItemProperty -Path $regPath11 -Name $regName11 -Force -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $regPath10 -Name $regName10 -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $regPath11 -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $regPath10 -Force -ErrorAction SilentlyContinue
        }
    } elseif ($action -eq "Disable") {
        Write-Host "Disabling News and Interests"
        if (!(Test-Path $regPath10)) {
            New-Item -Path $regPath10 -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath10 -Name $regName10 -Value 0 -Type DWord

        if (-not $isWindows10) {
            if (!(Test-Path $regPath11)) {
                New-Item -Path $regPath11 -Force | Out-Null
            }
            Set-ItemProperty -Path $regPath10 -Name $regName10 -Value 0 -Type DWord
            Set-ItemProperty -Path $regPath11 -Name $regName11 -Value 0 -Type DWord
        }
    } else {
        Write-Host "Invalid action specified. Use 'Enable' or 'Disable'."
    }
}

# Call the function based on user request.
$usrRequest = Read-Host "Enable or Disable?: (eE/dD): e"
$action = if ($usrRequest -match "[eE]") { "Disable" } elseif ($usrRequest -match "[dD]") { "Enable" } else { "" }

if ($action) {
    Set-NewsAndInterests -action $action
    Write-Host "News and Interests has been $action`d for all users."
} else {
    Write-Host "Please provide a valid input."
}

# Prompt for restart
$restart = Read-Host "A system restart is recommended. Would you like to restart now? (Y/N)"
if ($restart -match "[yY]") {
    Restart-Computer -Force
}