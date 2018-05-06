# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for web development

Disable-UAC

#--- Windows Features ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

#--- Git ---
choco install -y git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"'
choco install -y Git-Credential-Manager-for-Windows

#--- Windows Subsystems/Features ---
choco install -y Microsoft-Hyper-V-All -source windowsFeatures
choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures

#--- Ubuntu ---
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

#--- Fonts ---
choco install -y inconsolata
choco install -y ubuntu.font

#--- Tools ---
choco install -y docker-for-windows
choco install -y python
choco install -y pip
choco install -y 7zip.install

#--- VS Code ---
choco install -y visualstudiocode

#--- VS Code extensions ---
choco install -y vscode-docker

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula














•	Python 3.x with the deep learning frameworks installed + matplotlib, numpy)
•	VS Code with Python and a few other things.
•	Linux Subsystem for Windows
o	With Python 3.x installed (and the same packages)
o	With Git, ssh, grep and other “classic” tools installed
•	Although I don’t use this yet, for Philly, I have Docker installed.

