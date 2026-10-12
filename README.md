<div align="center">
  <h1 align="center">one-dark-pro-ssms</h1>
  <p align="center">
    Unofficial port of the One Dark Pro theme to SQL Server Management Studio 22,<br>
    with the new shell colors and T-SQL syntax tuned to the One Dark palette.
  </p>
  <a href="https://learn.microsoft.com/ssms/"><img src="https://img.shields.io/badge/SSMS-22-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white" alt="SSMS 22" /></a>
  <a href="https://learn.microsoft.com/powershell/"><img src="https://img.shields.io/badge/PowerShell-5.1_%7C_7-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell 5.1 | 7" /></a>
  <a href="https://github.com/Binaryify/OneDark-Pro"><img src="https://img.shields.io/badge/based_on-One_Dark_Pro-61AFEF?style=flat-square&logo=atom&logoColor=white" alt="Based on One Dark Pro" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-98C379?style=flat-square" alt="MIT license" /></a>
  <br>
  <a href="../../releases/latest"><img src="https://img.shields.io/github/v/release/thiagocajadev/one-dark-pro-ssms?style=flat-square&label=version&color=blue" alt="Published version" /></a>
  <a href="../../releases/latest/download/one-dark-pro-ssms.zip"><img src="https://img.shields.io/badge/download-Windows-0078D4?style=flat-square&logo=windows&logoColor=white" alt="Download for Windows" /></a>
</div>

<br>

<p align="center">
  <img src="docs/preview.png" alt="SSMS 22 with the One Dark Pro (SSMS) theme" width="860">
</p>

This repository ports the [One Dark Pro](https://github.com/Binaryify/OneDark-Pro) theme by
Binaryify to SSMS 22. The Visual Studio version of the theme loads in SSMS, but leaves menus,
toolbars and Object Explorer in plain black and gray. This port fills those gaps and ships as a
download-and-run package.

> **This is an unofficial port, not affiliated with the original author.**
>
> Issues with this port belong here, not in the One Dark Pro repository. The theme has its own
> name, **One Dark Pro (SSMS)**, and its own GUID, so it never collides with the original
> extension. [Leia em português](README.pt-BR.md).

## Key concepts

| Term | What it is |
| :-- | :-- |
| **.pkgdef** | Registration file the Visual Studio shell (and SSMS, built on it) reads at startup; a theme is one of these |
| **color category** | Named group of colors inside a theme, such as `Environment` or `Shell`; each part of the IDE reads its own |
| **Visual Experience** | SSMS 22 settings page where the color theme is chosen |
| **UAC** | Windows prompt that confirms administrator rights before writing to the SSMS install folder |
| **Mark of the Web** | Tag Windows puts on downloaded files, which makes it warn before running them |

## Download

| Platform | File | Requirement |
| :-- | :-- | :-- |
| Windows | [`one-dark-pro-ssms.zip`](../../releases/latest/download/one-dark-pro-ssms.zip) | SSMS 22 installed, Windows 10 or 11 |

**Why SSMS 22 only.** SSMS 21 and earlier run on older Visual Studio shells, with other color
categories and other install paths. The theme targets the shell SSMS 22 ships with.

## What to expect when installing

**Extract the zip and double-click `Install.cmd`.** It runs `scripts\Install.ps1`, which finds
SSMS through `vswhere` and copies the theme into its `Extensions` folder.

**Windows may warn before running it**, because the file came from the internet and is not
signed. Click **More info** and then **Run anyway**.

**It asks for administrator rights.** SSMS lives under a protected folder, and the theme has to
sit next to the other SSMS extensions. Nothing is written anywhere else.

**Then pick the theme in SSMS.** Restart SSMS if it was open, and go to **Tools → Options →
Environment → Visual Experience → One Dark Pro (SSMS)**.

To remove it, double-click `Uninstall.cmd`. SSMS falls back to a built-in theme on next launch.

## Recommended font and zoom

The theme only handles colors. Font and zoom complete the look:

- **Font:** `JetBrainsMono NFM`, size **12**, in **Tools → Options → Environment → Fonts and
  Colors → Show settings for: Text Editor**. It is JetBrains Mono in its Nerd Font Mono flavor:
  download it from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and install it for
  all users before picking it in SSMS.
- **Editor zoom:** **91%**, not 100%. At a slightly smaller zoom the glyphs render rounder and
  are easier on the eyes. Set it in the zoom box at the bottom-left corner of the editor.

## Updating

**New version of the theme:** download the new zip and run `Install.cmd` again. There is no need
to uninstall first; the installer replaces the previous file.

**New version of SSMS:** if some area turns black or gray again, the update shipped new color
categories. Clone this repository and rebuild the theme from the installed SSMS:

```powershell
.\scripts\Build-Theme.ps1
.\scripts\Install.ps1
```

## The theme

- **Shell:** the categories SSMS 22 takes from the Visual Studio 2026 shell (`Shell`,
  `ShellInternal` and others) are copied from the Dark theme, with the neutral grays swapped for
  One Dark tones (`#21252B`, `#282C34`, `#2C313A`, `#3E4452`) and the purple accent for `#61AFEF`
- **Editor:** the original One Dark Pro colors, untouched
- **T-SQL:** the SSMS-only syntax items, which the original theme doesn't define, tuned to the
  One Dark palette:

| Item | Color |
| :-- | :-- |
| SQL String | `#98C379` |
| SQL System Function / Stored Procedure | `#61AFEF` |
| SQL System Table | `#E5C07B` |
| SQL Operator | `#56B6C2` |

Microsoft doesn't support third-party extensions in SSMS. If anything goes wrong,
`Uninstall.cmd` reverts it.

## Project layout

```
one-dark-pro-ssms.pkgdef        the ready-to-use theme
Install.cmd / Uninstall.cmd     double-click entry points
original/                       One Dark Pro for Visual Studio, input of the generator
scripts/Install.ps1             finds SSMS and copies the theme (asks for administrator rights)
scripts/Uninstall.ps1           removes the theme
scripts/Build-Theme.ps1         builds the SSMS theme from the original one
scripts/ThemeTool.ps1           reads and writes the binary color format of .pkgdef files
scripts/Build-Release.ps1       packages the release zip into dist/
scripts/Ssms.ps1                shared helpers (vswhere lookup, elevation)
```

The rule behind the generator: the original theme is never edited by hand. `Build-Theme.ps1`
reads it, adds what SSMS needs on top and applies the T-SQL overrides, so the port can be
rebuilt whenever SSMS or the original theme changes.

## Stack

SSMS 22 · Visual Studio shell themes (.pkgdef) · PowerShell 5.1 and 7

## License

MIT. See [LICENSE](LICENSE): the colors come from One Dark Pro (© Binaryify, original license
in `original/LICENSE.txt`); the scripts and the SSMS port belong to this repository.
