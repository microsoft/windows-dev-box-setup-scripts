# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning using Windows and Linux native tools

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$Boxstarter | Foreach-Object { write-host "The key name is $_.Key and value is $_.Value"  }

$helperUri = $Boxstarter['ScriptToCall']
write-host "ScriptToCall is $helperUri"

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
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "VirtualizationTools.ps1";
executeScript "GetMLPythonSamplesOffGithub.ps1";

# TODO: now install additional ML tools inside the WSL distro once default user w/blank password is working
write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt update
Ubuntu1804 run apt upgrade -y
Ubuntu1804 run apt install python3 python-pip -y 
Ubuntu1804 run apt install python-numpy python-scipy pandas -y
Ubuntu1804 run pip install -U scikit-learn
write-host "Finished installing tools inside the WSL distro"

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
