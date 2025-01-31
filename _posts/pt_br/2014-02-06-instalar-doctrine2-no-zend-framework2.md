---
layout: post
title:  "Instalar o Doctrine 2 no Zend Framework 2"
date:   2014-02-06 12:00:00 -0300
categories: php doctrine2
permalink: blog/zf2/instalar-doctrine2-no-zend-framework2
lang: pt_br
---
# Ubuntu com Doctrine 2 no Zend Framework 2

O Doctrine é uma biblioteca PHP utilizada para facilitar os serviços com o banco de dados. É possível criar o site sem isso, tanto que eu não a utilizava antes, mas após conhecê-la, vi que há muita coisa boa para usar e evitar trabalho. Assim meu código passou a ficar mais simples e entendível. Esse tutorial servirá para explicar como instalar o Doctrine no ZF2. Primeiro é necessário instalar o [Zend Framework 2: Instalando o Zend Framework 2 no Ubuntu]({% post_url pt_br/2014-02-02-instalando-o-zend-framework-2-no-ubuntu %}).

## Composer.json

Edite o composer.phar para que ele busque os módulos do Doctrine. É necessário mudar os requerimentos:

```json
{
    "name": "zendframework/skeleton-application",
    "description": "Skeleton Application for ZF2",
    "license": "BSD-3-Clause",
    "keywords": [
        "framework",
        "zf2"
    ],
    "homepage": "http://framework.zend.com/",
    "require": {
        "php": ">=5.3.3",
        "zendframework/zendframework": "2.*",
        "doctrine/doctrine-orm-module": "0.*"
    }
}
```

Em seguida, basta rodar o comando para instalar novamente.

```shell
php composer.phar update
```

## Configuração

Agora é necessário "avisar" o sistema dos novos módulos. Edite o arquivo config/application.config.php Será necessário acrescentar os módulos 'DoctrineModule' e 'DoctrineORMModule'.

```php
<?php return array(     'modules' => array(
        'Application',
        'DoctrineModule',
        'DoctrineORMModule'
    ),
    'module_listener_options' => array(
        'config_glob_paths'    => array(
            'config/autoload/{,*.}{global,local}.php',
        ),
        'module_paths' => array(
            './module',
            './vendor',
        ),
    ),
);
```

E além disso, configurar as informações locais (config/autoload/local.php) preenchendo com as informações de seu banco de dados.

```php
<?php return array(
     // ...
     'doctrine' => array(
        'connection' => array(
            'orm_default' => array(
                'driverClass' => 'Doctrine\DBAL\Driver\PDOMySql\Driver',
                'params' => array(
                    'host'     => 'localhost',
                    'port'     => '3306',
                    'user'     => 'preencher',
                    'password' => 'preencher',
                    'dbname'   => 'preencher',
                )
            )
        )
    ),
);
```

##  module.config.php

Para seus módulos funcionarem, é necessário colocar namespace nos arquivos de configuração de módulo. Vamos testar com o Application. Edite /module/Application/config/module.config.php

```php
<?php
namespace Application;
...
```

E no final desse mesmo arquivo, coloque o seguinte: (como último elemento do array)

```php
//........
// Conteúdo novo
// Doctrine config
    'doctrine' => array(
        'driver' => array(
            __NAMESPACE__ . '_driver' => array(
                'class' => 'Doctrine\ORM\Mapping\Driver\AnnotationDriver',
                'cache' => 'array',
                'paths' => array(__DIR__ . '/../src/' . __NAMESPACE__ . '/Entity')
            ),
            'orm_default' => array(
                'drivers' => array(
                    __NAMESPACE__ . '\Entity' => __NAMESPACE__ . '_driver'
                )
            )
        )
    ),
// Fim do conteúdo novo
//........
);
```

E com apenas isso, já é possível utilizar o Doctrine. Vamos testar ver se funcionou.

## Testando

Para verificar se instalamos direito, vamos rodar um comando:

```php
php public/index.php
```

E então deve aparecer algo semelhante ao abaixo:

```none
Zend Framework 2.4.0dev application
Usage:
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DoctrineModule
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DoctrineModule Command Line Interface version 0.8.0
(continua)
```

Se não funcionou, deixe nos comentário para irmos se ajudando :)

Quer mexer mais? Veja o [básico do Doctrine2 no ZF2]({% post_url pt_br/2014-08-24-basico-do-doctrine2-no-zf2 %}).

Fonte:

* [http://www.jasongrimes.org/2012/01/using-doctrine-2-in-zend-framework-2/](http://www.jasongrimes.org/2012/01/using-doctrine-2-in-zend-framework-2/)
