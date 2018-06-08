# Description: Boxstarter Script  
# Author: Microsoft
# Common dev settings for desktop app development

Disable-UAC

invoke-expression -Command https://raw.githubusercontent.com/crutkas/windows-dev-box-setup-scripts/master/helper_WindowsExplorerSettings.ps1

#--- VS 2017 uwp and azure workloads + git tools ---
# See this for install args: https://chocolatey.org/packages/VisualStudio2017Community
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community 
# https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio#list-of-workload-ids-and-component-ids
#choco install visualstudio2017community --package-parameters "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Component.Git"
RefreshEnv

#choco install visualstudio2017-workload-universal

#--- grabbing latest UWP Samples off Github ---
#RefreshEnv
#cd $env:USERPROFILE\desktop
#mkdir UwpSamples
#cd UwpSamples
#git clone https://github.com/Microsoft/Windows-universal-samples/

# installing Windows Template Studio VSIX
#choco was claiming dev 15 can't do this anymore for vsix... odd hasn't been fixed yet
#Install-ChocolateyVsixPackage -PackageName "Windows Template Studio" -VsixUrl $wtsFileUrl.source


#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
