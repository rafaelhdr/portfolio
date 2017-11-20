---
layout: post
title:  "Retornar Json com ZF2"
date:   2014-02-04 12:00:00 -0300
categories: php zend-framework2 json
permalink: blog/zf2/retornar-json-com-zf2
lang: pt_br
---
# JSON com o ZF2

Em muitos momentos, é interessante de retornarmos resultados em formato json. Eu costumo utilizar isso quando preciso puxar dados do servidor (normalmente utilizando JQuery). Vou então explicar como gerar resultados em json para isso. O processo é bem simples, e vou dividí-lo em 2 passos:

## Configurar o module.config

Nas configurações do seu módulo, incremente dizendo que retornaremos Json. Basta adicionar o trecho `strategies` do código abaixo:

```php
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => array(
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'application/index/index' => __DIR__ . '/../view/application/index/index.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ),
        'template_path_stack' => array(
            __DIR__ . '/../view',
        ),
        'strategies' => array(
            'ViewJsonStrategy',
        ),
    ),
```

## Gere o resultado no controller

Crie a rota corretamente em seu **module.config.php**.

```php
            'test' => array(
                'type' => 'Zend\Mvc\Router\Http\Literal',
                'options' => array(
                    'route'    => '/test',
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'test',
                    ),
                ),
            ),
```

Em seguida, basta criar uma action que retorne Json:

```php
    public function testAction() {
        $dados = array('dado' => 'valor');
        return new JsonModel($dados);
    }
```

Por fim, no próprio controller, não pode esquecer de colocar a dependência (Json Model):

```php
use Zend\View\Model\JsonModel;
```

E com isso, já retornamos um resultado simples de Json. Seria necessário trabalhar melhor com o Controller para que você processe os dados e traga algo útil para os usuários.

Fonte:

* [http://akrabat.com/zend-framework-2/returning-json-from-a-zf2-controller-action/](http://akrabat.com/zend-framework-2/returning-json-from-a-zf2-controller-action/)
