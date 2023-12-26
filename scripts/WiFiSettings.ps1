
#############################
# WiFi Settings
#############################

Write-Host "Configuring WiFi..." -ForegroundColor "Yellow"

# Wifi: Disable HotSpot Reporting
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0

# Wifi: Disable AutoConnect
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0

# Wifi: Disable AutoConnectAllowedOEM
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Type Dword -Value 0

# Wifi: Disable WifiSense
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "WiFISenseAllowed" -Type Dword -Value 0
