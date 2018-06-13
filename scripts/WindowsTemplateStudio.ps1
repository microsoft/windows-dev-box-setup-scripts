# installing Windows Template Studio VSIX
$requestUri = "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"
$requestBody = '{"flags":"262","filters":[{"criteria":[{"filterType":"10","value":"windows template studio"}],"sortBy":"0","sortOrder":"2","pageSize":"25","pageNumber":"1"}]}'
$requestHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$requestHeaders.Add('Accept','application/json; api-version=3.2-preview.1')
$requestHeaders.Add('Content-Type','application/json; charset=utf-8')

$results = Invoke-WebRequest -Uri $requestUri -Method POST -Headers $requestHeaders -Body $requestBody -UseBasicParsing

$jsonResults = $results.Content | ConvertFrom-Json
$wtsResults = $jsonResults.results[0].extensions | where {$_.extensionName -eq "WindowsTemplateStudio"} 
$wtsFileUrl = $wtsResults.versions[0].files | where {$_.assetType -eq "Microsoft.Templates.2017.vsix"}

$wtsVsix = [System.IO.Path]::GetFileName($wtsFileUrl.source)
$desktopPath = Resolve-Path $env:USERPROFILE\desktop
$wtsFullPath = [System.IO.Path]::Combine($desktopPath, $wtsVsix);

Invoke-WebRequest -Uri $wtsFileUrl.source -OutFile $wtsVsix

$vsixInstallerFile = Get-Childitem -Include vsixinstaller.exe -Recurse -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\"
$wtsArgList = $wtsFullPath + " /q"

$vsixInstallerResult = Start-Process -FilePath $vsixInstallerFile.FullName -ArgumentList $wtsArgList -Wait -PassThru;

Remove-Item $wtsVsix
