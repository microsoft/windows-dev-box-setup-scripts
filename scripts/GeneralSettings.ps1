
#############################
# General Settings
#############################

Write-Host "Configuring General Settings..." -ForegroundColor "Yellow"

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
Write-Host "Removing Edge browser shortcut from desktop..."
If (!(Test-Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate")) {
	New-Item -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" | Out-Null
}
Set-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "CreateDesktopShortcutDefault" -Type DWord -Value 0

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

## AndyA: I use these
# Remove Default Printers
# Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction:SilentlyContinue
# Remove-Printer -Name "Microsoft Print to PDF" -ErrorAction:SilentlyContinue
# Remove-Printer -Name "Fax" -ErrorAction:SilentlyContinue
# 
# Set-Checkpoint -CheckpointName $checkpoint -CheckpointValue 1
# 
# }
# 
# function Remove-SystemBloat {
# $checkpoint = 'SystemBloat'
# $done = Get-Checkpoint -CheckpointName $checkpoint
# 
# if ($done) {
# 	Write-BoxstarterMessage "$checkpoint is already removed"
# 	return
# }
