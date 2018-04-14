# Description: Boxstarter Script  
# Author: Microsoft
# Common dev settings

Disable-UAC

#--- Windows Features ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

#--- Tools ---
choco install visualstudiocode -y
choco install git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"' -y
choco install Git-Credential-Manager-for-Windows
choco install 7zip.install

#--- Windows Subsystems/Features ---
choco install Microsoft-Hyper-V-All -source windowsFeatures
choco install Microsoft-Windows-Subsystem-Linux -source windowsfeatures

#--- Browsers ---
choco install googlechrome -y
choco install firefox -y

#--- Fonts ---
choco install inconsolata -y
choco install ubuntu.font -y

#--- Tools ---
choco install sysinternals -y
choco install docker-for-windows
choco install python
choco install pip
choco install easy.install

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
