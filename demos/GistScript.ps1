
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
(Get-WmiObject Win32_ComputerSystem).Rename("CHOZO") | Out-Null

# General: Enable Developer Mode: Enable: 1, Disable: 0
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 0

# General: Bash on Windows
# Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

# General: Disable Sticky Keys
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"

# General: Enable NumLock After Startup
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
#Error: Doesn't work
#If (!(Test-Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate")) {
	New-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" | Out-Null
}
#Set-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "CreateDesktopShortcutDefault" -Type DWord -Value 0

# General: Windows should never ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# General: Disable Autoplay
Write-Host "Disabling Autoplay..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

# General: Disable Shared Experiences
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" -Name "RomeSdkChannelUserAuthzPolicy" -Type DWord -Value 0

# General: Show Task Manager Details
#Error: This just hangs; there's a sleep timer but I'm impatient
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager")) {
	New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Force | Out-Null
}
$preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
If (!($preferences)) {
	$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
	While (!($preferences)) {
		Start-Sleep -m 250
		$preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
	}
	Stop-Process $taskmgr
}
$preferences.Preferences[28] = 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences

# General: Disable OneDrive
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1

# General: Disable Cortana
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
# Error: Couldn't find this task
# Write-Host "Disabling Telemetry..."
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
# #Error: Couldn't find this task
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
# Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
# Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

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
Write-Host "Speech, Inking, & Typing..." -ForegroundColor "Yellow"
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
Write-Host "Stop and disable WAP Push Service..." -ForegroundColor "Yellow"
Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
Set-Service "dmwappushservice" -StartupType Disabled

#############################################
# Clean Up
#############################################
