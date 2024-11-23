$os = [System.Environment]::OSVersion.Version

function Enable-NewsAndInterests {
    $isWindows10 = $os -match "9."
    $regPath10 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
    $regName10 = "EnableFeeds"
    $regPath11 = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
    $regName11 = "AllowNewsAndInterests"

    Write-Host "Enabling News and Interests"
    Remove-ItemProperty -Path $regPath10 -Name $regName10 -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $regPath10 -Force -ErrorAction SilentlyContinue

    if (-not $isWindows10) {
        Remove-ItemProperty -Path $regPath11 -Name $regName11 -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $regPath10 -Name $regName10 -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $regPath11 -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $regPath10 -Force -ErrorAction SilentlyContinue
    }

}

Enable-NewsAndInterests

shutdown.exe -r -t 00