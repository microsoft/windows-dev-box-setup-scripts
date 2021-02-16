# Description: Boxstarter Script
# Author: mattnewport
# Common dev settings for Osso programmer machines

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

# work around a boxstarter bug creating nested temp dirs: https://github.com/chocolatey/boxstarter/issues/442
$boxstarterTempDir = 'C:\temp'
mkdir $boxstarterTempDir -Force

choco install --cacheLocation=$boxStarterTempDir -y visualstudio2019professional
Update-SessionEnvironment #refreshing env due to Git install

choco install --cacheLocation=$boxStarterTempDir -y visualstudio2019-workload-manageddesktop
choco install --cacheLocation=$boxStarterTempDir -y visualstudio2019-workload-azure
choco install --cacheLocation=$boxStarterTempDir -y visualstudio2019-workload-netcoretools
choco install --cacheLocation=$boxStarterTempDir -y visualstudio2019-workload-managedgame

choco install --cacheLocation=$boxStarterTempDir -y dotnet-5.0-sdk

choco install --cacheLocation=$boxStarterTempDir -y unity-hub

choco install --cacheLocation=$boxStarterTempDir -y everything

choco install --cacheLocation=$boxStarterTempDir -y github-desktop
choco install --cacheLocation=$boxStarterTempDir -y gh

choco install --cacheLocation=$boxStarterTempDir -y sourcetree

choco install --cacheLocation=$boxStarterTempDir -y kdiff3

choco install --cacheLocation=$boxStarterTempDir -y notepadplusplus

choco install --cacheLocation=$boxStarterTempDir -y dropbox

choco install --cacheLocation=$boxStarterTempDir -y zoom

choco install --cacheLocation=$boxStarterTempDir -y slack

choco install --cacheLocation=$boxStarterTempDir -y sidequest

choco install --cacheLocation=$boxStarterTempDir -y yubico-authenticator

choco install --cacheLocation=$boxStarterTempDir -y windirstat

choco install --cacheLocation=$boxStarterTempDir -y audacity

choco install --cacheLocation=$boxStarterTempDir -y obs-studio

choco install --cacheLocation=$boxStarterTempDir -y adobereader

choco install --cacheLocation=$boxStarterTempDir -y vlc

choco install --cacheLocation=$boxStarterTempDir -y jetbrains-rider

choco install --cacheLocation=$boxStarterTempDir -y sqlitebrowser

choco install --cacheLocation=$boxStarterTempDir -y sqlite.shell

choco install --cacheLocation=$boxStarterTempDir -y microsoft-windows-terminal

executeScript "HyperV.ps1";
RefreshEnv
executeScript "WSL.ps1";
RefreshEnv
executeScript "Docker.ps1";

choco install --cacheLocation=$boxStarterTempDir -y powershell-core
choco install --cacheLocation=$boxStarterTempDir -y azure-cli
# This seems to hang for some reason, commenting out
# Install-Module -Force Az
choco install --cacheLocation=$boxStarterTempDir -y microsoftazurestorageexplorer

# enable long filenames for git
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -Value 1
git config --system core.longpaths true

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
