# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning

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

#--- Windows Subsystems/Features ---
choco install -y Microsoft-Hyper-V-All -source windowsFeatures
choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures

#--- Ubuntu ---
# Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile ~/Ubuntu.appx -UseBasicParsing
# Add-AppxPackage -Path ~/Ubuntu.appx

#--- Fonts ---
choco install -y inconsolata
# choco install -y ubuntu.font

#--- Tools ---
choco install -y docker-for-windows
choco install -y python
choco install -y pip
choco install -y 7zip.install

# TODO: install additional ML tools

#--- VS Code ---
choco install -y visualstudiocode

#--- VS Code extensions ---
choco install -y vscode-docker

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
