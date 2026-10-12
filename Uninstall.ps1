# Removes the One Dark Pro (SSMS) theme from SSMS 22 (asks for administrator rights)

. "$PSScriptRoot\Ssms.ps1"

if (-not (Test-Administrator)) {
    Restart-AsAdministrator $PSCommandPath
    return
}

$extensionsFolder = Join-Path (Find-SsmsIde) 'Extensions'
$themeFolder = Join-Path $extensionsFolder $ThemeFolderName

Remove-LegacyInstall $extensionsFolder

if (Test-Path $themeFolder) {
    Remove-Item $themeFolder -Recurse -Force
}

Update-SsmsConfiguration $extensionsFolder

Write-Host 'Theme removed. On next launch SSMS falls back to a built-in theme.'
Read-Host 'Press Enter to close'
