---
layout: post
title:  "Começando com Docker"
date:   2018-08-28 08:00:00 -0300
categories: docker run
permalink: blog/starting-with-docker
lang: pt_br
---
# Como fazer um PR

Nesse post, explicarei um pouco como usar o Docker. Basicamente, vou abordar o comando `run` a alguns truques.

## Run

Esse comando vai rodar um container com uma imagem já existente.

Se você quiser rodar o Ubuntu localmente, deve rodar apenas `docker run ubuntu`.

```
$ docker run -it ubuntu
root@aacdec8ea1e8:/# echo test
test
root@aacdec8ea1e8:/#
```

A primeira linha (`docker run -it ubuntu`) rodou no meu host (meu Sistema Operacional, não no container docker).
A segunda linha (`echo test`) rodou no container Ubuntu.

P.S.: A flag `-it` é para conectar o seu terminao com o container (para ver o que acontece dentro do container).

Poderiamos user outras imagens (debian, centos, python...). No [Docker Hub](https://hub.docker.com/) você pode encontrar diversas outras imagens.

### Usar outra versão

Também é possível usar diferentes versões do Ubuntu. Nós precisamos apenas usar uma tag diferente para a versão.

Podemos usar o Ubuntu 19.04 usando o comando `docker run ubuntu:19.04`.

```
$ docker run -it ubuntu:19.04
root@bc620ad9745b:/# cat /etc/*release | grep VERSION_ID
VERSION_ID="19.04"
root@bc620ad9745b:/# exit
exit
$ docker run -it ubuntu
root@6acfdb1bff1d:/# cat /etc/*release | grep VERSION_ID
VERSION_ID="18.04"
```

Por padrão, usa-se a tag `latest`, ou seja, rodar o comando `docker run ubuntu` é o mesmo que rodar `docker run ubuntu:latest`. Hoje, o `latest` é o mesmo que `18.04`. No lançamento do próximo Ubuntu LTS a versão latest será a `20.04`.

### Mudar o comando padrão

Cada imagem tem um comando padrão para rodar. Quando usamos `docker run -it ubuntu`, ele automaticamente roda `bash`. Mas quando usamos uma imagem python, ele roda o comando `python`.

```
$ docker run --rm -it python
Python 3.7.4 (default, Aug 14 2019, 12:09:51)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print('hello')
hello
```

Você pode mudar o comando padrão. Por exemplo, caso queira instalar algo antes do comando padrão.

```
$ docker run --rm -it python bash
root@1db1de2e11cc:/# pip install awscli
Collecting awscli
  Downloading https://files.pythonhosted.org/packages/97/72/bafa0c932416fb91c87f172cd4b0fdff5be32e4d01a3c89c8ae03549d7c3/awscli-1.16.229-py2.py3-none-any.whl (2.0MB)
     |████████████████████████████████| 2.0MB 2.2MB/s
...
Building wheels for collected packages: PyYAML
  Building wheel for PyYAML (setup.py) ... done
  Created wheel for PyYAML: filename=PyYAML-5.1.2-cp37-cp37m-linux_x86_64.whl size=468680 sha256=df0859d47787aaf4e7b2b2e1f5720ab061297d9b3c2519b32f5254217b77fd51
  Stored in directory: /root/.cache/pip/wheels/d9/45/dd/65f0b38450c47cf7e5312883deb97d065e030c5cca0a365030
Successfully built PyYAML
Installing collected packages: pyasn1, rsa, docutils, six, python-dateutil, urllib3, jmespath, botocore, s3transfer, colorama, PyYAML, awscli
Successfully installed PyYAML-5.1.2 awscli-1.16.229 botocore-1.12.219 colorama-0.3.9 docutils-0.15.2 jmespath-0.9.4 pyasn1-0.4.6 python-dateutil-2.8.0 rsa-3.4.2 s3transfer-0.2.1 six-1.12.0 urllib3-1.25.3
root@1db1de2e11cc:/# python
Python 3.7.4 (default, Aug 14 2019, 12:09:51)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import awscli
>>> # Do things with awscli
```

### Conectar de um terminal diferente

Vamos rodar o servidor em um terminal e criar arquivos em outro.

Terminal 1

```
$ docker run -it -p 8000:8000 python bash
root@1e171a55d01f:/# python -m http.server 8000
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

Terminal 2

Execute o comando `ps` para obter o container ID e se conectar ao container usando o comando `exec`.

```
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                              NAMES
1e171a55d01f        python                 "bash"                   42 seconds ago      Up 41 seconds       0.0.0.0:8000->8000/tcp                             stupefied_heyrovsky

$ docker exec -it 1e171a55d01f bash
root@1e171a55d01f:/# ls
bin  boot  dev	etc  home  lib	lib64  media  mnt  opt	proc  root  run  sbin  srv  sys  tmp  usr  var
root@1e171a55d01f:/# echo 'My site' > index.html
```

Se você acessar [localhost:8000](http://localhost:8000/) verá a página simples que acabou de ser criada.

![My site example]({{"/assets/posts/2019-08-28-starting-with-docker/my-site.png"}})

## Dicas

### Usar a flag --rm

Quando você roda esses comandos os containers são criados mas não apagados depois de utilizá-los. No fim, você terá diversos containers antigos ocupando espaço.

Você pode encontrar esses containers rodando `docker ps -a`.

```
$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS                      PORTS                                              NAMES
1e171a55d01f        python                 "bash"                   10 minutes ago      Up 10 minutes               0.0.0.0:8000->8000/tcp                             stupefied_heyrovsky
6acfdb1bff1d        ubuntu                 "/bin/bash"              2 hours ago         Exited (0) 22 minutes ago                                                      cranky_booth
bc620ad9745b        ubuntu:19.04           "/bin/bash"              2 hours ago         Exited (0) 2 hours ago                                                         gracious_hopper
```

Se você rodar a flag `--rm` isso não acontecerá. Por exemplo: `docker run -it --rm ubuntu`.

### Limpar Imagens

Você também pode limpar espaço rodando o comando `prune`.

```
$ docker system prune -a
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all images without at least one container associated to them
  - all build cache

Are you sure you want to continue? [y/N] y
...
```

Por agora, esse comando não tempo problema pois não criamos muitas coisas. Mas precisa tomar cuidado para não apagar nada importante (se por acaso algo importante estiver rodando, ele não será apagado).

## Resumo

Esse é apenas o básico de tarefas com o docker. Espero que você tenha entendido um pouco mais sobre ele.

Outra possibilidade é rodar 2 containers (por exemplo, um site PHP e um banco de dados). Eu expliquei no [StackOverflow](https://stackoverflow.com/questions/43127599/connect-to-mysql-server-from-php-with-docker/43128428#43128428) como fazer isso.

Isso é interessante para o aprendizado, mas eu prefiro usar o docker-compose para isso.

Mas isso será para outro post. Farei algo similar a esse sobre o `docker-compose`.
