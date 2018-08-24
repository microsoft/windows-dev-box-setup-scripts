
write-host "Downloading Python ML samples to your desktop ..."

RefreshEnv
cd $env:USERPROFILE\desktop
git clone https://github.com/Microsoft/Dev-Advocacy-Samples/tree/master/python-mlclassification
