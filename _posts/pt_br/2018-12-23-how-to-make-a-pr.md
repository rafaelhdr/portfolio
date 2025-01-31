---
layout: post
title:  "How to make a PR"
date:   2018-12-23 08:00:00 -0300
categories: git gitlab
permalink: blog/how-to-make-a-pr
lang: pt_br
---
# Como fazer um PR

Esse tutotial ensina como fazer um PR (Pull Request, que é integrar seu código git)

## Pegue o código

Usarei o meu repositório [pr tutorial repository](https://gitlab.com/rafaelhdr/pr-example) como examplo. Você pode usá-lo, mas eu recomendo que você use o seu próprio.

`git clone git@gitlab.com:rafaelhdr/pr-example.git`

### Use código recente

*(você pode pular esse passo, se clonou o repositório)*

A maioria do tempo você não estará clonando um repositório, mas usando um já existente. Nesse caso, vá para a branch master e atualize o código.

`git checkout master` para ir a branch master

`git pull origin master` para atualizar com o código mais recente

## Branch

Vamos criar um novo branch com as mudanças. Criaremos o novo branch, e faremos um Pull Reqquest para integrar o código com suas mudanças à branch master (normalmente master, mas pode ser outra).

`git branch make-chapter-2` para criar a nova branch make-chapter-2

`git checkout make-chapter-2` para ir a essa nova branch

> Dica: Os dois comandos acima poderiam ser substituídos por `git branch -b make-chapter-2`

Mude algo no código (examplo: adicione um parágrapho lorem ipsum a content.txt).

`git add content.txt` para adicionar o código ao commit

`git commit -m "make chapter 2"` para criar um commit com essas mudanças

Agora, seu código local está atualizado. We precisamos apenas colocar no servidor (no meu caso, GitLab).

`git push origin make-chapter-2`

## Pronto

O código está pronto. Você pode vê-lo no GitLab (e integrar de lá).
