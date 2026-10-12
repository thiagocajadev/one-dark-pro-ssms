# Helpers shared by the install and uninstall scripts

$ThemeFolderName = 'one-dark-pro-ssms'

function Find-SsmsIde {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vswhere)) { throw 'vswhere.exe not found: is SSMS 22 installed?' }

    # The parentheses make Windows PowerShell 5.1 enumerate the list (otherwise it is a single array)
    $installs = (& $vswhere -all -prerelease -products * -format json) -join "`n"
    $ssms = (ConvertFrom-Json $installs) |
        Where-Object displayName -like 'SQL Server Management Studio*' |
        Sort-Object installationVersion -Descending |
        Select-Object -First 1

    if (-not $ssms) { throw 'SSMS not found by vswhere.' }
    return Join-Path $ssms.installationPath 'Common7\IDE'
}

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    return ([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restart-AsAdministrator([string]$script) {
    $shell = (Get-Process -Id $PID).Path
    Start-Process $shell -Verb RunAs -Wait -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$script`""
}

# Tells SSMS the extensions changed: on next launch it reloads the .pkgdef files
function Update-SsmsConfiguration([string]$extensionsFolder) {
    (Get-Item (Join-Path $extensionsFolder 'extensions.configurationchanged')).LastWriteTime = Get-Date
}

function Test-SsmsRunning {
    return [bool](Get-Process SSMS -ErrorAction SilentlyContinue)
}

# Early installs used another folder name and theme GUID: it would show up twice in the theme list
function Remove-LegacyInstall([string]$extensionsFolder) {
    $legacyFolder = Join-Path $extensionsFolder 'OneDarkPro'
    if (-not (Test-Path $legacyFolder)) { return }
    Remove-Item $legacyFolder -Recurse -Force
}
