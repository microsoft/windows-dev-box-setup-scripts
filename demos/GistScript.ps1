
# configuration for a basic windows 11 clean install

# Step 1:
# install Chocolatey if necessary and then install the necessary boxstarter modules
# 
# If you are running PowerShell v3 or higher:
# . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
# 
# If you are running PowerShell v2:
# iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

# Step 2
# Save the script to a GitHub Gist
# Click the "View Raw" link
# Copy the raw URL
# 
# Run the script:
# Install-BoxstarterPackage -PackageName [Raw Url goes here] -DisableReboots
# 
# Command will look like this:
# Install-BoxstarterPackage -PackageName https://gist.github.com/mwrock/7382880/raw/f6525387b4b524b8eccef6ed4d5ec219c82c0ac7/gistfile1.txt -DisableReboots


#############################################
# Initialization
#############################################

#--- Boxstarter options ---
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#--- Basic setup ---
Update-ExecutionPolicy -Policy RemoteSigned
Disable-UAC
Enable-RemoteDesktop
choco feature enable -n=allowGlobalConfirmation
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies


#############################################
# General Settings
#############################################

Write-Host "Configuring General Settings..." -ForegroundColor "Yellow"

# General: Set Computer Name
Write-Host "Setting Computer Name..." -ForegroundColor "Yellow"
(Get-WmiObject Win32_ComputerSystem).Rename("CHOZO") | Out-Null

# General: Enable Developer Mode: Enable: 1, Disable: 0
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 0

# General: Bash on Windows
# Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

# General: Disable Sticky Keys
Write-Host "Disabling Sticky Keys..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

# General: Enable NumLock After Startup
Write-Host "Enabling NumLock After Startup..." -ForegroundColor "Yellow"
If (!(Test-Path "HKU:")) {
	New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}
Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
Add-Type -AssemblyName System.Windows.Forms
If (!([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
	$wsh = New-Object -ComObject WScript.Shell
	$wsh.SendKeys('{NUMLOCK}')
}

# General: Permanently Delete Edge Shortcut From Desktop
# Error: Doesn't work
# If (!(Test-Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate")) {
# 	New-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" | Out-Null
# }
# Set-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "CreateDesktopShortcutDefault" -Type DWord -Value 0

# General: Windows should never ask for my feedback
Write-Host "Disabling Feedback..." -ForegroundColor "Yellow"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# This might should go down in privacy with suggested apps & content delivery manager
# General: Disable tips and suggestions for welcome and what's new: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0

# General: Disable Autoplay
Write-Host "Disabling Autoplay..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# General: Disable Shared Experiences
Write-Host "Disabling Shared Experiences..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" -Name "RomeSdkChannelUserAuthzPolicy" -Type DWord -Value 0

# General: Show Task Manager Details
# Error: This just hangs; there's a sleep timer but I'm impatient
# If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager")) {
# 	New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Force | Out-Null
# }
# $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
# If (!($preferences)) {
# 	$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
# 	While (!($preferences)) {
# 		Start-Sleep -m 250
# 		$preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
# 	}
# 	Stop-Process $taskmgr
# }
# $preferences.Preferences[28] = 0
# Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences

# General: Disable OneDrive
Write-Host "Disabling OneDrive..." -ForegroundColor "Yellow"
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1

# General: Disable Cortana
Write-Host "Disabling Cortana..." -ForegroundColor "Yellow"
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0

#############################################
# Privacy Settings
#############################################

Write-Host "Configuring Privacy..." -ForegroundColor "Yellow"

Disable-BingSearch
Disable-GameBarTips

# Privacy: Disable Telemetry
Write-Host "Disabling Telemetry..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
# #Error: Couldn't find this task
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

# If above method doesn't work
# Privacy: Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "MaxTelemetryAllowed" 1

# Privacy: Disable Advertising ID
Write-Host "Disabling Advertising ID..." -ForegroundColor "Yellow"
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value 0

# Privacy: Disable App Suggestions
Write-Host "Disabling App Suggestions..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1

# Privacy: Speech, Inking, & Typing: Stop "Getting to know me"
Write-Host "Disabling Speech, Inking, & Typing..." -ForegroundColor "Yellow"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# Privacy: Disable Map Updates
Write-Host "Disabling Map Updates..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

# Privacy: Disable Location Tracking
Write-Host "Disabling Location Tracking..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0

# Privacy: Disable Feedback
Write-Host "Disabling Feedback..." -ForegroundColor "Yellow"
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

# Privacy: Disable Error Reporting
Write-Host "Disabling Error Reporting..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null

# Privacy: Remove AutoLogger file and Restrict Directory
Write-Host "Removing AutoLogger File and Restrict Directory..." -ForegroundColor "Yellow"
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
	Remove-Item -Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

# Privacy: Disable Application launch tracking: Enable: 1, Disable: 0
Write-Host "Disabling Application launch tracking..." -ForegroundColor "Yellow"
Set-ItemProperty "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start-TrackProgs" 0

# Privacy: Disable Diagnostics Tracking Service
Write-Host "Disabling Diagnostics Tracking Service..." -ForegroundColor "Yellow"
Stop-Service "DiagTrack" -WarningAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled

# Privacy: Stop and disable WAP Push Service
Write-Host "Stop and Disable WAP Push Service..." -ForegroundColor "Yellow"
Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
Set-Service "dmwappushservice" -StartupType Disabled

#############################################
# Security Settings
#############################################

Write-Host "Configuring Security..." -ForegroundColor "Yellow"

# Security: Set the current network as Private
Write-Host "Setting Current Network as Private..." -ForegroundColor "Yellow"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# Security: Disable Remote Assistance
Write-Host "Disabling Remote Assistance..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

# Security: Disable Remote Desktop
Write-Host "Disabling Remote Desktop..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1

# Security: Disable SMBv1
Write-Host "Disabling SMBv1..." -ForegroundColor "Yellow"
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol

# Security: Restrict Windows P2P downloads to local network
Write-Host "Restricting Windows P2P downloads..." -ForegroundColor "Yellow"
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3

# Security: Don't let apps share and sync with non-explicitly-paired wireless devices over uPnP: Allow, Deny
Write-Host "Restricting Share & Sync Over uPnP..." -ForegroundColor "Yellow"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"

# Security: Disable Windows Update Automatic Restart
Write-Host "Disabling Windows Update Automatic Restart..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0

# Security: Disable Windows Update "Schedule Restart" Notifications
Write-Host "Disabling Windows Update Schedule Restart Notifications"
If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings")) {
	New-Item -Path HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Force | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 0
If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings")) {
	New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Force | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name UxOption -Type DWord -Value 0

#############################################
# Startup
#############################################

# Work in progress...
# Write-Host "Configuring Startup Settings..." -ForegroundColor "Yellow"

# You need to navigate to:
# HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run

# You'll see a list of apps that run on startup for the current user
# Delete the DWORD for each app you want to remove from startup

# Also check:
# HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run.

# You'll obviously need to repeat or something as settings are user specific

#############################################
# Lock Screen
#############################################

Write-Host "Configuring Lock Screen..." -ForegroundColor "Yellow"

## Lock Screen: Enable Custom Background on the Login / Lock Screen
## Background file: C:\someDirectory\someImage.jpg
## File Size Limit: 256Kb
# Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Personalization" "LockScreenImage" "C:\someDirectory\someImage.jpg"

# Lock Screen: Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
# If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
#	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
# }
# Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1

# Lock Screen: Lock screen (not sleep) on lid close
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name AwayModeEnabled -Type DWord -Value 1

# Lock Screen: Disable Lock screen Spotlight - New backgrounds, tips, advertisements etc.
Write-Host "Disabling Lock Screen Spotlight..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenOverlayEnabled" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0

#############################################
# Start Menu
#############################################

Write-Host "Configuring Start Menu..." -ForegroundColor "Yellow"

# Start Menu: Disable Fast Startup
Write-Host "Disabling Fast Startup..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0

# Start Menu: Disable Web Search in Start Menu
Write-Host "Disabling Web Search in Start Menu..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1

# Start Menu: Disable Cortana in Start Menu
Write-Host "Disabling Cortana in Start Menu..." -ForegroundColor "Yellow"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0

#############################################
# Taskbar
#############################################

Write-Host "Configuring Taskbar..." -ForegroundColor "Yellow"

# Taskbar: Taskbar small, dock to bottom, always on
Write-Host "Setting taskbar small, dock to bottom, always on..." -ForegroundColor "Yellow"
Set-BoxstarterTaskbarOptions -Size Small -Dock Bottom -Combine Full -AlwaysShowIconsOn

# Taskbar: Dock the taskbar to the left side of the screen
Write-Output "Docking the taskbar to the left side of the screen..."
    if (Test-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2') {
        $CurrPath = 'StuckRects2'
    }
    elseif (Test-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3') {
        $CurrPath = 'StuckRects3'
    }
    else {
        Write-Warning 'Unable to set the taskbar setting'
        return
    }
    $BasePath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'
    $RegPath = Join-Path $BasePath $CurrPath

    try {
        $CurrSettings = (Get-ItemProperty $RegPath).Settings
        $CurrSettings[12] = 3
        Set-ItemProperty -Path $BasePath -Name $CurrPath -Value $CurrSettings -Type Binary
    }
    catch {
        Write-Warning "Unable to pull the current registry settings!"
    }

# Taskbar: Show taskbar on multiple displays: Show: 1, Hide: 0
Write-Host "Setting Taskbar Is On Main Display Only..." -ForegroundColor "Yellow"
Set-ItemProperty -Path HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarEnabled -Value 0

# Taskbar: Taskbar settings when taskbar is on all displays
# Options:
# Show taskbar buttons on all taskbars: 0
# Show taskbar buttons on main taskbar and taskbar where window is open: 1
# Show taskbar buttons on taskbar where window is open: 2
# Write-Host "Setting Multi-Monitor Taskbar Mode..." -ForegroundColor "Yellow"
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

## AndyA: I use widgets and search
# Taskbar: Hide the Search, Task, Widget, and Chat buttons: Show: 1, Hide: 0
Write-Host "Hiding Chat Button..." -ForegroundColor "Yellow"
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 1  # Search
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 1 # Task
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 1 # Widgets
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0 # Chat

# Taskbar: Hide cortana: Hide: 0, Show: 1
Write-Host "Hiding Cortana..." -ForegroundColor "Yellow"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0

# Duplicate - See Above
# Taskbar: Show TaskView: Hide: 0, Show: 1
# Write-Host "Don't Hide Taskview..." -ForegroundColor "Yellow"
# Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 1

# Taskbar: Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
Write-Host "Show Colors On Taskbar, Start, & SysTray..." -ForegroundColor "Yellow"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 1

# Titlebar: Disable theme colors on titlebar: Enable: 1, Disable: 0
Write-Host "Show Theme Colors On Titlebar..." -ForegroundColor "Yellow"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\DWM" "ColorPrevalence" 1

# Taskbar: Use the Windows 7-8.1 Style Volume Mixer
Write-Host "Configuring Taskbar..." -ForegroundColor "Yellow"
If (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name MTCUVC | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name EnableMtcUvc -Type DWord -Value 0

# Taskbar: Disable Xbox Gamebar
Write-Host "Configuring Taskbar..." -ForegroundColor "Yellow"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Type DWord -Value 0

# Taskbar: Turn off People in Taskbar
Write-Host "Configuring Taskbar..." -ForegroundColor "Yellow"
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
	New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0

#############################
# Explorer
#############################

Write-Host "Configuring Explorer..." -ForegroundColor "Yellow"

# Prerequisite: Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: Show file extensions by default: Hide: 1, Show: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: Show path in title bar: Hide: 0, Show: 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 0

# Explorer: Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0

# Explorer: Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0

# Explorer: Expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1

# Explorer: Adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1

# Explorer: Set Explorer view to This PC
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

# Explorer: Hide Music icon in This PC
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recurse -ErrorAction SilentlyContinue

# Explorer: Hide Videos from This PC
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse -ErrorAction SilentlyContinue

# Explorer: Hide 3D Objects from This PC
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

# Explorer: Disable Recycle Bin Delete Confirmation Dialog: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 1

# Explorer: Show File Operation details
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1

#############################################
# Clean Up
#############################################
