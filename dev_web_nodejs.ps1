# Description: Boxstarter Script
# Author: Microsoft
# Common settings for web development with NodeJS

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
executeScript "VirtualizationTools.ps1";

#--- Browsers ---
choco install -y Firefox
choco install -y Googlechrome

#--- Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Tools ---
choco install -y nodejs-lts # Node.js LTS, Recommended for most users
# choco install -y nodejs # Node.js Current, Latest features
choco install -y visualstudio2017buildtools
choco install -y visualstudio2017-workload-vctools
choco install -y python2 # Node.js requires Python 2 to build native modules

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
