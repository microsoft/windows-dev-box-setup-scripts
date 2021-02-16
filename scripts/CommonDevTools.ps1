# work around a boxstarter bug creating nested temp dirs: https://github.com/chocolatey/boxstarter/issues/442
$boxstarterTempDir = 'C:\temp'
mkdir $boxstarterTempDir -Force

# tools we expect devs across many scenarios will want
choco install --cacheLocation=$boxStarterTempDir -y vscode
choco install --cacheLocation=$boxStarterTempDir -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install --cacheLocation=$boxStarterTempDir -y python
choco install --cacheLocation=$boxStarterTempDir -y 7zip.install
choco install --cacheLocation=$boxStarterTempDir -y sysinternals
