# Description: Boxstarter Script
# Author: mattnewport
# Common dev settings for Osso TeamCity Agent machines

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
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";

#--- Tools ---
#--- Installing VS and VS Code with Git
# See this for install args: https://chocolatey.org/packages/VisualStudio2019Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
# visualstudio2019community
# visualstudio2019professional
# visualstudio2019enterprise

choco install -y visualstudio2019professional
Update-SessionEnvironment #refreshing env due to Git install

choco install -y visualstudio2019-workload-manageddesktop
choco install -y visualstudio2019-workload-azure
choco install -y visualstudio2019-workload-netcoretools
choco install -y visualstudio2019-workload-managedgame

choco install -y dotnet-5.0-sdk

choco install -y unity-hub

choco install -y everything

choco install -y github-desktop
choco install -y gh

choco install -y kdiff3

choco install -y notepadplusplus

choco install -y windirstat

choco install microsoft-windows-terminal

executeScript "HyperV.ps1";
RefreshEnv
# executeScript "WSL.ps1";
choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
RefreshEnv
executeScript "Docker.ps1";

choco install -y powershell-core
choco install -y azure-cli
Install-Module -Force Az
choco install -y microsoftazurestorageexplorer

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
