---
layout: post
title:  "Primeiras impressões do Debian"
date:   2014-12-28 16:00:00 -0300
categories: debian
permalink: blog/linux/primeiras-impressoes-do-debian
lang: pt_br
---
# Primeiras impressões do Debian

Certo, agora foi a vez de testar o grande Debian. Começando o print abaixo:

![CRUD add]({{"/assets/posts/2014-12-28-primeiras-impressoes-do-debian/debian-screenshot_1.png" | absolute_url }})

Bom, esse não é exatamente como vem pra gente. Eu dei uma configurada com uma ferramenta bem bacana, que é o [Gnome Extensions](https://extensions.gnome.org/). Esse é o grande ponto positivo, que é algo que não conhecia do Ubuntu, que trás um monte de aplicação pra gente colocar no nosso Debian. Esse dock à esquerda do print-screen veio de lá, e a instalação é feita com apenas poucos cliques.

Mas vamos voltar para o começo. A **instalação**. Não consegui fazê-la com o **Startup disk creator**. Mas o comando dd funcionou legal:

```shell
dd if=/path/to/my.iso of=/dev/sdb
```

E então começam as dificuldades. Acho que dificuldade não é bem a palavra, mas me acostumei mal com o Ubuntu. Fui testar antes de instalar, e já começam problemas. O Wifi não funciona. Ok, só colocar o cabo. Já vi que teria um pouco mais de trabalho, mas mesmo assim fui a fundo pra instalar. Reboot e vamos lá. Achei a instalação um pouco mais complicada (perguntava alguns termos que não conheço, como hvm, ou outras siglas parecidas) mas nada que me impediu. Ele pedia também uns drivers, mas como não tinha, fui avançando e ignorando isso. Por fim fiz funcionar, embora sem wifi. Dando uma googlada, resolvi até que rápido (uns 15 minutos), mas confesso que não foi uma boa primeira impressão.

Usando ele, não tive tantas dificuldades. Há coisas que não vem como padrão (por exemplo, sudo algum comando não funciona, então precisei me configurar como sudoer). São detalhes que não vem por padrão, o que me faz preferir outra distribuição.

Bom, de resultado, acredito que tive aprendizado. Tanto de conhecer o Debian, mas principalmente por esses detalhes, onde a gente precisa aprender a se virar um pouco na unha.

Em **resumo**, achei ele um pouco mais cru, onde precisamos configurar mais que o normal, e com algumas dificuldades (ou aprendizados) que não temos ao usar o Ubuntu.
