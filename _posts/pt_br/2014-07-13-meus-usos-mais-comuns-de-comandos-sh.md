---
layout: post
title:  "Meus usos mais comuns de comandos SH"
date:   2014-07-13 12:00:00 -0300
categories: linux shell
permalink: blog/ssh/meus-usos-mais-comuns-de-comandos-sh
lang: pt_br
---
# Meus usos mais comuns de comandos SH

Vou compartilhar um pouco sobre quais linhas de comando mais utilizo no meu terminal, e por que. Espero que ajude principalmente aqueles novos desenvolvedores linux a utilizar mais das vantagens do terminal.

Mas antes, para quem não gosta de linha de comando, vou explicar o por que de utilizá-los.

## Por que eu ainda uso linha de comando?

Muitas pessoas não gostam de linha de comando. Outras odeiam com todas as forças, e se recusam a utilizá-la, e não entendem como ainda existe alguém que utilize a linha de comando, se tem jeito mais fácil de utilizar o computador.

A minha resposta para isso, é que a linha de comando parece muito mais assustadora do que é. Se você a utiliza, consegue fazer coisas muito mais rápido, e com extrema facilidade.

Quer um exemplo? Houve uma época que eu redimensionava muito as imagens, mas não era sempre de uma vez. Esporadicamente aparecia algo para redimensionar. É muito fácil abrir algum programa para isso (como Gimp ou Photoshop). Mas é muito mais rápido abrir o terminal (Ctrl + Alt + T, no Ubuntu Linux) e digitar resize foto.jpx 300 300. O terminal abre quase que instantâneamente, e faço isso logo, sem perder muito tempo. Agora imagine essa facilidade para diversas atividades no computador.

Mas por agora, vou parar de enrolar e ir direto ao ponto. Quais são meus comandos mais utilizados.

## Comandos

### history

Mostra o seu histórico de comandos feitos.

Mas pra que? Às vezes, cheguei a fazer algo legal, e quero lembrar como. Utilize então esse comando. Foi ele que utilizei agora pouco pra eleger meus últimos.

```shell
history
```

### git (ou svn, ou outros)

Realiza operações para ferramentas de versionamento.

Se você desenvolve, deve conhecer alguma ferramenta de versionamento. Se não conhece, entre no GitHub para saber mais. Mas com ele, faço os diversos comandos padrões dele.

*\* Nesses comandos, acho até interessante que se utilize alguma ferramenta gráfica. Eu não uso agora por questão de costume, e que já aprendi como funciona.*

```shell
git init
git status
git commit
...
```

### grep

**Esse é um dos mais importante de todos pra mim**

Faz busca dentro do código de diversos arquivos.

Em muitos momentos, quero saber onde fiz referência à variavelX. Basta então executar um comando grep -r variavelX .
Com isso, ele vai começar a procurar nos arquivos de todas as pastas filhas onde existe tal variável.

```shell
grep -r variavelX .
```

E então, que venham os diversos resultados (se tiverem).

### \*find and replace

Comando super importante também (embora não seja apenas um, mas a junção de alguns)

Vai buscar palavras no código, e substituí-la.

Em alguns momentos, fica trabalhoso utilizar o grep para buscar, e mudar na mão. Então você pode fazer isso com os diversos arquivos de uma vez.

```shell
find /path -type f -exec sed -i 's/oldstr/newstr/g'{} \;
```

Encontrei isso no [Stack Overflow](http://stackoverflow.com/questions/6178498/using-grep-and-sed-to-find-and-replace-a-string). Basta substituir o que está em oldstr pelo que deseja substituir, e newstr pelo que vai entrar no lugar.

### alert

Faz um alerta na sua janela.

Costumo utilizar pra não ficar checando toda hora se tal operação terminou, fazendo com que ele me avise quando terminar.

```shell
echo "aqui viria algum comando demorado, como apt-get" ; alert
```

[Postei já por aqui mais sobre ele.]({% post_url pt_br/2014-06-24-dica-de-alerta-no-ubuntu %})

### cd

Muda a pasta que você está localizado.

Algo bem comum para quem utiliza shell. Você muda a pasta corrente para outra que deseja utilizar.

```shell
cd meu_projeto
grep -r variavelX .
```

### ls

Lista pastas e arquivos da pasta atual.

Também é algo que todos utilizam.

```shell
ls
```

### \*runserver

Esse não é um comando. Mas é algo que eu faço com linhas de comando (em PHP e django)

Rode na sua própria máquina seu programa. Bom para evitar de ficar configurando o apache localmente.

```php
php -S localhost:8000 -t /path/to/project/public/
```

```python
python manage-py runserver
```

Para o PHP seguido pelo Django, respectivamente.

### *run interactively

Novamente, não é um comando.

Às vezes, quero testar uma função, ou sintaxe. Pra isso, vou escrever interativamente minhas linhas de código.

```php
php -a
```

```python
python
```

Para o PHP seguido pelo Django, respectivamente.

### ssh

Conecta com um servidor via linha de comando.

Certo. Isso é importante para você que possui algum servidor. Você também pode acessar via FTP, mas com ssh você tem mais poder.

```shell
ssh usuario@meuservidor.com.br
```

### shutdown

Desliga o computador.

Vez ou outra (raro) o computador trava. Com isso, tento acessar via linha de comando, e mandar ele reiniciar.

Dica: Aperte Ctrl + Alt + F1. Você estará em uma parte de linha de comando. Se o PC travou, venha aqui, logue, e digite sudo shutdown -r now, e ele irá reiniciar.

```shell
sudo shutdown -r now
```

**E você? Tem algum comando legal que eu não coloquei? Compartilhe nos comentários!**
