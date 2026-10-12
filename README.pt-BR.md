# one-dark-pro-ssms

Port **não oficial** do tema [One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.onedarkpro),
de [Binaryify](https://github.com/Binaryify/OneDark-Pro), para o SQL Server Management Studio 22.
Não tem relação com o autor original: dúvidas e problemas deste port ficam aqui.

[Read in English](README.md)

## Instalar

Clique com o botão direito em `Install.ps1` → **Executar com o PowerShell** (vai pedir administrador).
Depois, no SSMS: **Tools → Options → Environment → Visual Experience → One Dark Pro (SSMS)**.

Para remover: `Uninstall.ps1`.

## Fonte e zoom recomendados

O tema só cuida das cores; a fonte e o zoom completam o visual:

- **Fonte:** `JetBrainsMono NFM`, tamanho **12**
  (Tools → Options → Environment → Fonts and Colors → Show settings for: **Text Editor**).
  É a JetBrains Mono na versão Nerd Font Mono: baixar em [nerdfonts.com](https://www.nerdfonts.com/font-downloads)
  e instalar para todos os usuários antes de escolher no SSMS.
- **Zoom do editor:** **91%**, nunca 100%. Com o zoom um pouco menor as letras ficam mais
  arredondadas e a leitura fica mais confortável. Ajuste na caixa de zoom no canto inferior
  esquerdo do editor.

## Depois de atualizar o SSMS

Se alguma parte voltar a ficar cinza/preta, a atualização trouxe cores novas. Regere o tema e reinstale:

```powershell
.\generator\Build-Theme.ps1
.\Install.ps1
```

## O que tem aqui

| Arquivo | Para quê |
|---|---|
| `one-dark-pro-ssms.pkgdef` | O tema pronto para o SSMS 22 |
| `Install.ps1` / `Uninstall.ps1` | Copiam/removem o tema na pasta `Common7\IDE\Extensions\one-dark-pro-ssms` do SSMS |
| `Ssms.ps1` | Funções comuns (acha o SSMS pelo `vswhere`, pede administrador) |
| `original/OneDark-Pro.vs.pkgdef` | Tema original da extensão do Visual Studio (base do gerador) |
| `generator/Build-Theme.ps1` | Monta o tema do SSMS a partir do original |
| `generator/ThemeTool.ps1` | Lê/escreve o formato binário das cores do `.pkgdef` |

## Por que precisou adaptar

O SSMS 22 usa o shell novo do Visual Studio 2026, com categorias de cor (`Shell`, `ShellInternal`...)
que o tema do VS 2022 não define. Sem elas o SSMS caía nas cores do tema Dark (`#1C1C1C`, `#282828`).
O gerador copia essas categorias do Dark e troca os cinzas neutros pelos tons do One Dark
(`#21252B`, `#282C34`, `#2C313A`, `#3E4452`...) e o roxo de destaque pelo azul `#61AFEF`.

Cores do T-SQL ajustadas (tabela `$overrides` no gerador):

| Item | Cor |
|---|---|
| SQL String | `#98C379` |
| SQL System Function / Stored Procedure | `#61AFEF` |
| SQL System Table | `#E5C07B` |
| SQL Operator | `#56B6C2` |

O tema tem nome (**One Dark Pro (SSMS)**) e GUID próprios (`dbc802a0-5b08-4884-94f5-0754b3d891a8`),
para não colidir com a extensão original.

> A Microsoft não dá suporte a extensões de terceiros no SSMS. Se algo der errado, `Uninstall.ps1` resolve.

## Licença

MIT. Veja [LICENSE](LICENSE): as cores são do One Dark Pro (© Binaryify, licença original em
`original/LICENSE.txt`); os scripts e a adaptação para o SSMS são deste repositório.
