---
layout: post
title:  "Básico do Doctrine 2 no ZF2"
date:   2014-08-24 12:00:00 -0300
categories: php doctrine2
permalink: blog/zf2/basico-do-doctrine2-no-zf2
lang: pt_br
excerpt: "Aprenda o básico do Doctrine 2 no ZF2 criando entidades e operações CRUD simples com o ORM."
---
# Veja o básico do Doctrine 2 no ZF2

Esse post é continuação do [Post de instalação do Doctrine 2 no ZF2]({% post_url pt_br/2014-02-06-instalar-doctrine2-no-zend-framework2 %}). Agora faremos um CRUD simples.

## Preparação

Antes de iniciar, apenas crie uma tabela nova com o seguinte código:

```mysql
CREATE TABLE `content` (
    `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `content` varchar(100) NOT NULL
) COMMENT='';
```

Depois disso, prepare um Entity de conteúdo para a tabela acima. Copie o código abaixo em ~/module/Application/src/Application/Entity/Content.php

```php
<?php
namespace Application\Entity;
use Doctrine\ORM\Mapping as ORM;
/**
 * Content
 *
 * @ORM\Table(name="content")
 * @ORM\Entity
 */
class Content {
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer", nullable=false)
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    private $id;
    /**
     * @var string
     *
     * @ORM\Column(name="content", type="string", length=127, nullable=false)
     */
    private $content;
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->id = $id;
        return $this;
    }
    public function getContent() {
        return $this->content;
    }
    public function setContent($content) {
        $this->content = $content;
        return $this;
    }
}
```

Esse código é o seu **Modelo** da entidade que criamos. Veja que ele é bem simples, e já possui informações suficientes para trocar informações com o banco de dados, que no caso é de uma tabela com apenas dois campos (id e content).

Nos próximos passos, vamos fazer o CRUD aos poucos. Será tudo em uma só página, apenas para fins didáticos.

## Adicionar

Create, do CRUD, vamos inserir conteúdos na nossa tabela. Vamos começar com a página de inserção (~/module/Application/view/application/index/index.phtml):

```html
<div class="row">
    <div class="col-md-12">
        <form class="form-horizontal" method="POST">
            <input type="hidden" name="action" value="insert" />
            <fieldset>
                <!-- Form Name -->
                <legend>Adicionar conteúdo</legend>
                <!-- Textarea -->
                <div class="form-group">
                    <label class="col-md-12 control-label" for="content">Text Area</label>
                    <div class="col-md-12">                     
                        <textarea class="form-control" id="content" name="content"></textarea>
                    </div>
                </div>
                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-12 control-label" for="insert"></label>
                    <div class="col-md-12">
                        <button id="insert" name="insert" class="btn btn-primary">Novo</button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</div>
```

De importante, temos um formulário, nossa action de inserir (para diferenciar quando formos atualizar), a informação de conteúdo e o botão. Você já deve visualizar a seguinte página:

![CRUD add]({{"/assets/posts/2014-08-24-basico-do-doctrine2-no-zf2/rafaelhdr-crud-add.png" | absolute_url }})

Porém, isso ainda não funciona. Vamos preparar nosso controller. Altere o indexAction do controller já existente (~/module/Application/src/Application/Controller/IndexController.php) para o seguinte:

```php
class IndexController extends AbstractActionController
{
    public function indexAction()
    {
        if ($this->getRequest()->isPost()) {
            $data = $this->params()->fromPost();
            // Add
            if ($data['action'] == 'insert') {
                // New
                $entity = new Content();
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
        }
        return new ViewModel();
    }
    protected function getEm() {
        if (null === $this->em)
            $this->em = $this->getServiceLocator()->get('Doctrine\ORM\EntityManager');
        return $this->em;
    }
}
```

A função getEm() busca o serviço do Doctrine2. Você vai utilizar muito, então já deixo pronta com a protected function. E para adicionar, basta criar um novo objeto, e inserí-lo com o Doctrine (primeiro persiste na base de dados, e depois executa com o flush).

E pronto. Já funciona o insert (verifique no Banco de Dados se inseriu, ou avance para o próximo passo).

## Visualizar

Para visualizar, vamos buscar todos os resultados do BD. Vamos fazer 2 coisinhas.

Faça com que o controller retorne todos os conteúdos (edite o IndexAction):

```php
    public function indexAction()
    {
        $vars = array();
        if ($this->getRequest()->isPost()) {
            $data = $this->params()->fromPost();
            // Add
            if ($data['action'] == 'insert') {
                // New
                $entity = new Content();
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
        }
        // List
        $contents = $this->getEm()->getRepository('Application\Entity\Content')->findAll();
        $vars['contents'] = $contents;
        return new ViewModel($vars);
    }
```

E faça com que apareça nas views com o seguinte:

```php
<!-- Abaixo do formulário de adicionar -->
<div class="row">
    <?php foreach ($contents as $content) : ?>
        <div class="col-md-12">
            <p><?php echo $content->getContent(); ?></p>
        </div>
    <?php endforeach; ?>
</div>
```

E se tudo funcionou, logo abaixo do formulário você visualiza o que já inseriu no BD:

![CRUD list]({{"/assets/posts/2014-08-24-basico-do-doctrine2-no-zf2/rafaelhdr-list.png" | absolute_url }})

## Editar

Agora vamos editar os dados. Vou criar um formulário para cada um dos resultados. Assim, vou editar a view. Apague o que antes era:

```php
<!-- Abaixo do formulário de adicionar -->
<div class="row">
    <?php foreach ($contents as $content) : ?>
        <div class="col-md-12">
            <p><?php echo $content->getContent(); ?></p>
        </div>
    <?php endforeach; ?>
</div>
```

Agora isso irá virar:

```php
<div class="row">
    <?php foreach ($contents as $content) : ?>
        <hr />
        <div class="col-md-12">
            <form class="form-horizontal" method="POST">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="<?php echo $content->getId(); ?>" />
                <fieldset>
                    <!-- Form Name -->
                    <legend>Editar conteúdo <?php echo $content->getId(); ?></legend>
                    <p><?php echo $content->getContent(); ?></p>
                    <!-- Textarea -->
                    <div class="form-group">
                        <div class="col-md-12">                     
                            <textarea class="form-control" id="content" name="content"><?php echo $content->getContent(); ?></textarea>
                        </div>
                    </div>
                    <!-- Button -->
                    <div class="form-group">
                        <label class="col-md-12 control-label" for="insert"></label>
                        <div class="col-md-12">
                            <button id="insert" name="insert" class="btn btn-primary">Editar</button>
                        </div>
                    </div>
                </fieldset>
            </form>
        </div>
    <?php endforeach; ?>
</div>
```

O formulário tem 2 diferenças principais. O action, que agora é update, e um campo do id que desejamos editar.

Por fim, vamos editar nosso controller, adicionando a opção de update:

```php
    public function indexAction()
    {
        $vars = array();
        if ($this->getRequest()->isPost()) {
            $data = $this->params()->fromPost();
            // Add
            if ($data['action'] == 'insert') {
                // New
                $entity = new Content();
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
            // Update
            if ($data['action'] == 'update') {
                $entity = $this->getEm()->getRepository('Application\Entity\Content')->find($data['id']);
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
        }
        // List
        $contents = $this->getEm()->getRepository('Application\Entity\Content')->findAll();
        $vars['contents'] = $contents;
        return new ViewModel($vars);
    }
```

E com isso, você já pode editar seus dados.

![CRUD update]({{"/assets/posts/2014-08-24-basico-do-doctrine2-no-zf2/rafaelhdr-crud-update_1.png" | absolute_url }})

## Deletar

E agora, vamos terminar o CRUD com a deleção. Vamos criar um botão para isso na view.

```php
<div class="row">
    <?php foreach ($contents as $content) : ?>
        <hr />
        <div class="col-md-12">
            <form class="form-horizontal" method="POST">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="<?php echo $content->getId(); ?>" />
                <fieldset>
                    <!-- Form Name -->
                    <legend>Editar conteúdo <?php echo $content->getId(); ?></legend>
                    <p><?php echo $content->getContent(); ?></p>
                    <!-- Textarea -->
                    <div class="form-group">
                        <div class="col-md-12">                     
                            <textarea class="form-control" id="content" name="content"><?php echo $content->getContent(); ?></textarea>
                        </div>
                    </div>
                    <!-- Button -->
                    <div class="form-group">
                        <label class="col-md-12 control-label" for="insert"></label>
                        <div class="col-md-12">
                            <button id="insert" name="insert" class="btn btn-primary">Editar</button>
                        </div>
                    </div>
                </fieldset>
            </form>
            <form class="form-horizontal" method="POST">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="id" value="<?php echo $content->getId(); ?>" />
                <button class="btn btn-danger">Apagar</button>
            </form>
        </div>
    <?php endforeach; ?>
</div>
```

A única coisa que adicionei foi esse formulário para apagar (ok, sei que não precisava ter criado 2 forms, mas separado assim fica fácil de entender).

E para isso funcionar, terminemos nosso Controller:

```php
    public function indexAction()
    {
        $vars = array();
        if ($this->getRequest()->isPost()) {
            $data = $this->params()->fromPost();
            // Add
            if ($data['action'] == 'insert') {
                // New
                $entity = new Content();
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
            // Update
            if ($data['action'] == 'update') {
                $entity = $this->getEm()->getRepository('Application\Entity\Content')->find($data['id']);
                $entity->setContent($data['content']);
                // Persist
                $this->getEm()->persist($entity);
                $this->getEm()->flush();
            }
            // Delete
            if ($data['action'] == 'delete') {
                $entity = $this->getEm()->getReference('Application\Entity\Content', $data['id']);
                // Remove
                $this->getEm()->remove($entity);
                $this->getEm()->flush();
            }
        }
        // List
        $contents = $this->getEm()->getRepository('Application\Entity\Content')->findAll();
        $vars['contents'] = $contents;
        return new ViewModel($vars);
    }
```

E incluímos como remover. Percebeu que agora usamos o getReference, ao invés do find? Isso é mais prático, para não precisar fazer uma busca no BD antes de deletar (isso poderia ser feito com o update também).

## Fim

Apenas tarefas básicas, mas poderosas. Espero que tenham gostado, e qualquer problema deixem nos comentários :)
