---
layout: post
title:  "Deploy de aplicação hello world no Kubernetes GKE"
date:   2018-06-08 08:00:00 -0300
categories: docker kubernetes gke
permalink: blog/deploying-hello-world-application-to-gke
lang: pt_br
---
# Deploy de aplicação hello world no Kubernetes GKE

Esse tutorial é para deploy de uma aplicação simple no [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/).

Mas para começar, você precisa de:

* [gcloud](https://cloud.google.com/sdk/) linha de comando instalada e configurada
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) linha de comando instalada

É melhor se você já souber os básico de Docker. Eu criei uma imagem `rafaelhdr/server-hello` para isso. Essa imagem apenas responde `Hello, World!` para `GET /`.

## Crie o cluster

`gcloud container clusters create hello-cluster`

Esse comando irá criar seu cluster kubernetes. Depois de um tempo irá aparecer:

```shell
...
NAME           LOCATION       MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
hello-cluster  us-central1-a  1.8.10-gke.0    35.226.200.163  n1-standard-1  1.8.10-gke.0  3          RUNNING
```

## Deploy da aplicação

Nós temos nosso cluster mas nenhuma aplicação rodando. Veja com os comandos abaixo.

```shell
$ kubectl get deployment
No resources found.

$ kubectl get pods
No resources found.
```

Então vamos colocar nossa aplicação. Crie o arquivo de configuração `sh-service-lb.yaml`:

> Se quiser usar sua própria aplicação, mude **image** e **cointanerPort**.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: sh-deployment
  labels:
    app: sh-deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: sh-deployment
    spec:
      containers:
        - name: sh-deployment
          image: rafaelhdr/server-hello
          ports:
            - containerPort: 5000
```

Para deploy em nosso cluster, rode:

```shell
$ kubectl apply -f sh-deployment.yaml 
deployment.extensions "sh-deployment" created
```

Fizémos o deploy de nossa aplicação. Você pode checar rodando:

```shell
$ kubectl get deployment
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
sh-deployment   2         2         2            2           39s

$ kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
sh-deployment-6db6b8856d-q9j95   1/1       Running   0          53s
sh-deployment-6db6b8856d-tgmmh   1/1       Running   0          53s
```

**O que fizémos?** - Criamos duas replicas de nossa aplicação em nosso cluster (`replicas: 2`). É por isso que temos 2 pods e um deployment.

> **O que é um Pod?** É a menos unidade que colocamos no Kubernetes. Nós poderíamos ter dois containers rodando juntos, de forma que compartilhariam o mesmo volume.

O problema é que ele ainda não está exposto. Vamos criar o Load Balancer.

## Serviço Load Balancer

Nós vamos seguir os mesmos passos (criar arquivo de configuração e `apply` usando `kubectl`). Crie o arquivo `sh-service-lb.yaml`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sh-service
  labels:
    app: sh-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 5000
  selector:
    app: sh-deployment
```

Agora nós rodamos o mesmo comando para esse arquivo:

```shell
$ kubectl apply -f sh-service-lb.yaml
service "sh-service" created
```

**O que fizémos?** Criamos nosso Load Balancer redirecionando requests de acesso externo (porta 80) para nosso container (porta 5000).

Certo. Nosso serviço foi criado, mas precisa de um tempo para iniciar. Espere o EXTERNAL-IP mudar de PENDING para um valor real:

```shell
$ kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP      10.15.240.1     <none>        443/TCP        25m
sh-service   LoadBalancer   10.15.241.155   <pending>     80:30138/TCP   1s

# Wait some time

$ kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
kubernetes   ClusterIP      10.15.240.1     <none>          443/TCP        27m
sh-service   LoadBalancer   10.15.241.155   35.192.86.102   80:30138/TCP   1m
```

Meu IP externo é 35.192.86.102. Pegue o seu IP externo e acesse de seu navegador (http://YOUR_EXTERNAL_IP/).

## Acessando a interface web

Pegue o token de acesso rodando `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^deployment-controller-token-/{print $1}') | awk '$1=="token:"{print $2}'`.

Acesse a interface localmente por um proxy rodando `kubectl config view` e abrindo [http://127.0.0.1:8001/ui/](http://127.0.0.1:8001/ui/). Para Sign In, use o token obtido anteriormente.

## Apague tudo

Certo, fizémos nossos testes. Podemos remover tudo apagando nosso cluster.

```shell
$ gcloud container clusters delete hello-cluster
The following clusters will be deleted.
 - [hello-cluster] in [us-central1-a]

Do you want to continue (Y/n)?  Y

...
```

## Resumo

Nesse tutorial, criamos um cluster, colocamos nossa aplicação e um load balancer nele, acessamos a interface web e então deletamos esse cluster.

Esse é apenas o começo para o Kubernetes, mas fizémos apenas o básico. Tentarei fazer mais posts sobre Kubernetes. Enquanto isso, você poderia ver [Learn Kubernetes in Under 3 Hours: A Detailed Guide to Orchestrating Containers](https://medium.freecodecamp.org/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882). É um tutorial mais completo que esse, aprendendo os conceitos que testamos aqui mais profundamente, mas em um cluster local.

## Referências:

* [How to sign in kubernetes dashboard?](https://stackoverflow.com/questions/46664104/how-to-sign-in-kubernetes-dashboard)
* [Quickstart - GKE](https://cloud.google.com/kubernetes-engine/docs/quickstart)
* [Hello World Walkthrough](https://kubernetes-v1-4.github.io/docs/hellonode/)
