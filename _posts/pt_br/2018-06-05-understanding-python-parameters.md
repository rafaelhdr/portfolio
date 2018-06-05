---
layout: post
title:  "Entendendo os parâmetros de python"
date:   2018-06-05 08:00:00 -0300
categories: python parameter
permalink: blog/understanding-python-parameters
lang: pt_br
---
# Entendendo os parâmetros de python

Nesse post, vou escrever uma função simples `full_profile` explicando alguns conceitos sobre os parâmetros de Python. Con isso, poderemos entender como a famosa função `my_function(*args, **kwargs)` funciona.

## Argumento de posição (Positional argument)

Esse é o primeiro tipo de parâmetro que vemos. A sequência de argumentos dada é usada:

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

full_profile(1, "rafael", 30)
```

Resultado:

```shell
Id: 1
Name: rafael
Age: 30
```

## Argumento de palavra-chave (Keyword argument)

Algumas vezes é melhor usarmos argumento de palavra-chave para ficar mais legível.

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

full_profile(1, name="rafael", age=30)
```

Resultado:

```shell
Id: 1
Name: rafael
Age: 30
```

Em minha opinião, prefiro argumento de palavra chave pois é mais explícito (mas nem sempre, como por exemplo em `soma(1, 2)` por não fazer diferença a ordem).

## Forçar argumento de palavra-chave

Se você trocar a ordem dos argumentos, pode ter o seguinte problema:

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

# If you change the order for some reason, the result will be wrong
full_profile(1, 30, "rafael")
```

Resultado:

```shell
Id: 1
Name: 30
Age: rafael
```

Você pode forçar o argumento ser de palavra chave usando `*`:

```python
def full_profile(id, *, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

# This will not work anymore
full_profile(1, 30, "rafael")

# This will work
full_profile(1, name="rafael", age=30)

# This result is the same
full_profile(1, age=30, name="rafael")
```

Resultado:

```shell
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
TypeError: full_profile() takes 1 positional argument but 3 were given

Id: 1
Name: rafael
Age: 30

Id: 1
Name: rafael
Age: 30
```

## Adicionar argumentos de posição não definidos

Se quisermos adicionar mais informações passadas pelo usuário, mas não definidas na função, podemos usar args.

```python
def full_profile(id, *args, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)

full_profile(1, "I am a developer", name="rafael", age=30)
```

Resultado:

```shell
Id: 1
Name: rafael
Age: 30
I am a developer
```

Agora entendemos os `*args` do padrão `my_function(*args, **kwargs)`.

> Nós não precisamos usar o nome `args`. Poderia ser algum outro nome, como `extra`. É apenas umas convenção.

## Adicionando argumentos de palavras-chave não definidos

Se precisarmos de mais informações passadas pelo usuário, mas não definidos pela função, podemos usar kwargs.

```python
def full_profile(id, *args, name, age, **kwargs):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{key}: {value}")

full_profile(1, "I am a developer", name="rafael", age=30, Company="rafaelhdr")
```

Resultado:

```shell
Id: 1
Name: rafael
Age: 30
I am a developer
Company: rafaelhdr
```

E agora entendemos o `**kwargs` do padrão `my_function(*args, **kwargs)`.

> Novamente, `kwargs` é a convenção, mas você pode escolher outro nome.

Se usarmos o padrão `my_function(*args, **kwargs)` ele aceitará todos os casos. Mas os argumentos são todos opcionais. Se definirmos ele na função e o usuário não fornecê-lo, será levantado um erro:

```python
def full_profile(id, *args, name, age, **kwargs):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{key}: {value}")

# age is removed of the arguments
full_profile(1, "I am a developer", name="rafael", Company="rafaelhdr")
```

Resultado:

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: full_profile() missing 1 required keyword-only argument: 'age'
```

# args e kwargs

Podemos pensar em `*args` como uma lista de **argumentos de posição** não definidos e `**kwargs` é um Dicionário de **argumentos de palavra-chave** não definidos.

## Referência

[Python Glossary - term parameter](https://docs.python.org/3/glossary.html#term-parameter)
