---
layout: post
title:  "Primeiros passos com programação Python"
date:   2014-12-16 18:00:00 -0300
categories: python
permalink: blog/python/primeiros-passos-com-programacao-python
lang: pt_br
---
# Primeiros passos com programação Python

Está querendo aprender Python? Vou escrever um pouco para você começar. É pouco, mas mostrarei algo que vai MUITO além do Hello World. Mas antes, tem alguns pequenos requisitos.

1. Eu espero que você trabalhe (pelo menos um pouco) com linha de comando. Não é difícil, e tem vantagens (que já expliquei em [outro post](http://www.rafaelhdr.com.br/blog/ssh/meus-usos-mais-comuns-de-comandos-sh))
1. Já ter instalado o Python no seu computador (se for Ubuntu, provavelmente você já o terá instalado). [Aqui um link para instalar](https://www.python.org/downloads/)
1. Já ter instalado o pip no seu computador (esse não vem por padrão no Ubuntu). É bem simples de instalar. [Aqui o link](https://pip.pypa.io/en/latest/installing.html)

## Começando pelo Hello World

Certo. Vamos começar pelo começo. O famoso Hello World. Crie um arquivo chamado hello.py. Conteúdo bem simples:

```python
print "Hello World"
```

Com o terminal, vá na pasta do seu arquivo, e digite python hello.py. E pronto:

![python hello]({{"/assets/posts/2014-12-16-primeiros-passos-com-programacao-python/python-hello.png" | absolute_url }})

## Um pouco de sintaxe

Está na hora de sintaxe. Você vai entender rápido por aqui. Parece chato, mas logo estará na última parte (que é a mais interessante)

Vamos para o básico if, else, while, for e uma função.

```python
# -*- coding: utf-8 -*-

# function
def soma(a, b):
    return a + b
print soma(1,1)

# if
if soma(1,2) == 3:
    print 'Verdade'
else:
    print "Mentira"

# while
i = 0
while i < 5:
    print i
    i = i + 1

# for
for fruta in ['Maça', 'Banana', 'Melão']:
    print fruta
```

**def** - Declaramos uma função com o def, fizémos uma simples soma e já o chamamos. Esperamos então o resultado 2.

**if** - Verificamos se é verdade que a soma é 3. Por ser verdade, esperamos que escreva Verdade.

**while** - Setamos o contador em 0, e escrevemos enquando ele for menos que 5. Esperamos que ele escreva de 0 a 4.

**for** - Para cada item dentro da lista, ele vai escrever esse item. Portanto, esperamos que ele escreva todas essas frutas.

**\* identação** - Você deve ter visto que não são mais chaves (o que é o mais comum). Você identa com quebra de linha, e 4 espaços. Você verá que isso vai te forçar a deixar o código mais legível.

**\*\* utf-8** - Se estranhou aquele código estranho na primeira linha, perceberá que serve para que se aceite caracteres como ç (como no caso de maça, que precisei)

E como resultado:

![python results]({{"/assets/posts/2014-12-16-primeiros-passos-com-programacao-python/python-results.png" | absolute_url }})

Convenhamos que o Python é super simples. Rapidinho já pegamos o básico dele. Agora vou mostrar o grande poder dele.

## Packages

Essa é a parte legal. Vamos importar um package de alguém, e executar. No caso, peguei um pacote chamado petname. Ele gera nomes para cachorros.

Primeiro, vamos instalar ele. No seu terminal, rode o comando sudo pip install petname. Você instalará no seu sistema esse tal de petname. Agora vamos para o código.

```python
from petname import *

print PetName(1,' ')
print PetName(2,' ')
print PetName(3,' ')
```

Como resultado, você vai gerar nomes de cachorros, sendo de apenas 1 palavra na primeira linha, 2 na segunda e 3 na terceira. Simples assim. No caso, eu apenas tive o trabalho de ler rapidinho a documentação pra entender esse PetName.

![python pets]({{"/assets/posts/2014-12-16-primeiros-passos-com-programacao-python/python-pets.png" | absolute_url }})

Agora imagine essa facilidade para um monte de aplicações (banco de dados, comunicações, gráficos, etc...). Acabei de olhar, e existem **52927 packages** disponíveis. É muito, e costuma agilizar bastante nosso trabalho.
