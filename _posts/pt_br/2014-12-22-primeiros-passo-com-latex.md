---
layout: post
title:  "Primeiros passos com LaTeX"
date:   2014-12-22 11:00:00 -0300
categories: latex
permalink: blog/latex/primeiros-passo-com-latex
lang: pt_br
---
# Primeiros passos com LaTeX

Certo. Já programamos um monte de coisa, e agora vamos programar pra escrever um PDF? Pois é, estranho, mas gostei. Motivo: Não preciso me preocupar com estética, e mesmo assim fica bonito. Minha preocupação é com a organização, e também fica organizado.

Mas tem muito lugar que vai explicar os motivos de usar o LaTeX. Vamos pro código.

## Instalação

Essa parte que vou ficar devendo um pouco, caso você não use Ubuntu. Mas se for, só usar os apt-get abaixo:

sudo apt-get install gummi
sudo apt-get install abntex
Estou usando esse gummi, pois é bem fácil de começar. Foi recomendação em algum site, e peguei. O bom é que ele vai compilando, então você já vê o resultado do que está fazendo. E esse abntex é só para você ter o formato ABNT. Não é tão necessário assim.

Caso não esteja no Ubuntu, baixe algum [por aqui](http://alternativeto.net/software/gummi/?platform=windows).

## Hello World

Certo. Vamos fazer nosso Hello World. Cole o seguinte código:

```tex
\documentclass[]{article}

\begin{document}
Hello World
\end{document}
E com isso, temos nosso Hello World
```

![Latex hello]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-hello-world.png" | absolute_url }})

Certo. Mas o que nós fizémos?

O programa é dividido em 2 partes:

A primeira é o cabeçalho, onde vamos colocando nossas bibliotecas, e informações do projeto. Nosso documento tem uma linha de cabeçalho apenas.

A segunda parte é o documento, em que colocamos as informações, em que no nosso caso são nossas 3 linhas.

*\* Observação: Em alguns casos, pode ocorrer dele demorar para gerar o PDF (e comigo, uma vez compilou errado). Aperte F9 para compilá-lo mais rapidamente (ou corrigir um compilado errado).*

## O básico

Bom, primeiro tive um problema estranho: Ele não aceita acentuação, como "é" ou "ç". Resolvemos isso fácil, dizendo para utilizar UTF-8. Coloque no seu cabeçalho (entre o \documentclass[]{article} e o \begin{document}) o seguinte:

```tex
\usepackage[utf8]{inputenc}
```

E pronto. Resolvemos o primeiro problema. Mas já que estamos com a mão na massa, vamos criar uma capa bonita. Copie e cole o seguinte:

```tex
\documentclass[]{article}

\usepackage[utf8]{inputenc}

\usepackage[brazil]{babel}

\title {Aprendendo \LaTeX}
\author{rafaelhdr}
\date{\today}

\begin{document}
\maketitle
Hello World
\end{document}
```

Quanta coisa. Mas você vai entender rápido.

**usepackage** - Estamos selecionando os pacotes, e passando ainda configurações pra ele. No exemplo, dizemos que é UTF-8 e que é pra fazer em português daqui do Brasil.

**\title \author e \date** - Simplesmente estamos passando algumas informações a mais para o documento.

**\maketitle** - E por fim, estamos mandando ele fazer essa capa, com as informações que já passamos no cabeçalho.

![Latex make title]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-make-title.png" | absolute_url }})

Observação: Para quem conseguiu baixar o ABNT, troque a primeira linha para utilizá-lo.

```tex
\documentclass[]{abnt}
```

Ele só vai mudar um pouco o design. Aí o que você fizer, vai ficar parecido com o meu.

## Conteúdo

Agora vamos incrementar esse conteúdo. Só o hello world não ajuda muito.

Para isso, vamos falar um pouco da estrutura. Ela é dividida em 7 tipos:

* \part
* \chapter
* \section
* \subsection
* \subsubsection
* \paragraph
* \subparagraph

Fonte: [https://pt.sharelatex.com/learn/Sections_and_chapters](https://pt.sharelatex.com/learn/Sections_and_chapters)

Isso vai nos ajudar a organizar bem o nosso texto. Para nosso exemplo, vou criar um PDF com 2 partes compostas por alguns capítulos, justamente ensinando o LaTeX. Para agora, edite apenas o documento. Deixe o cabeçalho como está.

```tex
\begin{document}

\maketitle

\tableofcontents{}

\begin{resumo}
Resumo do meu tutorial de \LaTeX. Espero que possa ajudá-lo.
Teremos apenas alguns exemplos, e o código fonte será distribuído pelo 
site rafaelhdr.com.br.
\end{resumo}

\part{Aprendendo \LaTeX}

\chapter{Começando}

\section{Minha primeira seção}
Esse é meu primeiro texto em \LaTeX. Eu estou
utilizando-o para mostrar alguns exemplos de como trabalhar com ele.
Espero que gostem.
Se tiver alguma dúvida, fique à vontade para postar.
Com certeza podemos nos ajudar juntos, já que eu também estou aprendendo.

\section{Continuando...}
E no caso, vemos que o \LaTeX está ajudando a gente a deixar organizado,
e bonito, sendo que nós nos preocupamos apenas em ter conteúdo.
\end{document}
```

**\tableofcontents** - Queremos um índice. Ele já faz rapidamente.

**\begin{resumo}** - Estamos criando nosso resumo. Muito comum vermos um abstract no começo de textos, e é pra isso mesmo que ele serve.

**\part \chapter \section** - Estamos dizendo como é a estrutura de nosso documento. Simples assim.

Ele já está ganhando um corpo, e já podemos entender o que estamos fazendo. Agora vou partir para os detalhes. Mas antes, salve esse projeto em alguma pasta. Precisaremos disso para nossas imagens.

## Funções extras

### Imagem

Antes de colocarmos as imagens, crie uma pasta (vou chamar essa pasta de images) dentro da pasta que você salvou o latex. E dentro dessa pasta de imagem, coloque uma imagem sua.

* Projeto LaTeX
  * tutorial.tex (seu arquivo latex)
    * images/ (sua pasta de imagens)
    * lion-latex-logo.png (uma imagem para exemplo)

![Latex folder structure]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-folder-structure.png" | absolute_url }})

Certo. Ambiente preparado. Agora coloque no cabeçalho:

```tex
\usepackage{graphicx}
\graphicspath{ {images/} }
```

Isso é para usarmos a bibliotecas de imagens, e então o LaTeX saberá onde procurá-las.

Adicione no texto o seguinte, no final do conteúdo:

```tex
\part{Funções extras}

\chapter{Imagem}
\begin{figure}[h]
\centering
\includegraphics[width=0.3\linewidth]{lion-latex-logo.png}
\caption{Minha imagem recém adicionada :)}
\label{fig:lion}
\end{figure}
```

E podemos fazer facilmente referências a essa imagem \ref{fig:lion}

Para organizar, estou criando novo capítulo. Com o texto acima, centralizamos nossa imagem. Além disso, conseguimos fazer referência de qualquer lugar, como no exemplo. E abaixo, o resultado:

![Latex image]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-image.png" | absolute_url }})

### Link

Vamos lá. Código do cabeçalho:

```tex
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    filecolor=magenta,
    urlcolor=cyan,
}
```

E agora o código do documento:

```tex
\chapter{Link}
Link para o \href{http://www.rafaelhdr.com.br}{meu site}
```

E você já deve estar entendendo bem mais rápido (depois de tantos exercícios). Usamos o pacote hyperref, e logo após o configuramos com algumas cores (a padrão eu achei estranha). E então você configura as cores dele com o hypersetup (você encontra mais opções de configurações aqui).

E agora abaixo o resultado.

![Latex link]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-link.png" | absolute_url }})

### Código

Se você for programador, vai precisar disso. Então vamos lá! Cabeçalho:

```tex
\usepackage{listings}
```

E documento:

```tex
\chapter{Inserir código}
Abaixo, vamos escrever um código simples.
\begin{lstlisting}
print "Hello World!"
\end{lstlisting}
```

Usamos o package listings, e no documento, usamos begin e end para delimitar o código.

![Latex code]({{"/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-code.png" | absolute_url }})

### Bibliografia

E esse é o último. Não precisamos de cabeçalho. No documento:

```tex
\chapter{Adicionar bibliografia}
```

Para colocar bibliografia, farei uma referência \cite{bibliography_management} \cite{learn_latex}.

```tex
\begin{thebibliography}{}
\bibitem{bibliography_management}
  wikibooks,
  \url{http://en.wikibooks.org/wiki/LaTeX/Bibliography_Management},
  Acessado em \date{\today}.

\bibitem{learn_latex}
  sharelatex,
  \url{https://pt.sharelatex.com/learn/},
  acessado em \date{\today}.
\end{thebibliography}
```

E pronto. Se precisarmos de algo, podemos citá-lo com o \cite. Ao final, colocamos nossa bibliografia, e damos um nome a ela. Com esse nome, não precisamos mais nos preocupar na ordem das referências, que o próprio LaTeX vai linká-lo corretamente.

## Conclusão

Certo. Teve muita coisa aqui. Podemos facilmente nos perder em tanto código. Tente usar comentários (linhas que começam com % são comentários) para ajudá-lo a se organizar.

Mas agora, é com você. Faça algum trabalho com LaTeX para ajudar a se familiarizar com ele, e lembrar de tudo.

Vou disponibilizar isso tudo que fiz para vocês: [latex-tutorial.zip](/assets/posts/2014-12-22-primeiros-passo-com-latex/latex-tutorial.zip).
