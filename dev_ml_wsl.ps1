# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning using Windows and Linux native tools

Disable-UAC

# see if we can't get calling URL somehow, that would eliminate this need
# should move to a config file
$user = "Microsoft";
$baseBranch = "MLSamples";
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
executeScript "VirtualizationTools.ps1";
executeScript "GetMLPythonSamplesOffGithub.ps1";

# TODO: now install additional ML tools inside the WSL distro once default user w/blank password is working

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
