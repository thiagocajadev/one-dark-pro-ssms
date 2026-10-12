<div align="center">
  <h1 align="center">one-dark-pro-ssms</h1>
  <p align="center">Tema One Dark Pro para o SQL Server Management Studio 22 (port não oficial)</p>
  <a href="https://learn.microsoft.com/ssms/"><img src="https://img.shields.io/badge/SSMS-22-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white" alt="SSMS 22" /></a>
  <a href="https://github.com/Binaryify/OneDark-Pro"><img src="https://img.shields.io/badge/baseado_em-One_Dark_Pro-61AFEF?style=flat-square&logo=atom&logoColor=white" alt="Baseado no One Dark Pro" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/licen%C3%A7a-MIT-98C379?style=flat-square" alt="Licença MIT" /></a>
  <a href="../../releases/latest"><img src="https://img.shields.io/github/v/release/thiagocajadev/one-dark-pro-ssms?style=flat-square&label=vers%C3%A3o&color=blue" alt="Versão publicada" /></a>
  <a href="../../releases/latest/download/one-dark-pro-ssms.zip"><img src="https://img.shields.io/badge/baixar-Windows-0078D4?style=flat-square&logo=windows&logoColor=white" alt="Baixar para Windows" /></a>
  <br><br>
  <a href="README.md">English</a> · <b>Português (Brasil)</b>
</div>

<br>

<p align="center">
  <img src="docs/preview.png" alt="SSMS 22 com o tema One Dark Pro (SSMS)" width="860">
</p>

A versão do [One Dark Pro](https://github.com/Binaryify/OneDark-Pro) para Visual Studio até
carrega no SSMS 22, mas deixa menus, barras de ferramentas e Object Explorer em preto e cinza.
Este port preenche essas lacunas e ajusta as cores do T-SQL à paleta One Dark.

> Port não oficial, sem relação com o autor original. Problemas, abra uma issue aqui.

## Instalar

Requer o SSMS 22 no Windows 10 ou 11.

1. Baixe o [`one-dark-pro-ssms.zip`](../../releases/latest/download/one-dark-pro-ssms.zip) e extraia.
2. Dê dois cliques em `Install.cmd` e aceite o pedido de administrador.
   Se o Windows avisar sobre o arquivo, clique em **Mais informações → Executar assim mesmo**.
3. Reinicie o SSMS e vá em **Tools → Options → Environment → Visual Experience → One Dark Pro (SSMS)**.

## Desinstalar

Se algo der errado, dê dois cliques em `Uninstall.cmd`. Na próxima abertura o SSMS volta para
um tema padrão.

<details>
<summary><b>Fonte e zoom recomendados</b></summary>

<br>

Em **Tools → Options → Environment → Fonts and Colors**:

- **Text Editor:** `JetBrainsMono NFM`, tamanho 12 ([Nerd Fonts](https://www.nerdfonts.com/font-downloads), instalada para todos os usuários)
- **Text Results** e **Grid Results:** a mesma fonte, tamanho 11 ou 12, para as abas Messages e Results acompanharem

Deixe o zoom do editor em **91%**, nunca 100%: as letras ficam mais arredondadas e confortáveis.

</details>

<details>
<summary><b>Atualizar</b></summary>

<br>

**Versão nova do tema:** baixe o zip novo e rode o `Install.cmd` de novo, sem desinstalar antes.

**Versão nova do SSMS:** se alguma parte voltar a ficar preta ou cinza, a atualização trouxe
cores novas. Clone este repositório e regere o tema a partir do SSMS instalado:

```powershell
.\scripts\Build-Theme.ps1
.\scripts\Install.ps1
```

</details>

<details>
<summary><b>Como o port funciona</b></summary>

<br>

O SSMS 22 roda sobre o shell do Visual Studio 2026, cujas categorias de cor (`Shell`,
`ShellInternal`...) o tema original não define. O `Build-Theme.ps1` copia essas categorias do
tema Dark, troca os cinzas neutros pelos tons do One Dark (`#21252B`, `#282C34`, `#2C313A`,
`#3E4452`) e o roxo de destaque por `#61AFEF`, e define os itens de T-SQL exclusivos do SSMS:

| Item | Cor |
| :-- | :-- |
| SQL String | `#98C379` |
| SQL System Function / Stored Procedure | `#61AFEF` |
| SQL System Table | `#E5C07B` |
| SQL Operator | `#56B6C2` |

O tema tem nome e GUID próprios, então nunca colide com a extensão original.

```
one-dark-pro-ssms.pkgdef        o tema pronto
Install.cmd / Uninstall.cmd     atalhos de dois cliques
original/                       One Dark Pro para Visual Studio, entrada do gerador
scripts/Build-Theme.ps1         monta o tema do SSMS a partir do original
scripts/Build-Release.ps1       empacota o zip da release em dist/
scripts/Install.ps1             encontra o SSMS pelo vswhere e copia o tema
scripts/Uninstall.ps1           remove o tema
scripts/ThemeTool.ps1           lê/escreve o formato binário de cores do .pkgdef
scripts/Ssms.ps1                funções comuns
```

</details>

## Licença

MIT. As cores são do One Dark Pro (© Binaryify, veja `original/LICENSE.txt`); os scripts e a
adaptação para o SSMS são deste repositório.
