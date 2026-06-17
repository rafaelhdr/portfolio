---
layout: post
title:  "Dica de alerta no Ubuntu"
date:   2014-06-24 12:00:00 -0300
categories: ubuntu alert
permalink: blog/about/dica-de-alerta-no-ubuntu
lang: pt_br
excerpt: "Use alert fim após comandos demorados no terminal do Ubuntu para receber notificação quando a tarefa terminar."
---
# Dica de alerta no Ubuntu

Dica simples e rápida:

Me deparei que enquanto fazia algum comando sh mais demorado, tinha que ficar voltando na janela, para ver se terminou. Peça um alerta quando terminar.

## Sinal de alerta

Utilize ; para executar diversas operações em apenas uma linha.

Utilize alert "fim" para ser avisado de quando terminar.

![Sh ubuntu alerta]({{"/assets/posts/2014-06-24-dica-de-alerta-no-ubuntu/sh-dica-alert.png" | absolute_url }})

Com isso, ele vai enviar um sinal de alerta ao terminar. O alerta vai ser mostrado no topo superior de sua tela, como o seguinte:

![Ubuntu alerta]({{"/assets/posts/2014-06-24-dica-de-alerta-no-ubuntu/alert.png" | absolute_url }})
