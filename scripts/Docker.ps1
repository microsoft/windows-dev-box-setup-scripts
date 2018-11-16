if(
  (Is-HyperV-Capable) -and
  # Windows 10 Anniversary Update or later
  ((Get-WmiObject Win32_OperatingSystem).BuildNumber -ge 14393)) {
  Enable-WindowsOptionalFeature -Online -FeatureName containers -All
  RefreshEnv
  choco install -y docker-for-windows
  choco install -y vscode-docker
}
