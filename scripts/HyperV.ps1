# Install Hyper-V
if(Is-HyperV-Capable) {
  choco install -y Microsoft-Hyper-V-All --source="'windowsFeatures'"
}