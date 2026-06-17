---
layout: post
title:  "Como conectar o MySQL WorkBench com o AWS RDS"
date:   2015-08-26 21:52:00 -0300
categories: mysql workbench aws rds
permalink: blog/mysql/como-conectar-o-mysql-workbench-com-o-aws-rds
lang: pt_br
excerpt: "Conecte o MySQL Workbench ao AWS RDS verificando conectividade via terminal e configurando parâmetros de conexão."
---
# Como conectar o MySQL WorkBench com o AWS RDS

O MySQL WorkBench é ótimo para mexer na estrutura de banco de dados. Eu gosto bastante, pois ele mostra de forma visual relacionamentos que não vemos por outras ferramentas, como o phpmyadmin.

Hoje vou explicar como fazer para trabalhar com o MySQL WorkBench se conectando com um banco de dados da Amazon (AWS RDS).

[Se estiver começando com o MySQL Workbench, fiz um post com o básico para começar a aprender.]({% post_url pt_br/2014-02-16-primeiros-passos-com-mysql-workbench %})

## Verifique sua conectividade

Mas antes de começar, verifique se você consegue se conectar com o RDS. Isso porque é normal haver restrição de IP de acesso. Para checar se está conseguindo se conectar, execute o comando:

```mysql
mysql -h workbench.ccnemkb1xfri.us-west-2.rds.amazonaws.com -u workbench -p
```

-h Para você escolher o host que está se conectando *

-u para o nome de usuário que você escolheu quando criou o seu banco de dados

-p para colocar a senha que você escolheu

\* Se não souber o host, basta ir nas suas instâncias de RDS, e procurar o seguinte:

![aws rds endpoint]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds.png" | absolute_url }})

Se você conseguiu se conectar sem problemas, então pule o próximo passo.

## Configurando acesso do RDS

Você precisa acessar o Security Group de sua instância. Basta clicar no link ao lado de Security Group, como no print abaixo.

![aws rds security group]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-2.png" | absolute_url }})

E nessa próxima janela é mais simples. Clique no seu Security Group (haverá apenas um) e abra o Inbound para seu IP (ou então para qualquer IP, como eu fiz abaixo). Basta clicar em Inbound, e depois em Edit.

![aws rds edit]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-3.png" | absolute_url }})

## Finalmente com o WorkBench

Agora vamos trabalhar com o WorkBench. Essa é a parte mais fácil.

Vamos primeiro criar um conexão com o RDS. Para isso, clique no + ao lado de MySQL Connections.

![aws rds mysql workbench connect]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-4.png" | absolute_url }})

Na nova janela que aparece, você irá precisar mexer em poucos dados.

![mysql workbench configure]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-5.png" | absolute_url }})

**Connection name:** Dê um nome qualquer que você ache melhor para identificar sua instância.
**Host name:** O mesmo hostname que utilizamos lá em cima (em Verifique sua conectividade)
**Username:** O username que você escolheu ao criar a instância RDS.

E pronto. Tudo configurado. Se voltar para a tela inicial, e clicar em sua nova conexão, será apenas pedido a senha, e estará conectado.

## Teste

Se você já está confiante, pronto. Use o MySQL que já está conectado.

Se quer ter certeza se funcionou, então vamos fazer um teste. Vou utilizar o sakila, que já vem com o WorkBench.

![mysql workbench novo]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-6.png" | absolute_url }})

Nessa nova janela, clique em **Database > Syncronize model**.

![mysql workbench diagrama]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-7.png" | absolute_url }})

Selecione a conexão que acabamos de criar (no meu caso AWS RDS) que ele preencherá sozinho.

![mysql workbench connect]({{"/assets/posts/2015-08-26-como-conectar-o-mysql-workbench-com-o-aws-rds/tutorial-workbench-aws-rds-8.png" | absolute_url }})

E pronto. Fique avançando um monte de vezes, e então você atualizará sua nova tabela armazenada no AWS.
