---
layout: post
title:  "Editar commit antigo do git"
date:   2018-05-13 18:00:00 -0300
categories: git rebase
permalink: blog/edit-git-previous-commit
lang: pt_br
---
# Editar commit antigo do git

Se você cometeu algum erro em um commit anterior do git e quer editá-lo, você pode usar o git rebase para isso.

*Não é recomendado se você já subiu com* `git push`

**tl;dr** `git rebase COMMITHASH`

Vou explicar como fazer com um exemplo completo:

## Criando o cenário

Com os comandos abaixo, você terá três commits.

```shell
git init
echo "first commit" > file0.txt
git add .
git commit -m "first commit"
echo "some code
password forgotten
more code" > file1.txt
git add .
git commit -m "commit 1"
echo "more code" > file2.txt
git add .
git commit -m "commit 2"
```

Temos três arquivos (file0.txt, file1.txt e file2.txt), mas um deles tem a senha escrita que foi adicionado no "commit 1".

## git rebase

Podemos usar o git rebase com hash ou então há 2 commits atrás.

```shell
git rebase -i HEAD^2
# OR
git rebase -i COMMIT_1_HASH
```

Você verá algo assim (com hash diferente);

```shell
pick 3aa4948 commit 1
pick 9e5aadf commit 2

# More code, even explaining the options
```

Nós queremos editar o "commit 1", então vamos mudar de **pick** para **edit** no "commit 1":

```shell
edit 3aa4948 commit 1
pick 9e5aadf commit 2
```

> Poderíamos ter utilizado apenas `e` ao invés de `edit`.

E agora estamos no "commit 1". Vamos remover a linha `password forgotten` e refazer o commit.

```shell
echo "some code
more code" > file1.txt
git add .
git commit --amend # We are editing an existent commit
```

E está pronto. Nós precisamos deixar o git continuar o processo com o comando `git rebase --continue`.

Você verá a seguinte mensagem: `Successfully rebased and updated refs/heads/master.`

E agora está pronto para o `push`.

## Cuidado

Se você já fez `push` antes, provevalmente terá problemas. É melhor editar o arquivo (e mudar sua própria senha).

## Nota sobre o primeiro commit

O primeiro commit não é importante. Por que eu o adicionei? Porque o git rebase seria um pouco diferente.

Se você tentar `git rebase -i HEAD~3` terá o seguinte erro:

```shell
fatal: Needed a single revision
invalid upstream 'HEAD~3'
```

Precisaria no caso usar `git rebase -i --root`.

## Referência

[Git Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)

