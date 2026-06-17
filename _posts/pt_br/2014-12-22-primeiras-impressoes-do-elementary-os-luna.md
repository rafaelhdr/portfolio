---
layout: post
title:  "Primeiras impressões do Elementary OS Luna"
date:   2014-12-22 20:30:00 -0300
categories: linux elementary-os luna
permalink: blog/linux/primeiras-impressoes-do-elementary-os-luna
lang: pt_br
excerpt: "Avaliação do Elementary OS Luna: um Ubuntu com visual de Mac OS, boa comunidade, mas baseado em versão antiga."
---
# Primeiras impressões do Elementary OS Luna

Certo. Experimentei o [Elementary OS](http://elementaryos.org/). Não costumo escrever reviews (e acho que, tecnicamente, tem muita gente melhor), mas como desenvolvedor, resolvi usar por uma semana pra ver como que é. Hoje estou apenas aproveitando para escrever um pouco.

Resumindo muito, achei ele um Ubuntu bonito.

![Elementary os]({{"/assets/posts/2014-12-22-primeiras-impressoes-do-elementary-os-luna/elementary-os-screenshot.jpg" | absolute_url }})

Ok, concordo que ser bonito é relativo. No caso, é um **Ubuntu com cara de Mac OS**. Um docker em baixo, workspaces horizontais... Mas dá pra perceber que ele é bem trabalhado no design, tanto que achei os wallpapers dele mais agradáveis que do Ubuntu.

Certo, mas vamos voltar pro começo. Para quem não sabe, o Elementary OS é uma [distribuição Linux](http://pt.wikipedia.org/wiki/Distribui%C3%A7%C3%A3o_Linux) baseada no Ubuntu (sendo a última versão vinda do Ubuntu 12.04). E aqui vem minhas primeiras críticas. Ele é baseado em uma versão um pouco antiga. Já estamos no 14.10, e ele ainda está baseado no 12.04 (sendo que já temos outro LTS - Long Term Service - que é o 14.04). Me parece meio demorado pra fazer essas atualizações estéticas. (Por enquanto, o Elementary OS do Ubuntu 14.04 ainda está no primeiro beta)

Eu acompanho os releases do Ubuntu, e vejo melhora a cada lançamento. Um exemplo, é o autocomplete do Unity que aceita erros (se eu queria dizer chrome, e escrevo crome, ele me mostra o correto). Mas no 12.04 ainda não tinha isso, e então o Elementary OS ainda está sem. São pequenas coisas que já existe, mas ainda estão defasadas.

Existe algo que sempre acontece com qualquer um que for mudar de distro ou SO, que é se acostumar com os atalhos. Eu estava super acostumado com os atalhos do Ubuntu e, vindo para o Elementary OS, tive que me acostumar de novo. Mas isso é apenas questão de tempo, e ambos são bem editáveis. Mas confesso que gostei dos atalhos do Elementary. E pra ajudar, achei um [video bacana falando deles](http://elementaryos.org/journal/super-shortcuts).

Sobre a **comunidade**, tem bastante coisa pra quem está começando. Foi super fácil achar minhas dúvidas.

Meu **primeiro problema foi na instalação**. Ele não entrou direto no boot pelo pendrive (vou explicar o erro que fiz no final do texto). Aí entrei rapidinho no google, digitei o problema, e resolvi.

Queria comentar também sobre a **performance**. Particularmente, não achei nada de mais (tinha ouvido falar que era mais leve). Me pareceu bem próxima do Ubuntu (obviamente anos-luz mais rápido que o Windows =P).

Certo, agora vou fazer um resumo melhor. Achei uma distro bonita e bem trabalhada, fácil de se acostumar, e sem problemas para os programas (já que os de Ubuntu funcionam nele). O único detalhe é a demora para atualização de uma nova distro, mas se você não ligar para isso, então é uma boa para levar em conta.

**\* Problema na instalação:** Ele não bootava pela usb direto. Precisei colocar um login e senha. Depois, fui descobrir que o Startup disk creator foi criado apenas para gerar bootaveis de iso Ubuntu (encontrei um cara falando disso em um fórum. Eu devia ter guardado). Tive um problema com isso para o Debian, e criei sem problemas pela [linha de comando](http://slick.pl/kb/linux/create-bootable-usb-debian/).

