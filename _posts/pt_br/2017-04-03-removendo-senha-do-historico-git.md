---
layout: post
title:  "Removendo senha do histórico git"
date:   2017-04-03 20:00:00 -0300
categories: git senha
permalink: blog/git/removendo-senha-do-historico-git
lang: pt_br
---
# Removendo senha do histórico git

Imagine que você quer editar o seu histórico do git por algum motivo qualquer (como tirar aquela senha que colocou e não devia). Vou mostrar como é fácil resolver isso.

## Criando ambiente

Vou gerar alguns commits simples, apenas para simular um ambiente com a senha.

```shell
echo "Arquivo OK" > main.txt
git add .
git commit -m "First commit"

echo "minha senha" > password.txt
git add .
git commit -m "Ops. Coloquei a senha aqui."

echo "continuei trabalhando" > work.txt
git add .
git commit -m "Commitando"
```

Certo. Temos três commits, e queremos tirar o arquivo password.txt.

## Editando o histórico

Precisamos apenas retirar o arquivo password.txt. Para isso, vamos usar o git filter-branch.

O filter-branch serve para reescrever os commits da branch com algum filtro que definirmos, que no nosso caso será remover o arquivo de senhas.

```shell
git filter-branch --tree-filter 'rm -f password.txt' HEAD
git gc --prune=now
```

E pronto. Limpamos do histórico. Explicando um pouco os comandos:

**git filter-branch --tree-filter 'COMANDO' HEAD** - Vai executar o comando COMANDO em cada commit. Nosso comando foi rm -f password.txt, que remove o arquivo, sendo o argumento -f usando para não levantar erro no meio da execução, caso não encontre o arquivo.

**git gc --prune=now** - Comando limpa commits sem referências, então se por algum acaso há um commit solto (e que ainda tenha o arquivo password.txt) ele será apagado.

O comando que se executa pode ser qualquer coisa. Cuidado para não levantar erro (exit diferente de 0). Algo mais poderoso, é usar para alterar do histórico senha que está dentro dos arquivos. Pra isso, você pode substituir sua senha verdadeira por outra Mock ([ver mais em find and replace do post meus usos mais comuns de comando sh]({% post_url pt_br/2014-07-13-meus-usos-mais-comuns-de-comandos-sh %})).

E mais uma coisa. Se você já tiver dado push, terá problemas, pois precisa sincronizar isso com o servidor remoto (e outras pessoas que tiverem com as informações erradas).

Referência
* [https://git-scm.com/docs/git-filter-branch](https://git-scm.com/docs/git-filter-branch)
