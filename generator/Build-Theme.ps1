# Builds one-dark-pro-ssms.pkgdef for SSMS 22: the original Visual Studio theme plus the color
# categories only the new shell uses, copied from the Dark theme with neutral grays swapped
# for One Dark tones. Run it again after updating SSMS (it may ship new colors), then Install.ps1.
param(
    [string]$OriginalPkgdef = "$PSScriptRoot\..\original\OneDark-Pro.vs.pkgdef",
    [string]$SsmsIde,
    [string]$Output = "$PSScriptRoot\..\one-dark-pro-ssms.pkgdef"
)

. "$PSScriptRoot\ThemeTool.ps1"
. "$PSScriptRoot\..\Ssms.ps1"

if (-not $SsmsIde) { $SsmsIde = Find-SsmsIde }
$Output = [IO.Path]::GetFullPath($Output)

$oneDarkTheme = 'd57274d6-b91f-4f3f-ace7-114e38ffd234'   # original theme from the VS extension
$darkTheme    = '1ded0138-47ce-435e-84ef-9ec1f439b749'   # built-in Dark theme (fallback)

# The port has its own identity so it never collides with the original extension
$ssmsTheme     = 'dbc802a0-5b08-4884-94f5-0754b3d891a8'
$ssmsThemeName = 'One Dark Pro (SSMS)'

function Rgba([string]$hex) {
    $hex = $hex.TrimStart('#'); if ($hex.Length -eq 6) { $hex += 'FF' }
    return [byte[]](0..3 | ForEach-Object { [Convert]::ToByte($hex.Substring($_ * 2, 2), 16) })
}

# Dark gray → matching One Dark tone (keeps the same light/dark hierarchy)
function Convert-NeutralToOneDark([byte[]]$c) {
    if (-not $c) { return $c }
    $max = ($c[0..2] | Measure-Object -Maximum).Maximum
    $min = ($c[0..2] | Measure-Object -Minimum).Minimum
    if ($max - $min -gt 10) { return Convert-AccentToOneDark $c }
    $v = [int](($c[0] + $c[1] + $c[2]) / 3)
    if ($v -lt 0x0A -or $v -gt 0x5F) { return $c }
    $target =
        if     ($v -le 0x17) { '21252B' }
        elseif ($v -le 0x2A) { '282C34' }
        elseif ($v -le 0x31) { '2C313A' }
        elseif ($v -le 0x3A) { '353B45' }
        elseif ($v -le 0x48) { '3E4452' }
        elseif ($v -le 0x55) { '4B5263' }
        else                 { '5C6370' }
    $mapped = Rgba $target
    $mapped[3] = $c[3]
    return $mapped
}

# VS 2026 purple accent → One Dark blue
function Convert-AccentToOneDark([byte[]]$c) {
    $accents = @{ '9184EE' = '61AFEF'; 'D2CCF8' = 'B6DAF8'; 'A79CF1' = '8CC4F3' }
    $rgb = '{0:X2}{1:X2}{2:X2}' -f $c[0], $c[1], $c[2]
    if (-not $accents.ContainsKey($rgb)) { return $c }
    $mapped = Rgba $accents[$rgb]
    $mapped[3] = $c[3]
    return $mapped
}

function Convert-ColorEntry($entry) {
    $bg = if ($entry.BgType -eq 1) { Convert-NeutralToOneDark $entry.Bg } else { $entry.Bg }
    $fg = if ($entry.FgType -eq 1) { Convert-NeutralToOneDark $entry.Fg } else { $entry.Fg }
    return [pscustomobject]@{ Name = $entry.Name; BgType = $entry.BgType; Bg = $bg; FgType = $entry.FgType; Fg = $fg }
}

# Fine-tuning by color name (applies to any category)
$overrides = @{
    'SQL String'           = @{ Fg = '98C379' }
    'SQL System Function'  = @{ Fg = '61AFEF' }
    'SQL Stored Procedure' = @{ Fg = '61AFEF' }
    'SQL System Table'     = @{ Fg = 'E5C07B' }
    'SQL Operator'         = @{ Fg = '56B6C2' }
    'StatusBarBackgroundFillRest' = @{ Bg = '282C34' }
    'EnvironmentBorder'           = @{ Bg = '3E4452' }
}

function Set-Override($entry) {
    if (-not $overrides.ContainsKey($entry.Name)) { return }
    $o = $overrides[$entry.Name]
    if ($o.Fg) { $entry.FgType = 1; $entry.Fg = Rgba $o.Fg }
    if ($o.Bg) { $entry.BgType = 1; $entry.Bg = Rgba $o.Bg }
}

# --- Read --------------------------------------------------------------------------------

$oneDark = Read-ThemePkgdef $OriginalPkgdef | Where-Object Theme -eq $oneDarkTheme

$dark = foreach ($file in Get-ChildItem $SsmsIde -Recurse -Filter *.pkgdef) {
    if (-not (Select-String -LiteralPath $file.FullName -Pattern $darkTheme -Quiet)) { continue }
    Read-ThemePkgdef $file.FullName | Where-Object Theme -eq $darkTheme
}

$darkByCategory = $dark | Group-Object { $_.Category.ToString() } -AsHashTable -AsString

# --- Merge -------------------------------------------------------------------------------

$sections = [ordered]@{}
foreach ($cat in $oneDark) {
    if (-not $sections.Contains($cat.Key)) { $sections[$cat.Key] = [System.Collections.Generic.List[object]]::new() }
    $sections[$cat.Key].Add($cat)
}

$added = 0
foreach ($cat in $oneDark) {
    $darkCats = $darkByCategory[$cat.Category.ToString()]
    if (-not $darkCats) { continue }
    $existing = [System.Collections.Generic.HashSet[string]]::new([string[]]$cat.Colors.Name)
    foreach ($entry in ($darkCats | ForEach-Object { $_.Colors })) {
        if (-not $existing.Add($entry.Name)) { continue }
        $cat.Colors.Add((Convert-ColorEntry $entry)); $added++
    }
}

$oneDarkCategories = [System.Collections.Generic.HashSet[string]]::new([string[]]($oneDark | ForEach-Object { $_.Category.ToString() }))
$newCategories = 0
foreach ($group in ($dark | Group-Object { $_.Category.ToString() } | Sort-Object Name)) {
    if ($oneDarkCategories.Contains($group.Name)) { continue }
    $colors = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($entry in ($group.Group | ForEach-Object { $_.Colors })) {
        if ($seen.Add($entry.Name)) { $colors.Add((Convert-ColorEntry $entry)) }
    }
    $key = $group.Group[0].Key
    while ($sections.Contains($key)) { $key += '_SSMS' }
    $sections[$key] = [System.Collections.Generic.List[object]]::new()
    $sections[$key].Add([pscustomobject]@{ Category = [guid]$group.Name; Colors = $colors })
    $newCategories++
}

foreach ($list in $sections.Values) { foreach ($cat in $list) { foreach ($entry in $cat.Colors) { Set-Override $entry } } }

# --- Write -------------------------------------------------------------------------------

$out = [Text.StringBuilder]::new()
[void]$out.AppendLine("[`$RootKey`$\Themes\{$ssmsTheme}]")
[void]$out.AppendLine("@=`"$ssmsThemeName`"")
[void]$out.AppendLine("`"Name`"=`"$ssmsThemeName`"")
[void]$out.AppendLine("`"FallbackId`"=`"{$darkTheme}`"")
foreach ($key in $sections.Keys) {
    $blob = ConvertTo-ThemeBlob $sections[$key]
    [void]$out.AppendLine()
    [void]$out.AppendLine("[`$RootKey`$\Themes\{$ssmsTheme}\$key]")
    [void]$out.AppendLine("`"Data`"=hex:" + (Format-HexValue $blob))
}
[IO.File]::WriteAllText($Output, $out.ToString(), [Text.Encoding]::ASCII)

"Colors added to existing categories: $added"
"New categories: $newCategories"
"Sections written: $($sections.Count)"
