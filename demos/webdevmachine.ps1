# Description: Boxstarter Script
# Author: Microsoft
# chocolatey fest demo

Disable-UAC
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
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "CommonDevTools.ps1";
executeScript "Browsers.ps1";

executeScript "HyperV.ps1";
RefreshEnv
executeScript "WSL.ps1";
RefreshEnv
executeScript "Docker.ps1";

choco install -y powershell-core
choco install -y azure-cli
Install-Module -Force Az
Install-Module -Force posh-git
choco install -y microsoftazurestorageexplorer
choco install -y terraform

# Get NodeJS
choco install -y nodejs.install
RefreshEnv

# Install tools in WSL instance
write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt install ansible -y

## Install NodeJS
# Ubuntu1804 run curl -sL https://deb.nodesource.com/setup_8.x | bash -
Ubuntu1804 run apt-get install -y nodejs

## Get a NodeJS Demo
mkdir C:\github
cd C:\github
git.exe clone https://github.com/gtsopour/nodejs-shopping-cart.git
cd C:\github\nodejs-shopping-cart
npm install

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
