# Description: Boxstarter Script: 1.0.0.2
# Author: Microsoft
# chocolatey fest demo

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

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$strpos = $helperUri.LastIndexOf("/demos/")
$helperUri = $helperUri.Substring(0, $strpos)
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "PrivacySettings.ps1";
executeScript "SecuritySettings.ps1";
executeScript "GeneralSettings.ps1";
executeScript "LockScreenSettings.ps1";
executeScript "StartMenuSettings.ps1";
executeScript "TaskbarSettings.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "WiFiSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
RefreshEnv
executeScript "BasicApplications.ps1";
RefreshEnv

## set desktop wallpaper
#Invoke-WebRequest -Uri 'http://chocolateyfest.com/wp-content/uploads/2018/05/img-bg-front-page-header-NO_logo-opt.jpg' -Method Get -ContentType image/jpeg -OutFile 'C:\github\chocofest.jpg'
#Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value 'C:\github\chocofest.jpg'
#rundll32.exe user32.dll, UpdatePerUserSystemParameters
#RefreshEnv

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
