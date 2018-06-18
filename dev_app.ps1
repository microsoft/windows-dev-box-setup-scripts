# Description: Boxstarter Script  
# Author: Microsoft
# Common dev settings for desktop app development

Disable-UAC

#--- Windows Subsystems/Features ---
#choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
#choco install -y Microsoft-Hyper-V-All -source windowsFeatures
#choco install -y sysinternals
#choco install -y docker-for-windows

#--- Configuring Windows properties ---
#--- Windows Features ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

#--- Enabling developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

#--- VS 2017 uwp and azure workloads + git tools ---
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community 
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
choco install visualstudio2017community --package-parameters "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Component.Git"
RefreshEnv

choco install visualstudio2017-workload-universal

#--- grabbing latest UWP Samples off Github ---
RefreshEnv
cd $env:USERPROFILE\desktop
mkdir UwpSamples
cd UwpSamples
git clone https://github.com/Microsoft/Windows-universal-samples/

# installing Windows Template Studio VSIX
#choco was claiming dev 15 can't do this anymore for vsix... odd hasn't been fixed yet
#Install-ChocolateyVsixPackage -PackageName "Windows Template Studio" -VsixUrl $wtsFileUrl.source

$requestUri = 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery'
$requestBody = '{"flags":"262","filters":[{"criteria":[{"filterType":"10","value":"windows template studio"}],"sortBy":"0","sortOrder":"2","pageSize":"25","pageNumber":"1"}]}'
$requestHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$requestHeaders.Add('Accept','application/json; api-version=3.2-preview.1')
$requestHeaders.Add('Content-Type','application/json; charset=utf-8')

$results = Invoke-WebRequest -Uri $requestUri -Method POST -Headers $requestHeaders -Body $requestBody -UseBasicParsing

$jsonResults = $results.Content | ConvertFrom-Json
$wtsResults = $jsonResults.results[0].extensions | where {$_.extensionName -eq "WindowsTemplateStudio"} 
$wtsFileUrl = $wtsResults.versions[0].files | where {$_.assetType -eq "Microsoft.Templates.2017.vsix"}

$wtsVsix = [System.IO.Path]::GetFileName($wtsFileUrl.source)
$wtsFullPath = [System.IO.Path]::Combine((Resolve-Path .\).Path, $wtsVsix);
Invoke-WebRequest -Uri $wtsFileUrl.source -OutFile $wtsVsix
$vsixInstallerFile = Get-Childitem -Include vsixinstaller.exe -Recurse -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\"
$wtsArgList = $wtsFullPath + " /q"

$vsixInstallerResult = Start-Process -FilePath $vsixInstallerFile.FullName -ArgumentList $wtsArgList -Wait -PassThru;

Remove-Item $wtsVsix


#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula