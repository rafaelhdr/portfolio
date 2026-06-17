---
layout: post
title:  "Learning docker compose"
date:   2019-09-09 08:00:00 -0300
categories: docker compose
permalink: blog/learning-docker-compose
lang: pt_br
excerpt: "Ensina docker-compose criando do zero uma aplicação web Flask com banco de dados MariaDB."
---
# Aprendendo docker compose

Nesse post, vou explicar um pouco como fazer uma aplicação simples usando docker-compose. Farei uma aplicação web com Flask utilizando banco de dados MariaDB.

Ela será simples, sem dados ou algum migration com o banco de dados. O foco do post será entender o docker-compose.

## Aplicação Flask

Usarei o Flask para essa aplicação simples. Ela terá apenas 2 endpoints. Um será apenas uma mensagem estática e o outro fará uma requisição para o banco de dados.

A estrutura será a seguinte:

```
├── application
│   ├── Dockerfile
│   └── src
│       ├── app.py
│       └── requirements.txt
└── docker-compose.yml
```

- *Dockerfile* contém a nossa imagem Docker.
- *app.py* é a nossa aplicação.
- *requirements.txt* contém as dependências do nosso projeto.
- *docker-compose.yml* é para orquestrar os nossos serviços (a aplicação e o banco de dados).

O código de exemplo está no [GitLab](https://gitlab.com/rafaelhdr/docker-compose-example)

### app.py

Nossa aplicação possui esses 2 endpoints: `/` e `/db`.

```python
import os
import pymysql.cursors
from flask import Flask


connection = pymysql.connect(host='database',
                             user=os.getenv('MYSQL_USER'),
                             password=os.getenv('MYSQL_PASSWORD'),
                             db='application_db',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

app = Flask(__name__)


@app.route('/')
def hello():
    return f'Application /'


@app.route('/db')
def db():
    cur = connection.cursor()
    cur.execute("SELECT VERSION() AS db_version")

    version = cur.fetchone()

    return (f'Database /db<br />\n'
            f'Version of database: {version["db_version"]}')
```

A aplicação usa os primeiros exemplos que encontrei para flaks e pymysql.

O endpoint `/` é apenas para imprimir um texto simples e `/db` se conecta ao banco de dados e escreve a versão.

### requirements.txt

```txt
Flask==1.1.1
PyMySQL==0.9.3
```

Esse arquivo contém as dependências do projeto.

### Dockerfile

O Dockerfile tem comentários para ajudar a entender o que ele está fazendo. Ele está copiando a pasta `src` para a imagem, instalando os requerimentos e definindo o comando para inicializar.

```Dockerfile
FROM python:3.7

# Copy full application to the image
# For real environments, consider customize .dockerignore
COPY src /opt/application

# This is to make it easier. The defaul PWD where you
# start when using your application
WORKDIR /opt/application

RUN pip install -r requirements.txt

# Run default flask, but allow remote access
CMD flask run --host=0.0.0.0
```

### docker-compose.yml

Esse arquivo vai listar os serviços e suas variáveis.

```yaml
version: "3.7"

services:
  application:
    build: application
    links:
      - database
    ports:
      - "5000:5000"
    environment:
      FLASK_DEBUG: "1"
      MYSQL_USER: "application"
      MYSQL_PASSWORD: "password"
      MYSQL_DATABASE: "application_db"
    volumes:
      - ./application/src:/opt/application

  database:
    image: mariadb:10.4
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      MYSQL_DATABASE: "application_db"
      MYSQL_USER: "application"
      MYSQL_PASSWORD: "password"
```

O serviço de banco de dados está definindo a imagem a ser utilizada e as variáveis de ambiente. Nós não fazemos modificações na imagem.

Mas nossa aplicação precisa de customização (definida em nosso Dockerfile).

- `build: application` define onde o nosso Dockerfile está. Nossa imagem será criada com base nele.
- `links:` é a lista de conexões entre nossos serviços. Nossa aplicação precisa se conectar ao banco de dados.
- `ports:` é a lista de portas conectadas com o host (seu computador). Nesse exemplo, se acessar `localhost:5000` no meu navegador local, ele irá responder com o `localhost:5000` do container.
- `environment:` é a lista com a variáveis de ambiente passadas para o container.
- `volumes:` é a lista de volumes utilizados. Aqui, estou montando o código-fonte na imagem. A razão para isso é que se eu realizar mudanças no host, elas serão atualizadas no container. Também porque configurei no flask `FLASK_DEBUG: "1"`.

## Rodando

Agora você precisa apenas rodar com o comando `docker-compose up`.

Página estática

![application]({{"/assets/posts/2019-09-05-learning-docker-compose/application.png"}})

Página fazendo conexão com o banco de dados

![database]({{"/assets/posts/2019-09-05-learning-docker-compose/database.png"}})

## Alguns truques

### Rodar em background

Para rodar em background basta adicionar uma flag `docker-compose up -d`. Seu terminal não estará preso ao docker. Se você quiser ver os logs, rode `docker-compose logs` (para ver todos os logs), `docker-compose logs -f` (para ver todos os logs e seguir os seguintes) ou `docker-compose logs application` (para filtrar os logs de um determinado serviço).

### Compose network

Não sei se você percebeu, mas não precisei mapear o hostname do banco de dados. O Docker já o criou para mim.

Isso aconteceu porque ligamos os serviços:

```
    links:
      - database
```

No caso, usamos o mesmo nome do serviço como db hostname da aplicação.

```
host='database',
```

### Debug container

Você também pode inspecionar o container roando o comando `docker-compose exec application bash`.

### Mudar portas

Você não precisa usar a porta 5000 de seu host. Você pode escoolher qualquer outra. (exemplo: no arquivo `docker-compose.yml`, você poderia mudar para `8000:5000`)

### Mudando o Dockerfile

Se você fizer mudanças que alterem a imagem gerada, será necessário build da imagem.

Por exemplo, se você começar seu projeto (`docker-compose up`) e depois atualizar o `requirements.txt`.

Você pode fazer isso rodando `docker-compose build`.
