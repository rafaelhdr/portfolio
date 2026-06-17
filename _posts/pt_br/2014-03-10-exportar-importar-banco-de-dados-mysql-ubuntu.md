---
layout: post
title:  "Exportar e importar banco de dados MySQL com o Ubuntu"
date:   2014-03-10 12:00:00 -0300
categories: mysql dump ubuntu
permalink: blog/mysql/exportar-importar-banco-de-dados-mysql-ubuntu
lang: pt_br
excerpt: "Use mysqldump para exportar e o comando source para importar bancos de dados MySQL no Ubuntu."
---
# Exportar/importar banco de dados MySQL no Ubuntu

Em alguns momentos, é necessário transferir as informações de um banco de dados para outro. No meu caso, precisava transferir as informações de um banco de dados local para um externo (RDS da Amazon). Vou explicar como fazer o dump utilizando servidor Ubuntu.

O processo consiste em 2 tarefas: Transferir as informações para um arquivo, e em seguida importá-lo no banco de dados.

## mysqldump

Esse é um comando shell para copiar os dados de uma base para um arquivo.

```mysql
mysqldump -u root -p table_name > arquivo.sql
```

* **-u root**  Parâmetro que define o usuário
* **-p** Pede senha ao executar a operação
* **table_name** Aqui você coloca o nome do database que deseja realizar o dump
* **> arquivo.sql**

Escolha o destino do backup feito.

## Source

Após gerar o arquivo, você precisa puxar esses dados com o banco de dados.
Conecte-se com o banco de dados mysql.

```mysql
mysql -h hostname -u root -p
```

* **mysql** Comando para estabelecer uma conexão
* **-h hostname** No meu caso, precisava estabelecer uma conexão fora do servidor local (no caso, era um RDS da Amazon). Havendo conexão, você está executando códigos dentro da tabela. Basta duas linhas de código que está pronto.

```mysql
USE table_name;
SOURCE arquivo.sql;
```

**USE table_name;** É necessário dizer qual tabela está utilizando, para executar o código no lugar correto. (Caso não tenha criado a tabela, digite "CREATE DATABASE table_name")
**SOURCE arquivo.sql;** Irá executar os comandos que acabou de realizar o dump.

Com isso, você terá feito a transferência entre os diferentes bancos de dados.

Fontes:

* [http://dev.mysql.com/doc/refman/5.0/en/batch-commands.html](http://dev.mysql.com/doc/refman/5.0/en/batch-commands.html)
* [http://dev.mysql.com/doc/refman/5.5/en/mysqldump.html](http://dev.mysql.com/doc/refman/5.5/en/mysqldump.html)