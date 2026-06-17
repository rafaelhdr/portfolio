---
layout: post
title:  "Deploying a hello world application to GKE"
date:   2018-06-08 08:00:00 -0300
categories: docker kubernetes gke
permalink: blog/deploying-hello-world-application-to-gke
lang: en
excerpt: "Step-by-step guide to deploying a Dockerized hello-world app on Google Kubernetes Engine using gcloud and kubectl."
---
# Deploying a hello world application to GKE

This tutorial is for deploying a very simple application to [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/).

But before starting, you need:

* [gcloud](https://cloud.google.com/sdk/) command line tools installed and configured
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command line installed

It is better if you already know the basics of Docker. I created a image `rafaelhdr/server-hello` for it. This image just responds `Hello, World!` for a `GET /`.

## Create the cluster

`gcloud container clusters create hello-cluster`

This command will create a new kubernetes cluster. After some time it will print:

```shell
...
NAME           LOCATION       MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
hello-cluster  us-central1-a  1.8.10-gke.0    35.226.200.163  n1-standard-1  1.8.10-gke.0  3          RUNNING
```

## Deploying the application

We have our cluster but no application running. Check with the following kubectl commands:

```shell
$ kubectl get deployment
No resources found.

$ kubectl get pods
No resources found.
```

So let's deploy our application. Create the deployment configuration file `sh-service-lb.yaml`:

> If you want to deploy your own application, change the **image** and **cointanerPort**.

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

To deploy to our cluster, run:

```shell
$ kubectl apply -f sh-deployment.yaml 
deployment.extensions "sh-deployment" created
```

We deployed our application. You can check by running:

```shell
$ kubectl get deployment
NAME            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
sh-deployment   2         2         2            2           39s

$ kubectl get pods
NAME                             READY     STATUS    RESTARTS   AGE
sh-deployment-6db6b8856d-q9j95   1/1       Running   0          53s
sh-deployment-6db6b8856d-tgmmh   1/1       Running   0          53s
```

**What did we just do?** - We created two replicas of our application running in our cluster (`replicas: 2`). That is why we see 2 pods and only one deployment.

> **What is a Pod?** It is the smallest deployable unit in Kubernetes. We could have two containers running together, so they could share the same volume.

The problem is that it is not exposed yet. Let's create a Load Balancer.

## Service Load Balancer

We will follow the same steps (create our configuration file and `apply` using `kubectl`). Create the file `sh-service-lb.yaml`.

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

Now we run the same command for this new file:

```shell
$ kubectl apply -f sh-service-lb.yaml
service "sh-service" created
```

**What did we just do?** We created our Load Balancer redirecting requests from external access (port 80) to our container (port 5000).

Ok. Our service is created. But it needs some time to start. Wait for the EXTERNAL-IP to change from PENDING to a real one:

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

My external IP is 35.192.86.102. Get your external IP and access using your browser (http://YOUR_EXTERNAL_IP/).

## Accessing Web UI 

Retrieve the token for Sign In running `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^deployment-controller-token-/{print $1}') | awk '$1=="token:"{print $2}'`.

And access the UI locally proxying it by running `kubectl config view` and opening [http://127.0.0.1:8001/ui/](http://127.0.0.1:8001/ui/). For Sign In, use the token obtained before.

## Delete all

Ok, we could make our tests. We can remove everything if we just delete the cluster.

```shell
$ gcloud container clusters delete hello-cluster
The following clusters will be deleted.
 - [hello-cluster] in [us-central1-a]

Do you want to continue (Y/n)?  Y

...
```

## Summary

In this tutorial, you created a cluster, deployed a hello world application and it's load balancer service, accessed the Web UI and deleted the cluster.

This is just the beginning for Kubernetes, but we could check the basics. I will try to make more posts about Kubernetes. Meanwhile, you could check [Learn Kubernetes in Under 3 Hours: A Detailed Guide to Orchestrating Containers](https://medium.freecodecamp.org/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882). It is more complete than this one, so you will learn deeper the concepts we tested here, but in a local cluster.

## References:

* [How to sign in kubernetes dashboard?](https://stackoverflow.com/questions/46664104/how-to-sign-in-kubernetes-dashboard)
* [Quickstart - GKE](https://cloud.google.com/kubernetes-engine/docs/quickstart)
* [Hello World Walkthrough](https://kubernetes-v1-4.github.io/docs/hellonode/)
