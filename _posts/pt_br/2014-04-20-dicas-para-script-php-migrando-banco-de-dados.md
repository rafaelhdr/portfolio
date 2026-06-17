---
layout: post
title:  "Dicas para script php migrando banco de dados mysql"
date:   2014-04-20 12:00:00 -0300
categories: mysql script php
permalink: blog/mysql/dicas-para-script-php-migrando-banco-de-dados
lang: pt_br
excerpt: "Dicas para criar scripts PHP de migração de banco de dados MySQL com comandos de conexão e debugging."
---
# Dicas para script php migrando banco de dados mysql

Em alguns momentos precisamos de um script para as mudanças do Banco de Dados Mysql. Em geral, prefiro usar um migrate (com Python Django, consigo fazer isso facilmente). Mas às vezes isso não é possível, e então precisamos de um script para isso.

Acabei de fazer uma migração dessa, então vou colocar aqui algumas dicas (para que seja mais fácil de fazê-lo com menos erros).

Uma observação, eu preferi fazer um script PHP para isso, pois houve muita mudança no Banco de Dados, e para facilitar, resolvi utilizá-lo.

## Comandos de conexão (obrigatório)

Você com certeza vai precisar executá-lo (embora já deva conhecer):

```mysql
$link = mysql_connect('localhost', 'user', '****')
   or die('Could not connect: ' . mysql_error());
echo 'Connected successfully';
mysql_select_db('database') or die('Could not select database');
Dica: Mantenha os die, pois é só copiar e colar, e vai te ajudar na hora de debugar os erros.
```

## Comandos opcionais

Alguns comandos que me ajudaram, foram os seguintes:

Desabilitar check foreign keys - Eu fiz uma super mudança no BD. Dessa forma, retirei tudo sem verificação do BD.
Mas tome cuidado ao fazer isso, e mantenha um backup, para o caso de perder alguma informação (pois então você pode ver se falhou em alguma importação).

```mysql
// Desabilita check de foreign keys

$query = 'SET foreign_key_checks = 0;';
$result = mysql_query($query) or die('Query failed disable foreign_key_checks: ' . mysql_error());
```

Trabalhar com UTF-8 - Na minha primeira tentativa, esqueci disso, e alguns caracteres eram importados errados.

```mysql
// SET UTF8

$query = "SET NAMES 'UTF8'";
$result = mysql_query($query) or die('Query failed set utf8: ' . mysql_error());
```

## Comandos

Não vou colocar os comandos padrões (INSERT, UPDATE, DELETE) que se você está aqui, já deve conhecê-los (mas se não conhece, vai encontrar no w3schools), mas vou colocar alguns outros menos usados.

Drop Table - Usado para apagar alguma tabela.

```mysql
// DROP prestador table

$query = 'DROP TABLE tabelax';
$result = mysql_query($query) or die('Query failed drop tabelax: ' . mysql_error());
```

Rename Table - Usei na hora de criar algumas tabelas temporárias, e depois as oficiais.

```mysql
// Rename tabela_temp

$query = 'RENAME TABLE tabela_temp TO tabela;
$result = mysql_query($query) or die('Query failed rename tabela_temp to tabela: ' . mysql_error());
```

Não esqueça de escapar as colunas - Senão vai dar erro sintático na hora de inserir

```php
foreach ($colunas as $coluna) {
    $nome = addslashes($coluna['nome']);
    $query = 'INSERT INTO tabela (id, nome) VALUES ' .
         "('{$coluna['id']}', \"{$nome}\")";
    $result = mysql_query($query) or die('Query failed insert tabela ' . $nome . ': ' . mysql_error()    );
}
```

E por fim, não se esqueça de testar antes, pois é bem provável que dê erro. Não faça direto na tabela de produção. E é sempre bom manter um backup ([veja como aqui]({% post_url pt_br/2014-03-10-exportar-importar-banco-de-dados-mysql-ubuntu %})).
