# Helper functions for compatibility checks

# Returns $true if running a 64-bit OS.
# TODO: checks for non-x86-based architectures, eg. ARM64
function Is-64Bit
{
  return [Environment]::Is64BitOperatingSystem
}

# Returns $true if running on a server edition of Windows.
function Is-Server
{
  return ((Get-WmiObject Win32_OperatingSystem).ProductType -gt 1)
}

# Returns $true if system has hardware virtualization enabled.
function Is-Virtualization-Capable
{
  return (Get-WmiObject Win32_Processor).VirtualizationFirmwareEnabled
}

# Returns $true if system should be capable of Hyper-V virtualization.
function Is-HyperV-Capable
{
  # Ensure we're running on a 64-bit operating system
  if(-Not (Is-64Bit)) {
    return $false
  }

  # Ensure hardware virtualization is available and enabled
  if(-Not (Is-Virtualization-Capable)) {
    return $false
  }

  # Ensure product SKU supports Hyper-V
  # Source for SKU IDs: https://docs.microsoft.com/en-gb/windows/desktop/api/sysinfoapi/nf-sysinfoapi-getproductinfo
  if((Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU -NotIn 0x06, 0x10, 0x12, 0x50, 0x8, 0xC, 0x79, 0x7A, 0x04, 0x46, 0x48, 0x1B, 0x54, 0x7D, 0x81, 0x7E, 0x82, 0x0A, 0x0E, 0x2A, 0xA1, 0xA2, 0x30, 0x45, 0x31, 0x67, 0x18, 0x4F, 0x07, 0x0D, 0x01, 0x47, 0x1C)
  {
    return $false
  }

  $BuildVersion = [System.Environment]::OSVersion.Version

  # Ensure that we're not running on XP
  if($BuildVersion.Major -lt '6')
  {
    return $false
  }

  # Windows Server 2008/R2 and variants
  if($BuildVersion.Major -eq '6' -and $BuildVersion.Minor -lt '2')
  {
    # Ensure we aren't running on a client edition
    if(-Not (Is-Server)) {
      return $false
    }
    
    return $true
  }

  # Windows 8/8.1 and Windows Server 2012/R2
  if($BuildVersion.Major -ge '6' -and $BuildVersion.Minor -ge '2')
  {
    # Client Hyper-V requires SLAT
    if(-Not (Is-Server)) {
      return (Get-WmiObject Win32_Processor).SecondLevelAddressTranslationExtensions
    }

    return $true
  }

  # Windows 10 / Windows Server 2016 and later
  if($BuildVersion.Major -ge '10')
  {
    # Ensure SLAT is supported
    return (Get-WmiObject Win32_Processor).SecondLevelAddressTranslationExtensions
  }
}