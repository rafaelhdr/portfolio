---
layout: post
title:  "Trabalhando com senhas no PHP"
date:   2014-06-01 12:00:00 -0300
categories: php security
permalink: blog/php/trabalhando-com-senhas-no-php
lang: pt_br
excerpt: "Use password_hash com BCRYPT para gerar senhas seguras no PHP, evitando hashes fracos como MD5 ou SHA1."
---
# Trabalhando com senhas no PHP

Quando estiver fazendo seu site, é bem interessantes se preocupar bastante com a senha dos usuários. Se aplicar apenas um MD5, ou SHA1, você estará apenas fazendo um hash rápido, mas que não é seguro. Com isso, não será tão difícil de descobrirem a senha por força bruta.

O PHP já tem uma biblioteca preparada para isso, que vai auxiliar a criar senhas.

## Gerar Senha

Para gerar uma nova senha, utilize o password_hash

```php
$pw = password_hash($senha, PASSWORD_BCRYPT);
```

Esse comando irá gravar em $pw sua senha gerada com método de criptografia CRYPT_BLOWFISH (sim, ele é bem mais seguro que o MD5).

Agora com esse $pw, você pode salvá-lo em seu banco de dados com mais segurança (lembrando que ele vai se utilizar de 60 caracteres).

## Verificando a senha

Se precisar verificar se alguém preencheu a senha corretamente, utilize o password_verify

```php
$result = password_verify($senha, $pw);
```

Esse comando vai validar se $senha está correta. O segundo parâmetro $pw é a senha criptografada que você já salvou no Banco de Dados. $result será um booleano (verdadeiro ou falso).

## Aumentando a segurança

Você pode utilizar SALT para aumentar a dificuldade de descobrirem a senha utilizada. Você mesmo decide qual o o SALT (o PHP pede que tenha mais de 22 caracteres). Utilize-o na hora de gerar a senha.

```php
$options = array('salt' => 'dsankasknsdajsdajkdsansdaknasdjksadjsand');
echo $pw1 = password_hash($senha, PASSWORD_BCRYPT, $options);
```

Além do SALT, você pode também aumentar a complexidade do algoritmo. Eu particularmente já gosto do valor padrão, que é 10, mas você pode ajustar como achar melhor.

```php
$options = array('salt' => 'dsankasknsdajsdajkdsansdaknasdjksadjsand', 'cost' => 15);
echo $pw1 = password_hash($senha, PASSWORD_BCRYPT, $options);
```

Espero ter ajudado. Qualquer dúvida, fique à vontade para postar nos comentários :)
