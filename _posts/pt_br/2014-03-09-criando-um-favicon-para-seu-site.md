---
layout: post
title:  "Favicon para o seu site"
date:   2014-03-09 20:00:00 -0300
categories: favicon
permalink: blog/about/criando-um-favicon-para-seu-site
lang: pt_br
---
# Adicione favicon ao seu site

Para quem não sabe, favicon é um pequeno ícone de seu site, que é mostrado no navegador de seus visitantes, como o seguinte:

![Exemplo favicon]({{"/assets/posts/2014-03-09-criando-um-favicon-para-seu-site/favicon-rafaelhdr.png" | absolute_url }})

## A importância do favicon

**Facilidade de reconhecimento**. Seus visitantes ao visitar seu site, podem estar visitando muitos outros sites. Conheço alguns que usam muitas (mas muitas mesmo) abas, e um favicon acaba facilitando as pessoas de voltarem em seu site.

![Exemplo favicon]({{"/assets/posts/2014-03-09-criando-um-favicon-para-seu-site/toomanytabs.png" | absolute_url }})

**Reforça a imagem**. Você mostra mais um pouco sua imagem, ajudando seus visitantes a fixarem a marca (claro que é uma ação pequena, mas é também uma ação bem simples).

## Criando seu favicon

**Caso você não saiba nada de ferramentas de desenho**, você pode usar o [favicon generator](http://www.favicon.cc/). Basta acessar o site, e pintar os pontos que deseja, e por fim baixar, clicando em Download favicon.

**Mas você pode preferir usar ferramentas de Desenho**. No meu caso, eu uso o [Gimp]{http://www.gimp.org/}. Basta fazer seu desenho, e então recriá-lo todo em uma nova aba (Ctrl + A para selecionar tudo, Ctrl + Shift + V para criar uma nova imagem com tudo), em seguida exportá-lo (Ctrl + E) salvando-o com terminacao ".ico". O próprio Gimp converte corretamente.

Disponibilizando o favicon
Agora você precisa apenas colocá-lo em seu site, e dizer para os visitantes onde ele está.

Primeiro, faça o upload do favicon, e guarde seu endereço (vou chamá-lo de /img/favicon.ico).

Por fim, diga pelo navegado de seus usuários onde ele se encontra. Coloque uma tag, como a seguinte, dentro da sua tag head.

```html
<link rel="shortcut icon" href="/img/favicon.ico" />
```

E está pronto. Com isso, seus visitantes já podem visualizar seu favicon.
