---
layout: post
title:  "Redesign do site com IA"
date:   2026-06-17 14:00:00 0100
categories: web ia portfolio rafaelhdr jekyll docker
permalink: blog/website-redesign-with-ai
lang: pt_br
excerpt: "Por que e como fiz o redesign do meu próprio site"
---
# Redesign do site rafaelhdr.com.br

A IA chegou, e esta é a primeira vez que estou atualizando este site usando IA.

Essa tecnologia não é novidade para mim. Eu a uso diariamente no trabalho/vida pessoal. Já tinha experiência.

Mas por muito tempo quis atualizar meu portfólio, mas tinha outras prioridades.

## Motivação

Estou procurando um novo emprego. Faz 8 anos que estou na The Silver Logic. Houve muito aprendizado, mas desde o ano passado estava claro para mim que queria mudar. E em janeiro comuniquei ao chefe/colegas/amigos.

Ultimamente tenho estado mais focado nisso. E não estava muito orgulhoso da versão atual do rafaelhdr.com.br (em termos de design).

Sinceramente, design não é minha habilidade mais forte, mas queria ter algo bonito para os visitantes. Algo do qual eu me orgulhasse (anteriormente, a página inicial tinha apenas um "olá" meu).

Estou feliz por enquanto. Definitivamente pode ser melhorado, mas posso fazer isso em outra oportunidade. Por enquanto, é suficiente.

## Referências

Tive alguns sites de amigos como primeira referência. Algo para começar:

* [alexandreanicio.dev](https://alexandreanicio.dev/)
* [samueljansem.dev](https://samueljansem.dev/contact/)

E então fui ao [Reddit](https://www.reddit.com/r/webdev/comments/143acrg/show_me_your_portfolios/)

Tem muitos exemplos bons. Mas alguns são exagerados (ótimos, mas eu não focaria em alcançar aquilo). Como este que roda um SO no navegador [dustinbrett.com](https://dustinbrett.com/) ou este muito bonito [alyssafaustino.com](https://alyssafaustino.com/).

Mas então peguei 3 que foram realmente boas referências. Eu ia basear meu redesign tendo-os como referência:

* [gianmarcocavallo.com](https://gianmarcocavallo.com/)
* [radnaabazar.com](https://www.radnaabazar.com/en)
* [m7mad.dev](https://m7mad.dev/)

E finalmente, quando quero explicar algo para a IA, ou até ter um bom exemplo para mim, vou ao [Dribbble](https://dribbble.com/).

## O que fiz

Comecei fazendo a IA obter contexto, e então gerar o AGENTS.md (para prompts futuros).

E segundo, estava atualizando os pacotes, Docker, Ruby, Jekyll etc. E criei o docker compose para facilitar testes locais.

Finalmente, dividir e conquistar. Eu acessava cada página e trabalhava no que me incomodava. O que não estava claro, e o que poderia ser melhor. Esse processo incluía abrir os portfólios de outros devs para pegar ideias.

O desenvolvimento foi feito apenas pela IA. Ainda reviso o que está acontecendo (para ver se algo está muito errado). Por exemplo, por algum motivo ela converteu uma página para HTML (totalmente desnecessário, e eu ainda gostaria de revisar/escrever conteúdo, e markdown é muito mais fácil para isso).

Mas tudo foi muito rápido de fazer. É difícil comparar com o método que eu usava anos atrás.

## Ferramentas utilizadas

Não usei Claude (ou ChatGPT). Esse processo também é um aprendizado para mim. A The Silver Logic adotou Claude, investindo em workshops e aprendizado. Ainda tenho muito a aprender sobre isso, mas quero testar alternativas no meu tempo pessoal.

A razão para as alternativas é principalmente porque não gosto muito de ficar numa solução única. Gostaria de conhecer as opções e poder escolher o que usar. E vejo muito potencial. Por exemplo, em um projeto paralelo, estou fazendo várias tarefas pequenas e fáceis de IA. Para isso, quero usar um modelo de IA barato/rápido. Para outras tarefas, gostaria de pagar mais, para economizar meu tempo.

Hoje em dia, estou usando estas 2 ferramentas:

### AionUI

Fonte: [AionUI](https://aionui.com/)

Ela pode fazer muita coisa, e ainda tenho muito a aprender. Tem muitos templates, e consegue se conectar a tantos modelos (alguns deles gratuitos).

Foi útil para o momento de insight. Quando quero revisar algum texto, pesquisar soluções. Quando era mais relacionado ao produto, e não especificamente ao código, eu estava usando ela.

### OpenCode

Fonte: [OpenCode](https://opencode.ai/)

Para a programação em si, estou usando no terminal.

Se a tarefa é pequena, apenas construo. Reviso e então é mesclado.

Se a tarefa é média ou grande, então explico, dou diretrizes, e peço no modo Plan. Após o plano, aconselho ou faço algum ajuste, e então uso o modo Build.

## Não totalmente IA

Para construir, foi ótimo. Mas para o conteúdo, ainda acredito que eu deveria ser o gerador do conteúdo.

No final, é meu próprio site. Deve ter minha personalidade e minhas informações aqui. Mas pequenos ajustes, como adicionar URL e revisão gramatical, é para a IA.

