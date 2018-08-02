# Description: Boxstarter Script  
# Author: Microsoft
# Common dev settings for desktop app development

Disable-UAC

# see if we can't get calling URL somehow, that would eliminate this need
# should move to a config file
$user = "Microsoft";
$baseBranch = "master";
$finalBaseHelperUri = "https://raw.githubusercontent.com/$user/windows-dev-box-setup-scripts/$baseBranch/scripts";

function executeScript {
	Param ([string]$script)
    write-host "executing $finalBaseHelperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$finalBaseHelperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";

#--- Tools ---
#--- Installing VS and VS Code with Git 
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community 
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
# visualstudio2017community 
# visualstudio2017professional
# visualstudio2017enterprise

choco install visualstudio2017community -y --package-parameters "--add Microsoft.VisualStudio.Component.Git" 
RefreshEnv #refreshing env due to Git install

#--- UWP Workload and installing Windows Template Studio ---
choco install -y visualstudio2017-workload-azure
choco install -y visualstudio2017-workload-universal
executeScript "WindowsTemplateStudio.ps1";
executeScript "GetUwpSamplesOffGithub.ps1";

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula