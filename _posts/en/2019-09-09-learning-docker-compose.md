---
layout: post
title:  "Learning docker compose"
date:   2019-09-09 08:00:00 -0300
categories: docker compose
permalink: blog/learning-docker-compose
lang: en
excerpt: "Builds a Flask + MariaDB application with docker-compose, explaining services, networks, volumes, and multi-container orchestration."
---
# Learning docker compose

In this post, I will explain how to do a simple application using docker-compose. It will be a Flask web application accessing a MariaDB database.

It will be simple, without data or any migration with the database. The focus in this post is to understand the docker-compose.

## Flask application

I will use Flask to make a simple small application. It will have 2 endpoints. One is a "hello" static message and the other do a simple request to the database.

The structure will be the following:

```
├── application
│   ├── Dockerfile
│   └── src
│       ├── app.py
│       └── requirements.txt
└── docker-compose.yml
```

- *Dockerfile* contains our image code.
- *app.py* is our application.
- *requirements.txt* have all packages required by our application.
- *docker-compose.yml* orchestrate our two services (application and the database).

The example code is hosted in [GitLab](https://gitlab.com/rafaelhdr/docker-compose-example)

### app.py

Our application will have these 2 endpoints: `/` and `/db`.

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

The application uses the first examples found for flask and pymysql.

The `/` endpoint is just printing a simple text and `/db` is connecting to the server and getting the version.

### requirements.txt

```txt
Flask==1.1.1
PyMySQL==0.9.3
```

This file only contains the project dependencies.

### Dockerfile

The Dockerfile has comments to help understand what it is doing. It is copying the `src` code to the image, installing the requirements and setting the startup command.

```Dockerfile
FROM python:3.7

# Copy full application to the image
# For real environments, consider customize .dockerignore
COPY src /opt/application

# This is to make it easier. The default PWD where you
# start when using your application
WORKDIR /opt/application

RUN pip install -r requirements.txt

# Run default flask, but allow remote access
CMD flask run --host=0.0.0.0
```

### docker-compose.yml

This file will list our services and define how it integrates.

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

For the database service, we are setting the image used and the environment variables that should be used. We don't need modifications on it.

But we do need modifications in our application (described in our Dockerfile).

- `build: application` defines where our Dockerfile is located. It will create an image based on it.
- `links:` is a list of the connections between the services. Our application needs to connect to the database.
- `ports:` is a list of the ports open to your host (your computer). In the example, if I access `localhost:5000` at my local browser it will respond from the `localhost:5000` of the container.
- `environment:` is a list of all the environment variables passed to the container.
- `volumes:` is the list of volumes used. Here, I am mounting the source code in the container image. The reason for that is because I did it as a development environment. If I change it in my host, it will change in the container, too. It reloads in flask also because of my env var `FLASK_DEBUG: "1"`.

## Running

With all files there, you just need to run `docker-compose up`.

Static page

![application]({{"/assets/posts/2019-09-05-learning-docker-compose/application.png"}})

Page requesting to the database

![database]({{"/assets/posts/2019-09-05-learning-docker-compose/database.png"}})

## Some tricks

### Run in background

You can run `docker-compose up -d`. So, your terminal is not locked to the docker. If you want to see the logs, just run `docker-compose logs` (to see all logs), `docker-compose logs -f` (to see messages and follow the output) or `docker-compose logs application` (to filter the logs of a service).

### Compose network

Not sure if you realized that, but we didn't need to map the database host. Docker already created an internal network and mapped properly.

It happened because we linked the database:

```
    links:
      - database
```

And we used the same name in the database hostname in the application.

```
host='database',
```

### Debug container

You can also connect to the container to inspect it. You can run `docker-compose exec application bash`.

### Change ports

You don't need to be using port 5000 in your host. You can set a different one in any of those. (e.g. in `docker-compose.yml` file, could change to `8000:5000`)

### Changing the Dockerfile

If you make changes that affect the image, you will need to re-build the image.

For example, if you start the project (`docker-compose up`) and update the `requirements.txt`.

You can do that running `docker-compose build`.
