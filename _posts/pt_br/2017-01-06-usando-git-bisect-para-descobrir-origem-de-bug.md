---
layout: post
title:  "Usando o git Bisect para descobrir origem de bug"
date:   2017-01-06 17:00:00 -0300
categories: git bisect
permalink: blog/git/usando-git-bisect-para-descobrir-origem-de-bug
lang: pt_br
---
# Usando o git Bisect para descobrir origem de bug

Imagine o seguinte cenário. Você fez um código que funcionava corretamente. Depois de muitos commits, descobre que não funciona mais. E agora? O que aconteceu? O que posso fazer?

Uma possível solução é **buscar o commit que gerou esse bug, para então corrigí-lo**.

Esse post será dividido em 3 partes. A primeira é apenas para gerar o cenário com tal problema, a segunda é solucionando manualmente, e a última automaticamente.

## Gerando cenário

Para esse tutorial, teremos 7 commits:

1. Primeiro commit (projeto em branco)
1. Commit com o código funcionando corretamente
1. Commit aleatório
1. Commit aleatório
1. Commit que gerou o bug
1. Commit aleatório
1. Commit aleatório

Será feito em python (pois já vem nativas no Linux em geral, e será fácil de testar).

## Commit 1

Execute o seguinte comando no seu shell

```shell
git init
echo 'My new project' > README.txt
git add .
git commit -m "First commit"
```

## Commit 2

Crie um arquivo chamado test_nice.py, e coloque o seguinte conteúdo.

```python
import unittest

class TestStringMethods(unittest.TestCase):
    def test_something_test(self):
        self.assertEqual('foo'.upper(), 'FOO')
```

Você pode testar que está funcionando com o comando "python -m unittest discover". O resultado será o seguinte:

```shell
$ python -m unittest discover
.
----------------------------------------------------------------------
Ran 1 test in 0.000s
OK
```

Por fim, adicione-o ao repositório com:

```shell
git add .
git commit -m "First test working :)"
```

## Commits 3 e 4

Gere-os com os comandos:

```shell
echo 'file 1' > f1.txt
git add .
git commit -m "One file"

echo 'file 2' > f2.txt
git add .
git commit -m "Another file"
```

## Commit 5

Agora vamos fazer o commit com bug. Edite a última linha do arquivo test_nice.py colocando uma asserção errada:

```python
        self.assertEqual('foo'.upper(), 'FOO error')
```

E adicione ao repositório:

```shell
git add .
git commit -m "Someone added a bug"
```

## Commit 6 e 7

Adicione os últimos commits:

```shell
echo 'file 3' > f3.txt
git add .
git commit -m "File 3"

echo 'file 4' > f4.txt
git add .
git commit -m "My last file"
```

E pronto. Temos um código bugado, diversos commits, e não sabemos onde deu problema. Verifique que não funciona com o mesmo comando python -m unittest discover:

```shell
$ python -m unittest discover
F
======================================================================
FAIL: test_something_test (test_nice.TestStringMethods)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/rafael/Projects/git/bisect/test_nice.py", line 7, in test_something_test
    self.assertEqual('foo'.upper(), 'FOO error')
AssertionError: 'FOO' != 'FOO error'
- FOO
+ FOO error

----------------------------------------------------------------------
Ran 1 test in 0.001s
```

## Solução manual

Vamos manualmente buscar esse erro. O primeiro passo é saber algum commit que temos certeza que está funcionando. Com o comando git log, buscamos o nosso commit "First test working :)"

```shell
$ git log

[commits mais recentes]

commit 6e2d28a3f91d6fdea243575b9cf7f792ee61e188
Author: Example <example@example.com>
Date:   Fri Jan 6 16:58:23 2017 +0000
    First test working :)

[commits mais antigos]
```

Com isso, temos o commit **6e2d28a3f91d6fdea243575b9cf7f792ee61e188** como referência (o seu commit será diferente, utilize o seu). Execute os seguintes comandos:

```shell
git bisect start
git bisect bad
git bisect good 6e2d28a3f91d6fdea243575b9cf7f792ee61e188
```

O primeiro comando inicializa a sessão bisect, para buscarmos o erro. O segundo comando diz que o commit atual está quebrado. O último comando diz que o commit dado está funcionando bem.

Agora a cada commit, você verifica se está ok, e sinaliza se está bom ou não. Se estiver bom, git bisect good, ou então git bisect bad no caso contrário. No nosso exemplo:

```shell
python -m unittest discover
.
----------------------------------------------------------------------
Ran 1 test in 0.000s


OK
```

Como está bom, então executamos **git bisect good**.

Refazendo o comando:

```shell
python -m unittest discover
F
======================================================================
FAIL: test_something_test (test_nice.TestStringMethods)

[...]
```

```shell
git bisect bad
8aa15bf9c745d0f7939b7a114db137fed2783276 is the first bad commit
commit 8aa15bf9c745d0f7939b7a114db137fed2783276
Author: Example <example@example.com>
Date:   Fri Jan 6 16:59:27 2017 +0000

    Someone added a bug

:100644 100644 c68990ec5cc5602c1adcdad80e1ef7d7f68b1188 09d9d6e4d7469ece38eb449541922214807e6332 M    test_nice.py
```

Com isso, descobrimos que o bug aconteceu no commit 8aa15bf. Agora é ver o que aconteceu pelo código. Depois de analisar, basta executar git bisect reset para voltar onde estava inicialmente.

Com uma imagem fica mais fácil de entender o que aconteceu:

![CRUD add]({{"/assets/posts/2017-01-06-usando-git-bisect-para-descobrir-origem-de-bug/git-bisect-gimp.png" | absolute_url }})

Simples, não? Mas tem uma forma automática mais rápida.

### Solução automática

No nosso caso, temos o comando que retorna o erro. A biblioteca unittest retorna 0 quando não há erros, e um valor maior que 0 no caso o contrário. É exatamente o que o git precisa para fazer todo esse processo manualmente. Execute os comandos:

```shell
git bisect start
git bisect bad
git bisect good 6e2d28a3f91d6fdea243575b9cf7f792ee61e188
git bisect run python -m unittest discover
```

Os três primeiros comandos já vimos. O último vai adicionar o comando `python -m unittest discover` para a verificação. Se o comando retornar `0`, então é considerado `good`, e não `0` é `bad`. Assim, temos o mesmo resultado.

Normalmente não é tão simples esse processo. Nesse tutorial usamos apenas 7 commits simples, o que não será o caso. Mas tendo a ideia, fica mais fácil de repetir o processo.

Espero que tenha ficado bem claro. Qualquer dúvida, deixe uma mensagem nos comentários.

Referências

* [https://git-scm.com/docs/git-bisect](https://git-scm.com/docs/git-bisect)
* [https://docs.python.org/2/library/unittest.html](https://docs.python.org/2/library/unittest.html)
* [http://www.tldp.org/LDP/abs/html/exit-status.html](http://www.tldp.org/LDP/abs/html/exit-status.html)
