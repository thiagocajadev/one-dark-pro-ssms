<div align="center">
  <h1 align="center">one-dark-pro-ssms</h1>
  <p align="center">
    Port não oficial do tema One Dark Pro para o SQL Server Management Studio 22,<br>
    com as cores do shell novo e a sintaxe do T-SQL ajustadas à paleta One Dark.
  </p>
  <a href="https://learn.microsoft.com/ssms/"><img src="https://img.shields.io/badge/SSMS-22-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white" alt="SSMS 22" /></a>
  <a href="https://learn.microsoft.com/powershell/"><img src="https://img.shields.io/badge/PowerShell-5.1_%7C_7-5391FE?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell 5.1 | 7" /></a>
  <a href="https://github.com/Binaryify/OneDark-Pro"><img src="https://img.shields.io/badge/baseado_em-One_Dark_Pro-61AFEF?style=flat-square&logo=atom&logoColor=white" alt="Baseado no One Dark Pro" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/licen%C3%A7a-MIT-98C379?style=flat-square" alt="Licença MIT" /></a>
  <br>
  <a href="../../releases/latest"><img src="https://img.shields.io/github/v/release/thiagocajadev/one-dark-pro-ssms?style=flat-square&label=vers%C3%A3o&color=blue" alt="Versão publicada" /></a>
  <a href="../../releases/latest/download/one-dark-pro-ssms.zip"><img src="https://img.shields.io/badge/baixar-Windows-0078D4?style=flat-square&logo=windows&logoColor=white" alt="Baixar para Windows" /></a>
</div>

<br>

<p align="center">
  <img src="docs/preview.png" alt="SSMS 22 com o tema One Dark Pro (SSMS)" width="860">
</p>

Este repositório adapta o tema [One Dark Pro](https://github.com/Binaryify/OneDark-Pro), do
Binaryify, para o SSMS 22. A versão do tema para Visual Studio até carrega no SSMS, mas deixa
menus, barras de ferramentas e Object Explorer em preto e cinza. Este port preenche essas
lacunas e é distribuído como pacote para baixar e executar.

> **Este é um port não oficial, sem relação com o autor original.**
>
> Problemas deste port ficam aqui, não no repositório do One Dark Pro. O tema tem nome próprio,
> **One Dark Pro (SSMS)**, e GUID próprio, então nunca colide com a extensão original.
> [Read in English](README.md).

## Conceitos fundamentais

| Termo | O que é |
| :-- | :-- |
| **.pkgdef** | Arquivo de registro que o shell do Visual Studio (e o SSMS, construído sobre ele) lê na abertura; um tema é um desses |
| **categoria de cor** | Grupo nomeado de cores dentro do tema, como `Environment` ou `Shell`; cada parte da IDE lê a sua |
| **Visual Experience** | Página de configurações do SSMS 22 onde se escolhe o tema de cores |
| **UAC** | Aviso do Windows que confirma a permissão de administrador antes de gravar na pasta de instalação do SSMS |
| **Mark of the Web** | Marca que o Windows põe em arquivos baixados, e que faz ele avisar antes de executá-los |

## Baixar

| Plataforma | Arquivo | Requisito |
| :-- | :-- | :-- |
| Windows | [`one-dark-pro-ssms.zip`](../../releases/latest/download/one-dark-pro-ssms.zip) | SSMS 22 instalado, Windows 10 ou 11 |

**Por que só o SSMS 22.** O SSMS 21 e anteriores rodam sobre shells mais antigos do Visual
Studio, com outras categorias de cor e outros caminhos de instalação. O tema mira o shell que
vem no SSMS 22.

## O que esperar ao instalar

**Extraia o zip e dê dois cliques em `Install.cmd`.** Ele roda o `scripts\Install.ps1`, que
encontra o SSMS pelo `vswhere` e copia o tema para a pasta `Extensions` dele.

**O Windows pode avisar antes de executar**, porque o arquivo veio da internet e não é assinado.
Clique em **Mais informações** e depois em **Executar assim mesmo**.

**Pede permissão de administrador.** O SSMS fica numa pasta protegida, e o tema precisa ficar
junto das outras extensões dele. Nada é gravado em outro lugar.

**Depois, escolha o tema no SSMS.** Reinicie o SSMS se ele estiver aberto e vá em **Tools →
Options → Environment → Visual Experience → One Dark Pro (SSMS)**.

Para remover, dê dois cliques em `Uninstall.cmd`. Na próxima abertura o SSMS volta para um
tema padrão.

## Fonte e zoom recomendados

O tema só cuida das cores; a fonte e o zoom completam o visual:

- **Fonte:** `JetBrainsMono NFM`, tamanho **12**, em **Tools → Options → Environment → Fonts
  and Colors → Show settings for: Text Editor**. É a JetBrains Mono na versão Nerd Font Mono:
  baixe em [nerdfonts.com](https://www.nerdfonts.com/font-downloads) e instale para todos os
  usuários antes de escolher no SSMS.
- **Zoom do editor:** **91%**, nunca 100%. Com o zoom um pouco menor as letras ficam mais
  arredondadas e a leitura fica mais confortável. Ajuste na caixa de zoom no canto inferior
  esquerdo do editor.

## Atualizar

**Versão nova do tema:** baixe o zip novo e rode o `Install.cmd` de novo. Não é preciso
desinstalar antes; o instalador substitui o arquivo anterior.

**Versão nova do SSMS:** se alguma parte voltar a ficar preta ou cinza, a atualização trouxe
categorias de cor novas. Clone este repositório e regere o tema a partir do SSMS instalado:

```powershell
.\scripts\Build-Theme.ps1
.\scripts\Install.ps1
```

## O tema

- **Shell:** as categorias que o SSMS 22 herda do shell do Visual Studio 2026 (`Shell`,
  `ShellInternal` e outras) são copiadas do tema Dark, com os cinzas neutros trocados pelos
  tons do One Dark (`#21252B`, `#282C34`, `#2C313A`, `#3E4452`) e o roxo de destaque por `#61AFEF`
- **Editor:** as cores originais do One Dark Pro, sem alteração
- **T-SQL:** os itens de sintaxe exclusivos do SSMS, que o tema original não define, ajustados
  à paleta One Dark:

| Item | Cor |
| :-- | :-- |
| SQL String | `#98C379` |
| SQL System Function / Stored Procedure | `#61AFEF` |
| SQL System Table | `#E5C07B` |
| SQL Operator | `#56B6C2` |

A Microsoft não dá suporte a extensões de terceiros no SSMS. Se algo der errado, o
`Uninstall.cmd` desfaz a instalação.

## Estrutura do projeto

```
one-dark-pro-ssms.pkgdef        o tema pronto
Install.cmd / Uninstall.cmd     atalhos de dois cliques
original/                       One Dark Pro para Visual Studio, entrada do gerador
scripts/Install.ps1             encontra o SSMS e copia o tema (pede administrador)
scripts/Uninstall.ps1           remove o tema
scripts/Build-Theme.ps1         monta o tema do SSMS a partir do original
scripts/ThemeTool.ps1           lê e escreve o formato binário de cores do .pkgdef
scripts/Build-Release.ps1       empacota o zip da release em dist/
scripts/Ssms.ps1                funções comuns (busca pelo vswhere, elevação)
```

A regra por trás do gerador: o tema original nunca é editado à mão. O `Build-Theme.ps1` lê o
original, acrescenta o que o SSMS precisa e aplica os ajustes do T-SQL, então o port pode ser
refeito sempre que o SSMS ou o tema original mudarem.

## Stack

SSMS 22 · temas do shell do Visual Studio (.pkgdef) · PowerShell 5.1 e 7

## Licença

MIT. Veja [LICENSE](LICENSE): as cores são do One Dark Pro (© Binaryify, licença original em
`original/LICENSE.txt`); os scripts e a adaptação para o SSMS são deste repositório.
