# Description: Boxstarter Script
# Author: Microsoft
# Common settings for azure devops

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "WSL.ps1";
executeScript "HyperV.ps1";
executeScript "Docker.ps1";
executeScript "Browsers.ps1";

choco install azure-cli 
choco install azurepowershell
choco install microsoftazurestorageexplorer
choco install terraform 

# Install tools in WSL instance
write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt install ansible -y

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
