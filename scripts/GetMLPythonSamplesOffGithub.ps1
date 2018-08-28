
write-host "Downloading Python ML samples to your desktop ..."

Update-SessionEnvironment
cd $env:USERPROFILE\desktop
git clone https://github.com/Microsoft/Dev-Advocacy-Samples
