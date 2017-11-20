---
layout: post
title:  "Instalando o Zend Framework 2 no Ubuntu"
date:   2014-02-02 12:00:00 -0300
categories: php zend-framework2 ubuntu
permalink: blog/zf2/instalando-o-zend-framework-2-no-ubuntu
lang: pt_br
---
# Instale o Zend 2 no Ubuntu rodando com Apache

O Zend Framework é o mais popular dos frameworks em PHP. Eu busco usá-lo a fim de aprender melhores práticas de programação, além de deixá o código entendível para os próximos. Hoje vou explicar como instalá-lo no Ubuntu utilizando o Apache.

## Skeleton

Baixe o skeleton (esse é um esqueleto de pastas e arquivos organizado para criar sua primeira aplicação) usando o git pelo terminal.

```shell
git clone git://github.com/zendframework/ZendSkeletonApplication.git nomeDaAplicacao
```

Eu incrementei nomeDaAplicacao, que é para ele renomear a nova pasta criada para o nome que eu usarei na aplicação.

## Instalação

Mude de pasta, e rode o composer.

```shell
cd nomeDaAplicacao
php composer.phar install
```

Normalmente leva um tempo para ele instalar. Em seguida, rode em um virtualhost.

## Virtualhost

Virtualhost serve para você rodar localmente suas aplicações web. Para isso, será necessário mexer em algumas configurações. **Habilite o Rewrite no Apache**. Isso serve para que se possa redirecionar suas urls pelo .htaccess.

```shell
sudo a2enmod rewrite
```

Edite os virtualhosts Crie um novo arquivo em /etc/apache2/sites-available/nomeDaAplicacao, e configurá-lo. Sugiro copiar o default já existente, e alterar os dois AllowOverride None para AllowOverride All. Depois disso, colocar o ServerName com o nomeDaAplicacao. Segue um exemplo:

```lang-bsh
<VirtualHost *:80>
    ServerName nomeDaAplicacao
    ServerAdmin webmaster@localhost
    SetEnv APPLICATION_ENV "development"
    DocumentRoot /home/usuario/nomeDaAplicacao/public
    <Directory />
       Options FollowSymLinks
       AllowOverride All
    </Directory>
    <Directory /home/usuario/nomeDaAplicacao/public/>
       Options Indexes FollowSymLinks MultiViews
       AllowOverride All
       Order allow,deny
       allow from all
    </Directory>
    ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
    <Directory "/usr/lib/cgi-bin">
       AllowOverride None
       Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
       Order allow,deny
       Allow from all
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    # Possible values include: debug, info, notice, warn, error, crit,
    # alert, emerg.
    LogLevel warn
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
       Options Indexes MultiViews FollowSymLinks
       AllowOverride None
       Order deny,allow
       Deny from all
       Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
</VirtualHost>
```

Após criá-lo, basta criar um atalho nos sites-enabled, com o seguinte código:

```shell
ln -s /etc/apache2/sites-available/nomeDaAplicacao /etc/apache2/sites-enabled/nomeDaAplicacao
```

**Redirecionando o host** Edite o arquivo /etc/hosts Basta copiar a linha de localhost, como a seguir

```none
127.0.0.1       localhost
127.0.0.1       nomeDaAplicacao
```

Reiniciar o Apache É necessário reiniciá-lo, para que se atualize das novas informações inseridas:

```shell
sudo service apache2 restart
```

Com isso, já é possível funcionar sua primeira aplicação ao abrir [http://nomeDaAplicacao](http://nomeDaAplicacao) e aparecer a seguinte tela de boas vindas:

![Tela inicial do Zend Framework 2]({{"/assets/posts/2014-02-01-instalando-o-zend-framework-2-no-ubuntu/zf2-initial-screen.png" | absolute_url }})

## Dicas

É interessante saber mexer com comandos do terminal (sudo, vi, cp, ln...) para agilizar na hora de editar esses arquivos. Mas caso não saiba, será necessário mexer em alguns arquivos como super usuário. Pra isso, abra o terminal (Ctrl + Alt + T), e execute o código:

```shell
sudo nautilus
```

Com isso, você pode usar o gerenciador de arquivos para edição.

Fontes:

* [http://framework.zend.com/downloads/skeleton-app](http://framework.zend.com/downloads/skeleton-app)
* [http://www.dscripts.net/2009/01/19/how-to-enable-mod-rewrite-in-apache-server/](http://www.dscripts.net/2009/01/19/how-to-enable-mod-rewrite-in-apache-server/)
