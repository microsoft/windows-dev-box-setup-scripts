
#############################
# Start Menu
#############################

Write-Host "Configuring Start Menu..." -ForegroundColor "Yellow"

# Start Menu: Disable Fast Startup
Write-Host "Disabling Fast Startup..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0

# Start Menu: Disable Web Search in Start Menu
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1

# Start Menu: Disable Cortana in Start Menu
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0
