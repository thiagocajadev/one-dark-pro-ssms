# Packages only what is needed to install the theme into dist/one-dark-pro-ssms.zip.
# The file name carries no version, so releases/latest/download/ stays a permanent link.

$root = Split-Path $PSScriptRoot -Parent
$dist = Join-Path $root 'dist'
$staging = Join-Path $dist 'one-dark-pro-ssms'
$zip = Join-Path $dist 'one-dark-pro-ssms.zip'

$files = @(
    'Install.cmd'
    'Uninstall.cmd'
    'one-dark-pro-ssms.pkgdef'
    'LICENSE'
    'README.md'
    'README.pt-BR.md'
    'scripts\Install.ps1'
    'scripts\Uninstall.ps1'
    'scripts\Ssms.ps1'
)

if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }

foreach ($file in $files) {
    $target = Join-Path $staging $file
    New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
    Copy-Item (Join-Path $root $file) $target
}

Compress-Archive -Path "$staging\*" -DestinationPath $zip
Remove-Item $staging -Recurse -Force

Write-Host "Release package: $zip"
