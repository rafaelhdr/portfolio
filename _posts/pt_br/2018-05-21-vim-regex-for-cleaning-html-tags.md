---
layout: post
title:  "vim para limpar tags HTML"
date:   2018-05-21 18:00:00 -0300
categories: vim regex html tag
permalink: blog/vim-regex-for-cleaning-html-tags
lang: pt_br
excerpt: "Demonstra como usar substituições com regex no VIM para extrair valores específicos de tags HTML em arquivos grandes."
---
# VIM para limpar tags HTML

Você tem um arquivo muito grande, e quer extrair algum valor em específico. Você pode usar substituição com expressão regular.

> Certo, não é apenas com VIM. Você poderia usar o grep também. Estou usando VIM pela facilidade no post.

> Sim, você poderia usar um crawler para isso. No meu caso, eu só queria extrair esses valores de um único arquivo.

**TL;DR**

```text
:%g!/useful-class/d
:%s/<a.*href="\([^"]*\).*\n/\1\r/g
```

## Arquivo de teste

Para testar, você pode abrir o seguinte arquivo no VIM:

```html
SOME BIG HTML
<a class="useful-class" href="http://example/1">Example 1</a>
NOT USEFUL LINE
<a class="useful-class" href="http://example/2">Example 2</a>
END OF BIG HTML
```

Em nosso exemplo, queremos remover as linhas inúteis e deixar apenas a URL.

## Comandos

Limpar as linhas inúteis:

`:%g!/useful-class/d`

* **%g!** Fazer algo em todas as linhas que não contenham certa expressão
* **useful-class** A expressão que estamos procurando. No caso, queremos encontrar useful-class
* **d** Definimos que queremos deletar quando não encontrar a expressão

Remover conteúdo inútil:

`:%s/<a.*href="\([^"]*\).*\n/\1\r/g`

* **%s** Substituir todas as linhas que possuam certa expressão
* Expressão (esse é longo):
  * **<a** Que começa com `<a`
  * **.\*** Com qualquer caracter até...
  * **href="** ...até que encontre `href="`
  * **\\([^"]\*\\)** e a primeira parte (chamada de "atom") é qualquer coisa que não contenha aspas(`[^"]*` sem aspas). O "atom" é o conteúdo entre os parênteses(`(...)`)
  * **.\*** e qualquer caracter até...
  * **\n** ...até que encontre uma nova linha `\n`
* **\1\r** e substituir pelo primeiro "atom" e uma nova linha
* **g** rodar o comando

## Done

O resultado é esse:

```text
http://example/1
http://example/2
```

Não é simples, mas da segunda vez é mais fácil de lembrar.

Eu usei hoje para limpar um simples arquivo longo (copiei o DOM `<ul><li><a>...</a></li></ul>`) e rodei os comandos (ao mesmo tempo que ia aprendendo também).

## Referências

* [Delete all lines containing a pattern](http://vim.wikia.com/wiki/Delete_all_lines_containing_a_pattern)
* [Replace while keeping certain “words” in vi/vim](https://stackoverflow.com/questions/11624166/replace-while-keeping-certain-words-in-vi-vim)
* [How to replace a character by a newline in Vim?](https://stackoverflow.com/questions/71323/how-to-replace-a-character-by-a-newline-in-vim)
