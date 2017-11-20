---
layout: post
title:  "Pegar cep do site dos correios em python"
date:   2014-10-25 12:00:00 -0300
categories: python cep correios
permalink: blog/python/pegar-cep-do-site-dos-correios-em-python
lang: pt_br
---
# Pegar cep do site dos correios em python

Os usuários querem facilidade. Então que tal preenchermos automaticamente os dados deles? Se ele apenas preencher o cep, podemos buscar informações de endereço, bairro, cidade e estado, facilitando o preenchimento.

Mas a pergunta é, como vamos conseguir esses dados? Não existe uma base oficial sendo distribuída. Se não me engano, ela é vendida, e bem caro. Algo que tenho minhas dúvidas que deveria ser cobrado uma taxa alta, pois prioriza um dado público (ou será que não deveria ser público) que tem mais dinheiro, deixando de lado outros públicos sem tanto dinheiro à disposição (como startups).

Mas saindo desse lado político, os correios disponibilizam isso pra gente. E essa informação dos correios é aberta, então criei um script para pegá-la mais facilmente.

O script final é esse:

```python
import requests
from bs4 import BeautifulSoup
import re

def get_brcep(cep):
    # Getting data
    session = requests.session()
    data = {'relaxation': cep,
            'TipoCep': 'ALL',
            'semelhante': 'N',
            }
    r = session.post("http://www.buscacep.correios.com.br/sistemas/buscacep/resultadoBuscaCepEndereco.cfm", data)

    content = r.content

    # Parsing
    soup = BeautifulSoup(content)
    items = soup.find_all('table')[0].find_all('td')

    # Returning data
    print(items)
    return {
        'address': re.sub(' - .*', '', items[0].string),
        'district': items[1].string,
        'city': items[2].string,
        'state': items[3].string,
    }
```

Certo. Agora vamos ver o que estamos fazendo. Espero que você saiba um pouco de python, pois vou pular a parte da sintaxe.

A minha função get_brcep pode ser dividida em 3 partes:

## Getting data

Ou seja, estamos puxando todas as informações (tudo mesmo). No caso, estamos fazendo uma requisição POST para o site dos correios com o CEP desejado (esse cep vem de parâmetro). Por fim, teremos todo o conteúdo da página (content).

```python
session.post("http://www.buscacep.correios.com.br/servicos/dnec/consultaEnderecoAction.do", data)
```

## Parsing

Agora vamos puxar as informações que interessam. No site dos correios, já duas tabelas. Uma com os índices, e outra com as informações (também achei estranho) e por isso estamos pegando apenas essa 2ª, que contém as informações que queremos.

```python
items = soup.find_all('table')[2].find_all('td')
```

E então, puxamos todas as colunas (td), que são os dados que realmente interessam.

```python
items = soup.find_all('table')[2].find_all('td')
```

## Returning data

E pronto. Agora é só dar um tapa nas informações, e retornar como um dicionário. Acho que a única ressalva é para o endereço, que cortamos o que vem logo após o " - ", que se refere aos números da rua que se encaixam.

```python
    return {
        'address': re.sub(' - .*', '', items[0].string),
        'district': items[1].string,
        'city': items[2].string,
        'state': items[3].string,
    }
```

Simples e prático. Demorei um pouco pra pegar e entender as libs necessárias (de requisição e de parsing), mas depois disso vai rápido.
