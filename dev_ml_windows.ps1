# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning using only Windows native tools

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
executeScript "GetMLIDEAndTooling.ps1";
executeScript "PythonMLTools.ps1";

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
