# Description: Boxstarter Script  
# Author: Microsoft
# Common dev settings for desktop app development

Disable-UAC

#--- Windows Subsystems/Features ---
#choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
#choco install -y Microsoft-Hyper-V-All -source windowsFeatures
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V 
#choco install -y sysinternals
#choco install -y docker-for-windows

# should move to a config file
$user = "Microsoft";
$baseBranch = "BreakUpScripts";
$finalBaseHelperUri = "https://raw.githubusercontent.com/$user/windows-dev-box-setup-scripts/$baseBranch/scripts";

#Setting up Windows
executeScript("FileExplorerSettings.ps1");
executeScript("RemoveDefaultApps.ps1");

#--- Tools ---
#--- VS 2017 uwp and azure workloads + git tools ---
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community 
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
choco install visualstudio2017community --package-parameters "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Component.Git"
RefreshEnv #refreshing env due to Git install

#--- UWP Workload and installing Windows Template Studio
choco install visualstudio2017-workload-universal
executeScript("WindowsTemplateStudio.ps1");
executeScript("GetUwpSamplesOffGithub.ps1");

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

function executeScript {
	Param ([string]$script)
	iex ((new-object net.webclient).DownloadString("$finalBaseHelperUri/$script"))
}