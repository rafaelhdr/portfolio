---
layout: post
title:  "Banco de Dados Cassandra com Python no Ubuntu"
date:   2016-01-03 22:00:00 -0300
categories: ubuntu cassandra db
permalink: blog/cassandra/bd-cassandra-com-python-no-ubuntu
lang: pt_br
---
# Banco de Dados Cassandra com Python no Ubuntu

Esses são apenas os primeiros passos para quem estiver interessado em começar a aprender sobre o Banco de Dados Cassandra.

## Sobre o Cassandra

O Cassandra é um Banco de Dados NoSQL (Not Only SQL). Ele é utilizado principalmente para grande quantidade de dados, de forma que possa ser replicado e escalado linearmente, de acordo com o seu uso. Para saber um pouco mais, leia aqui: [Tutorial Point](http://www.tutorialspoint.com/cassandra/cassandra_introduction.htm)

Observação: Eu comecei seguindo esse tutorial, mas devido problemas, imaginei que ele estivesse um pouco desatualizado. Por isso, passei a ler de outros lugares. Mas acredito que os conceitos continuem os mesmos.

## Criando uma instância AWS EC2 (opcional)

Preferi utilizar instância EC2 da Amazon. O motivo, é facilidade de usar um sistema limpo, sem sobrecarregar meu computador atual.

Basta criar uma instância, seguindo os passos da Amazon (Utilizei o *Ubuntu Server 14.04 LTS (HVM)*). Acredito que seja um passo bem simples para quem utiliza a AWS (ou um outro, como Digital Ocean, ou Rackspace), mas se precisar de ajuda, basta deixar um comentário que preparo um tutorial para isso.

## Instalação

Basicamente, são 3 passos:

Instalar o Java
Adicionar o repositório do Cassandra
Instalar o Cassandra
Vamos do começo. Se conecte à sua instância via SSH. Em seguida, crie um arquivo chamado cassandra.sh. Dentro desse arquivo, coloque o seguinte conteúdo (aqui o gist):

```shell
# Install Cassandra on Ubuntu
# Source: https://www.digitalocean.com/community/tutorials/how-to-install-cassandra-and-run-a-single-node-cluster-on-ubuntu-14-04
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-set-default
echo "deb http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
echo "deb-src http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -
gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
gpg --export --armor 0353B12C | sudo apt-key add -
sudo apt-get update
sudo apt-get install cassandra
sudo reboot
# For me, worked fine. Maybe, it is necessary edit /etc/init.d/cassandra
# (check the source)
# Run with: cqlsh
```

Em seguida, rode o comando desse arquivo com:

```shell
sh cassandra.sh
```

E pronto. Você já pode utilizá-lo. Vamos rodar alguns comandos iniciais. Conecte-se ao Cassandra com:

```shell
cqlsh
```

Agora, você está interagindo com ele (da mesma forma que fazemos com o MySQL).

Vamos criar um keyspace (semelhante a um DATABASE do MySQL):

```sql
CREATE KEYSPACE mykeyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};
```

Para esse exemplo, estamos usando SimpleStrategy. Em ambientes de produção, provavelmente utilizaremos NetworkTopologyStrategy (veja mais aqui). Certo, agora vamos utilizar esse keyspace que acabamos de criar:

```sql
USE mykeyspace;
```

Isso mesmo. Bem semelhante com o MySQL. Dentro dele, vamos criar uma tabela de usuários (users):

```sql
CREATE TABLE users ( firstname text, lastname text, age int, PRIMARY KEY (lastname));
```

Criamos nossa tabela, com apenas 3 campos, sendo o lastname o primary key. Através dele que faremos nossas buscas. Inserimos as informações nele assim:

```sql
INSERT INTO users (firstname, lastname, age) VALUES ('John', 'Smith', 46);
INSERT INTO users (firstname, lastname, age) VALUES ('Jane', 'Doe', 36);
```

E agora, quando fizérmos o SELECT:

```sql
SELECT * FROM users;
```

Teremos o seguinte resultado:

```none
 lastname | age | firstname
----------+-----+-----------
      Doe |  36 |      Jane
    Smith |  46 |      John
```

Ou então, podemos filtrar:

```sql
SELECT * FROM users WHERE lastname='Smith';
```

Resultando em:

```none
 lastname | age | firstname
----------+-----+-----------
    Smith |  46 |      John
```

Pois é. Também achei bastante parecido com o MySQL. O que é bom, facilitando a aprendizagem. Mas agora, vamos utilizar o python para se conectar e executar comandos simples.

## Python e Cassandra

Tenha o python com virtualenv instalado (se precisar de ajuda, utilize esse [gist](https://gist.github.com/rafaelhdr/f466b1a64f9180f53a9e)).

Em seguida, vamos criar um virtualenv para trabalhar:

```shell
virtualenv myenv
source myenv/bin/activate
pip install cassandra-driver
python
```

E pronto. Agora você está no ambiente de execução do python, utilizando o Cassandra. Vamos rodar alguns comandos simples.

Primeiro, vamos inicializar:

```python
from cassandra.cluster import Cluster
cluster = Cluster()
session = cluster.connect('mykeyspace')
```

Estamos conectados em nosso keyspace. Agora, vamos inserir uma linha:

```python
session.execute(
    """
    INSERT INTO users (firstname, lastname, age)
    VALUES (%s, %s, %s)
    """,
    ('Ted', 'Mosby', 37)
)
```

Por fim, para checar se funcionou, fazemos o SELECT:

```python
rows = session.execute('SELECT firstname, lastname, age FROM users')
for user_row in rows:
    print user_row.firstname, user_row.lastname, user_row.age
```

Como resultado, espera-se:

```none
Ted Mosby 37
Jane Doe 36
John Smith 46
```

## Conclusão

Esse é o fim. Serve apenas como um guia inicial (e bem inicial) para não perder tempo na instalação e conceitos iniciais. Para continuar, sugiro utilizar a documentação do [driver python cassandra](http://datastax.github.io/python-driver/getting_started.html). Com ele, verá como atualizar e apagar dados.

Espero ter ajudado, e qualquer dúvida poste nos comentários. Obrigado.
