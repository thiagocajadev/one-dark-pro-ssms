# Installs the One Dark Pro (SSMS) theme into SSMS 22 (asks for administrator rights)

. "$PSScriptRoot\Ssms.ps1"

if (-not (Test-Administrator)) {
    Restart-AsAdministrator $PSCommandPath
    return
}

$theme = Join-Path $PSScriptRoot '..\one-dark-pro-ssms.pkgdef'
$extensionsFolder = Join-Path (Find-SsmsIde) 'Extensions'
$themeFolder = Join-Path $extensionsFolder $ThemeFolderName

Remove-LegacyInstall $extensionsFolder
New-Item -ItemType Directory -Force $themeFolder | Out-Null
Copy-Item $theme $themeFolder -Force
Update-SsmsConfiguration $extensionsFolder

Write-Host "Theme installed to $themeFolder"
if (Test-SsmsRunning) { Write-Host 'Restart SSMS to load the theme.' }
Write-Host 'In SSMS: Tools > Options > Environment > Visual Experience > One Dark Pro (SSMS)'
Read-Host 'Press Enter to close'
