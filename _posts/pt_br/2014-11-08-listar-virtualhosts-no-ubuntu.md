---
layout: post
title:  "Listar virtualhosts no ubuntu"
date:   2014-11-08 12:00:00 -0300
categories: ubuntu apache virtualhosts
permalink: blog/tips/listar-virtualhosts-no-ubuntu
lang: pt_br
---
# Listar virtualhosts no ubuntu

Não sei vocês, mas eu tenho muitos virtualhosts no meu servidor.

![Listar virtualhosts]({{"/assets/posts/2014-11-08-listar-virtualhosts-no-ubuntu/list-virtualhosts-ubuntu_1.png" | absolute_url }})

Eu cadastro eles no meu servidor (por sinal, o servidor que está com o rafaelhdr), e uso também para meus outros sites, onde tenho diversos subdomínios em alguns casos.

De repente tá com algum problema. E agora? O que está errado aí no meio?

Liste todos com o seguinte código:

```shell
apache2ctl -S
```

E então você terá a lista de todos que estão rodando.

Fonte:

* [http://www.faqforge.com/linux/controlpanels/get-a-list-of-all-virtual-hosts-which-are-defined-in-all-apache-configuration-files/](http://www.faqforge.com/linux/controlpanels/get-a-list-of-all-virtual-hosts-which-are-defined-in-all-apache-configuration-files/)
