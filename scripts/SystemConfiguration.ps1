#--- Enable developer mode on the system ---
# (if on Windows 8 / Server 2012 or later)
if([Environment]::OSVersion.Version -ge (New-Object 'Version' 6,2)) {
  Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1
}