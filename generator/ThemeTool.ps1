# Reads and writes Visual Studio themes in .pkgdef files (binary color category format)

function Read-ThemePkgdef([string]$path) {
    $result = @()
    $lines = Get-Content -LiteralPath $path
    $section = $null
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        if ($line -match '^\[\$RootKey\$\\Themes\\\{([0-9a-fA-F-]+)\}\\(.+)\]$') {
            $section = [pscustomobject]@{ Theme = $Matches[1].ToLower(); Key = $Matches[2] }
            $i++; continue
        }
        if ($line -match '^\[') { $section = $null; $i++; continue }
        if ($section -and $line -match '^"Data"=hex:(.*)$') {
            $hex = $Matches[1]
            while ($hex.EndsWith('\')) { $hex = $hex.TrimEnd('\'); $i++; $hex += $lines[$i].Trim() }
            $bytes = [byte[]]($hex.Split(',') | Where-Object { $_ } | ForEach-Object { [Convert]::ToByte($_, 16) })
            foreach ($cat in (ConvertFrom-ThemeBlob $bytes)) {
                $result += [pscustomobject]@{ Theme = $section.Theme; Key = $section.Key; Category = $cat.Category; Colors = $cat.Colors }
            }
        }
        $i++
    }
    return $result
}

function ConvertFrom-ThemeBlob([byte[]]$b) {
    $pos = 8
    $catCount = [BitConverter]::ToInt32($b, $pos); $pos += 4
    $cats = @()
    for ($c = 0; $c -lt $catCount; $c++) {
        $guid = [guid]::new([byte[]]$b[$pos..($pos + 15)]); $pos += 16
        $count = [BitConverter]::ToInt32($b, $pos); $pos += 4
        $colors = [System.Collections.Generic.List[object]]::new()
        for ($k = 0; $k -lt $count; $k++) {
            $len = [BitConverter]::ToInt32($b, $pos); $pos += 4
            $name = [Text.Encoding]::ASCII.GetString($b, $pos, $len); $pos += $len
            $bgType = $b[$pos]; $pos++
            $bg = $null; if ($bgType -ne 0) { $bg = [byte[]]$b[$pos..($pos + 3)]; $pos += 4 }
            $fgType = $b[$pos]; $pos++
            $fg = $null; if ($fgType -ne 0) { $fg = [byte[]]$b[$pos..($pos + 3)]; $pos += 4 }
            $colors.Add([pscustomobject]@{ Name = $name; BgType = $bgType; Bg = $bg; FgType = $fgType; Fg = $fg })
        }
        $cats += [pscustomobject]@{ Category = $guid; Colors = $colors }
    }
    return $cats
}

function ConvertTo-ThemeBlob($categories) {
    $ms = [IO.MemoryStream]::new(); $w = [IO.BinaryWriter]::new($ms)
    $w.Write([int]0); $w.Write([int]11); $w.Write([int]@($categories).Count)
    foreach ($cat in $categories) {
        $w.Write(([guid]$cat.Category).ToByteArray())
        $w.Write([int]$cat.Colors.Count)
        foreach ($c in $cat.Colors) {
            $nameBytes = [Text.Encoding]::ASCII.GetBytes($c.Name)
            $w.Write([int]$nameBytes.Length); $w.Write($nameBytes)
            $w.Write([byte]$c.BgType); if ($c.BgType -ne 0) { $w.Write([byte[]]$c.Bg) }
            $w.Write([byte]$c.FgType); if ($c.FgType -ne 0) { $w.Write([byte[]]$c.Fg) }
        }
    }
    $w.Flush(); $bytes = $ms.ToArray()
    [BitConverter]::GetBytes([int]$bytes.Length).CopyTo($bytes, 0)
    return $bytes
}

function Format-HexValue([byte[]]$bytes) {
    $parts = $bytes | ForEach-Object { $_.ToString('x2') }
    $lines = @(); $chunk = 64
    for ($i = 0; $i -lt $parts.Count; $i += $chunk) {
        $end = [Math]::Min($i + $chunk, $parts.Count) - 1
        $lines += ($parts[$i..$end] -join ',')
    }
    return ($lines -join ",\`r`n  ")
}

function Format-Rgb([byte[]]$c) { if (-not $c) { return '' }; return ('#{0:X2}{1:X2}{2:X2}{3:X2}' -f $c[0], $c[1], $c[2], $c[3]) }
