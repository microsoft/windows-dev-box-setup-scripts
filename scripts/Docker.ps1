if(
  # 64-bit edition of Windows
  [Environment]::Is64BitOperatingSystem -and
  # Editions with Hyper-V
  # (See also: https://docs.microsoft.com/en-gb/windows/desktop/api/sysinfoapi/nf-sysinfoapi-getproductinfo)
  ((Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU -in 0x06, 0x10, 0x12, 0x50, 0x8, 0xC, 0x79, 0x7A, 0x04, 0x46, 0x48, 0x1B, 0x54, 0x7D, 0x81, 0x7E, 0x82, 0x0A, 0x0E, 0x2A, 0xA1, 0xA2, 0x30, 0x45, 0x31, 0x67, 0x18, 0x4F, 0x07, 0x0D, 0x01, 0x47, 0x1C) -and
  # Windows 10 Anniversary Update or later
  ((Get-WmiObject Win32_OperatingSystem).BuildNumber -ge 14393)) {
  Enable-WindowsOptionalFeature -Online -FeatureName containers -All
  RefreshEnv
  choco install -y docker-for-windows
  choco install -y vscode-docker
}
