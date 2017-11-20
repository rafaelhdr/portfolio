---
layout: post
title:  "Recuperar senha de um banco de dados MySQL via SSH"
date:   2014-02-23 18:00:00 -0300
categories: mysql senha ssh
permalink: blog/mysql/recuperar-senha-mysql-via-ssh
lang: pt_br
---
# Recupere a senha do MySQL

Algumas vezes eu perdi minha senha de acesso ao Banco de Dados. Hoje utilizo um gerenciador de senhas para evitar perdê-las (KeePassX). Mas no caso da perda acontecer, tem como recuperá-la.

**Para recuperá-la, você irá precisar de acesso de super usuário via ssh (ou terminal, se for local).**

Interrompa o MySQL

```mysql
sudo service mysql stop
```

Em seguida, execute o código para tirar a necessidade de utilizar a senha no acesso

```shell
sudo mysqld_safe --skip-grant-tables &
```

Após esses comandos, você consegue entrar no MySQL sem a necessidade da senha.

Acesse o MySQL. Estou usando o usuário root, que é aquele normalmente criado como usuário mestre do MySQL.

```shell
mysql -u root
```

Com isso, vamos setar a nova senha para o usuario root. No caso, estou setando como NOVA-SENHA

```mysql
use mysql;
update user set authentication_string=PASSWORD("NOVA-SENHA") where User='root';
flush privileges;
quit
```

*\* Se não funcionar, tente utilizar **password** ao invés de **authentication_string**. [As versões mais recentes utilizam authentication_string](http://stackoverflow.com/questions/30692812/mysql-user-db-does-not-have-password-columns-installing-mysql-on-osx).*

Em seguida, iremos parar a execução do mysql, e retorná-la.

```shell
sudo service mysql stop
sudo service mysql start
```

E está pronto para uso. Utilize a nova senha criada para acessar seu Banco de Dados.

```mysql
mysql -u root -p
```

Fonte:

* [http://www.cyberciti.biz/tips/recover-mysql-root-password.html](http://www.cyberciti.biz/tips/recover-mysql-root-password.html)
