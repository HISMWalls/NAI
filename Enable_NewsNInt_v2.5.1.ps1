$os = [System.Environment]::OSVersion.Version

function Disable-NewsAndInterests {
    $isWindows10 = $os -match "9."
    $regPath10 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
    $regName10 = "EnableFeeds"
    $regPath11 = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
    $regName11 = "AllowNewsAndInterests"

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

}

Disable-NewsAndInterests

shutdown.exe -r -t 00