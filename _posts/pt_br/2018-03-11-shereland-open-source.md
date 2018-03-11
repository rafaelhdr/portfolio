---
layout: post
title:  "Shereland open-source"
date:   2018-03-11 12:00:00 -0300
categories: shereland open-source
permalink: blog/shereland-open-source
lang: pt_br
---
# Shereland open-source

Shereland é um site de compartilhamento de livros. É útil para encontrar os livros que seus amigos poderiam lhe emprestar.

Ele foi desenvolvido com Python Django, sendo um playground para praticar novas tecnologias e aprender.

Mas depois de aprender novas coisas na última empresa que trabalhei, resolvi mudar, usando micro-serviços, graphql e Go.

## Por quê

**Micro-serviços** - Eu gosto de infraestrutura e microserviços me ajudarão a ter uma melhor infra para meus projetos.

**Graphql** - É muito bacana. Além de fácil de usar e atualizar meus serviços.

**Go** - Na verdade, ainda estou aprendendo. Eu poderia fazer meu site mais rápido com node.js e Python. Então me forcei a desenvolver em Go para aprendê-lo.

## Status

É composto de 8 imagens Docker:

1. Caddy Server - Servidor http com Let's Encrypt (não é meu: [source](https://github.com/abiosoft/caddy-docker))
1. Graphql - Serviço de frente como api ([source](https://gitlab.com/shereland/graphql)). Está muito grande, agrupando toda a lógica do projeto, mas deve ser quebrado em mais microserviços.
1. Monolithic DB - A base de dados com todo o projeto. Na realidade, pretendo quebrá-lo em diversas partes, uma para cada microserviço (MariaDB).
1. MySQL Docker Backuper - Serviço para fazer o backup da base de dados ([source](https://github.com/rafaelhdr/mysql-docker-backuper)).
1. Shereland - O projeto Python Django que criei (closed-source).
1. Redis DB - Armazena as sessões de usuário e no futuro será usado como cache.
1. Thumbnail - Apenas para os albuns do blog, usando imaginary (not mine: [source](https://github.com/h2non/imaginary)). Na realidade, é temporário. Pretendo gerar o thumbnail apenas no upload da foto, e não quando o usuário acessar.
1. Web - Front-end para o HTML ([source](https://gitlab.com/shereland/web)).

Ele está acessível como [beta](https://beta.shereland.com/blog/). Depois de bugfixes e mais testes colocarei como padrão.

## Arrependimentos

Eu queria a primeira versão bem simples. Todas as requisições para `/blog/*` são redirecionadas para o novo serviço. Eu queria melhorá-la primeiro pois possui muitos acessos (SEO).

Mas se fosse voltar atrás, eu começaria por algo ainda mais simples, apenas com graphql e usando o HTML do site legado.

## Nota sobre os testes

O microserviço **web** tem bons testes (Unitários e de Integração com Pact). Mas eu não coloquei os testes em **graphql**. Por quê?

Pouco depois de desenvolver o microserviço **web** eu vi um [post interessante sobre monitoramento "Testing Microservices, the sane way"](https://medium.com/@copyconstruct/testing-microservices-the-sane-way-9bb31d158c16). També vi "Service Reliability Hierarchy" do [Google SRE Book](https://landing.google.com/sre/book/chapters/part3.html). Então decidi que vou focar inicialmente em monitoramento.

## Futuro

Tem muito trabalho para fazer no Shereland. Meu foco será automação e em seguida monitoramento. O Primeiro e Segundo caminho (ver [The Three Ways](https://itrevolution.com/the-three-ways-principles-underpinning-devops/)).

Automação: Fazer o pipeline de `graphql` e `web`.

Monitoramento: Colocar Prometheus para métricas de performance.
