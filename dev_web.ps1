# Description: Boxstarter Script
# Author: Microsoft
# Common settings for web dev

Disable-UAC

function executeScript {
    Param ([string]$script)
    write-host "executing $finalBaseHelperUri/$script ..."
    iex ((new-object net.webclient).DownloadString("$finalBaseHelperUri/$script"))
}

# see if we can't get calling URL somehow, that would eliminate this need
# should move to a config file
$user = "Microsoft";
$baseBranch = "master";
$finalBaseHelperUri = "https://raw.githubusercontent.com/$user/windows-dev-box-setup-scripts/$baseBranch/scripts";

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "CommonDevTools.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "VirtualizationTools.ps1";

#--- Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Browsers ---
choco install -y googlechrome
choco install -y firefox

#--- Microsoft WebDriver ---
choco install -y microsoftwebdriver

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
