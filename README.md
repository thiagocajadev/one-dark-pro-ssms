# one-dark-pro-ssms

An **unofficial** port of the [One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.onedarkpro)
theme by [Binaryify](https://github.com/Binaryify/OneDark-Pro) to SQL Server Management Studio 22.
It is not affiliated with the original author: please report issues with this port here.

[Leia em português](README.pt-BR.md)

## Install

Right-click `scripts\Install.ps1` → **Run with PowerShell** (it asks for administrator rights).
Then, in SSMS: **Tools → Options → Environment → Visual Experience → One Dark Pro (SSMS)**.

To remove it, run `scripts\Uninstall.ps1`.

## Recommended font and zoom

The theme only handles colors. Font and zoom complete the look:

- **Font:** `JetBrainsMono NFM`, size **12**
  (Tools → Options → Environment → Fonts and Colors → Show settings for: **Text Editor**).
  It is JetBrains Mono in its Nerd Font Mono flavor: download it from
  [nerdfonts.com](https://www.nerdfonts.com/font-downloads) and install it for all users before picking it in SSMS.
- **Editor zoom:** **91%**, not 100%. At a slightly smaller zoom the glyphs render rounder and are easier
  on the eyes. Set it in the zoom box at the bottom-left corner of the editor.

## After an SSMS update

If some area turns gray or black again, the update shipped new colors. Rebuild the theme and reinstall:

```powershell
.\scripts\Build-Theme.ps1
.\scripts\Install.ps1
```

## What's inside

| File | Purpose |
|---|---|
| `one-dark-pro-ssms.pkgdef` | The ready-to-use theme for SSMS 22 |
| `original/OneDark-Pro.vs.pkgdef` | Original theme from the Visual Studio extension (generator input) |
| `scripts/Install.ps1` / `scripts/Uninstall.ps1` | Copy/remove the theme in SSMS's `Common7\IDE\Extensions\one-dark-pro-ssms` folder |
| `scripts/Build-Theme.ps1` | Builds the SSMS theme from the original one |
| `scripts/ThemeTool.ps1` | Reads/writes the binary color format inside `.pkgdef` files |
| `scripts/Ssms.ps1` | Shared helpers (finds SSMS through `vswhere`, elevates to administrator) |

## Why it needed a port

SSMS 22 runs on the new Visual Studio 2026 shell, which uses color categories (`Shell`, `ShellInternal`...)
that the Visual Studio 2022 theme doesn't define. Without them SSMS fell back to the Dark theme colors
(`#1C1C1C`, `#282828`). The generator copies those categories from Dark, swaps the neutral grays for
One Dark tones (`#21252B`, `#282C34`, `#2C313A`, `#3E4452`...) and the purple accent for blue `#61AFEF`.

T-SQL colors tuned in the `$overrides` table of the generator:

| Item | Color |
|---|---|
| SQL String | `#98C379` |
| SQL System Function / Stored Procedure | `#61AFEF` |
| SQL System Table | `#E5C07B` |
| SQL Operator | `#56B6C2` |

The theme has its own name (**One Dark Pro (SSMS)**) and GUID (`dbc802a0-5b08-4884-94f5-0754b3d891a8`),
so it never collides with the original extension.

> Microsoft doesn't support third-party extensions in SSMS. If anything goes wrong, `scripts\Uninstall.ps1` reverts it.

## License

MIT. See [LICENSE](LICENSE): the colors come from One Dark Pro (© Binaryify, original license in
`original/LICENSE.txt`); the scripts and the SSMS port belong to this repository.
