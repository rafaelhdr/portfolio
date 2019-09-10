---
layout: post
title:  "Starting with Docker"
date:   2019-08-28 08:00:00 -0300
categories: docker run
permalink: blog/starting-with-docker
lang: en
---
# Starting with Docker

In this post, I will explain a bit how to start using Docker. I will explain a bit about the `run` command and some tricks.

## Run

This command is to run a container with an existent image.

If you want to run a Ubuntu image locally, you just have to run `docker run ubuntu`.

```
$ docker run -it ubuntu
root@aacdec8ea1e8:/# echo test
test
root@aacdec8ea1e8:/#
```

The first line (`docker run -it ubuntu`) ran in my host (my OS, no container).
The second line (`echo test`) was in my Ubuntu container.

P.S.: The `-it` flag is for attaching your terminal to the container (see what is happening in the container).

We could have used different images (debian, centos, python...). In the [Docker Hub](https://hub.docker.com/) you can see a lot of different images.

### Change the version

It is also possible to use a different version of Ubuntu. We just have to tag with a different version.

We could use Ubuntu 19.04 with the command `docker run ubuntu:19.04`.

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

By default, it uses the `latest`. To run `docker run ubuntu` is the same as running `docker run ubuntu:latest`. Today, the `latest` is the same as `18.04`. In the next LTS release it will be changed to the `20.04`.

### Change the default command

Each image has a default command to run. When we run `docker run -it ubuntu`, it automatically runs the `bash` command. When we run a python image, it runs the `python` command.

```
$ docker run --rm -it python
Python 3.7.4 (default, Aug 14 2019, 12:09:51)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print('hello')
hello
```

You can change the default command. For example, if you want to something before running the default command.

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

### Connect from a different terminal

Let's run a server in one terminal and create files in a different one.

Terminal 1

```
$ docker run -it -p 8000:8000 python bash
root@1e171a55d01f:/# python -m http.server 8000
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

P.S.: The args `-p 8000:8000` are to redirect your host port 8000 to the container port 8000.

Terminal 2

Run the `ps` command to get the container ID and use this ID to connect using the `exec` command.

```
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                              NAMES
1e171a55d01f        python                 "bash"                   42 seconds ago      Up 41 seconds       0.0.0.0:8000->8000/tcp                             stupefied_heyrovsky

$ docker exec -it 1e171a55d01f bash
root@1e171a55d01f:/# ls
bin  boot  dev	etc  home  lib	lib64  media  mnt  opt	proc  root  run  sbin  srv  sys  tmp  usr  var
root@1e171a55d01f:/# echo 'My site' > index.html
```

If you go to [localhost:8000](http://localhost:8000/) you will see a simple page just created.

![My site example]({{"/assets/posts/2019-08-28-starting-with-docker/my-site.png"}})

## Tips and Tricks

### Use the flag --rm

When you run these commands the containers are created but not deleted after you close those. In the end, you will have a lot of old containers.

You can check these containers running `docker ps -a`:

```
$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS                      PORTS                                              NAMES
1e171a55d01f        python                 "bash"                   10 minutes ago      Up 10 minutes               0.0.0.0:8000->8000/tcp                             stupefied_heyrovsky
6acfdb1bff1d        ubuntu                 "/bin/bash"              2 hours ago         Exited (0) 22 minutes ago                                                      cranky_booth
bc620ad9745b        ubuntu:19.04           "/bin/bash"              2 hours ago         Exited (0) 2 hours ago                                                         gracious_hopper
```

If you run `--rm` this will not happen. Example: `docker run -it --rm ubuntu`

### Clean the images

But you can also clean your images by running the `prune` command.

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

For now, this command has no problem because we didn't create many stuffs. You have to be careful to not delete anything important (if something important is running, it won't be deleted).

## Summary

These are just some basic tasks with docker. I hope you could understand a bit of it.

One possible thing to do is to connect 2 containers (for example, a PHP website and a database). I explained in [StackOverflow](https://stackoverflow.com/questions/43127599/connect-to-mysql-server-from-php-with-docker/43128428#43128428) how to do it.

It is interesting for learning, but I prefer using docker-compose for that.

Check the post of [docker-compose]({% post_url en/2019-09-09-learning-docker-compose %}).
