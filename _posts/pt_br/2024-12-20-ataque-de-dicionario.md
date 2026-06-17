---
layout: post
title:  "Como usar ataque de dicionário para quebrar uma senha"
date:   2024-12-15 14:00:00 0100
categories: segurança owasp
permalink: blog/dictionary-attack
lang: pt_br
excerpt: "Demonstra como realizar um ataque de dicionário contra uma página Django para fins educacionais de segurança."
---
# Como realizar um ataque de dicionário para quebrar uma senha

## Contexto

Ataque de dicionário consiste em usar uma lista de palavras comuns para tentar descobrir um segredo (por exemplo, a senha de um usuário).

Se um site não tiver proteção, ele pode ser comprometido por esse ataque.

Nesse post, vamos mostrar como realizar um ataque de dicionário. Ao final, teremos sugestões de como se proteger.

E para testar, nosso usuário terá a senha `1234567`, que é a nona senha mais comum de acordo com [Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:10,000_most_common_passwords).

## Atenção

**Aviso de ética:** Este guia é destinado apenas a fins educacionais e para testes autorizados de segurança. Certifique-se de ter permissão explícita antes de realizar ataques em qualquer sistema.

## Ambiente

Para simular o ataque, vamos rodar localmente uma página simples web usando Django.

Arquivo Dockerfile

```Dockerfile
FROM python:3.12-slim

WORKDIR /app

RUN pip install Django==5.1.4 && \
    django-admin startproject myproject . && \
    echo "STATIC_ROOT = '/app/static/'" >> myproject/settings.py && \
    python manage.py migrate && python manage.py collectstatic --noinput && \
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '1234567')" | python manage.py shell

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

E para rodar, basta executar o comando:

```
docker build -t unsafe-django .
docker run -p 8000:8000 unsafe-django`
```

E pronto. Você pode acessar a página em `http://localhost:8000/admin/`.

![Login do Django]({{"/assets/posts/2024-12-20-dictionary-attack/django-login.png"}})

## Burp Suite

O Burp Suite é uma das ferramentas mais populares para testes de segurança de aplicações web, amplamente utilizada por analistas de segurança e desenvolvedores para identificar vulnerabilidades como injeção de código, falhas de autenticação e exposição de dados sensíveis.

Para o ataque de dicionário, vamos usar o **Intruder**. Vamos fazer isso passo a passo.

Você pode instalar seguindo as intruções do link [Download and Install](https://portswigger.net/burp/documentation/desktop/getting-started/download-and-install).

### Usando Intruder

Abra seu Burp Suite.

![Página inicial do Burp]({{"/assets/posts/2024-12-20-dictionary-attack/burp-initial.png"}})

Estou usando a Community Edition, e com isso preciso apenas clicar em **Next**. Na janela seguinte **Start Burp**.

E agora temos ele pronto para começar a usar o Burp. Precisamos primeiro capturar nossa request. Vá na aba **Proxy** e clique em **Open Browser**.

Vamos usar esse Browser para detectar a request que queremos fazer o ataque. No caso, vamos fazer login.

Dentro do Browser, acesse `http://localhost:8000/admin/`. E no seu Burp Suite, clique em **Intercept off** (para começar a interceptar).

De volta ao browser, tente acessar com o usuário `admin` e uma senha qualquer como `123456` (supondo que não sabemos a senha do admin ainda). De volta ao Burp, você verá a request esperando. Queremos replicar ela, então clique com o botão direito e **Send to Intruder**.

![Burp proxy]({{"/assets/posts/2024-12-20-dictionary-attack/burp-btn-send-to-intruder.png"}})

E podemos ir para a aba **Intruder**.

Nessa aba nova, você verá a request que interceptamos. Selecione a senha que você utilizou e clique em **Add**.

![Burp Sniper Attack]({{"/assets/posts/2024-12-20-dictionary-attack/burp-sniper-attack.png"}})

Vamos usar **Simple List** como nosso Payload type. Com isso, iremos passar um arquivo com o nosso dicionário de senhas. Para o nosso exemplo, vou usar um dicionarário com apenas 20 senhas.

```txt
123456
password
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
123123
baseball
abc123
football
monkey
letmein
696969
shadow
master
666666
```

Eu peguei essas senhas do [Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:10,000_most_common_passwords). Basta salvar em um arquivo e selecionar ele no Burp (clicar em `Load...` e selecionar seu arquivo).

Com tudo isso pronto, você terá algo parecido com isso:

![Burp pronto para começar o ataque]({{"/assets/posts/2024-12-20-dictionary-attack/burp-ready-to-start.png"}})

Agora basta clicar em Start Attack. E você verá o Burp tentando todas as senhas do dicionário.

Após alguns instantes, você verá que a senha `1234567` foi encontrada.

![Resultados do Burp]({{"/assets/posts/2024-12-20-dictionary-attack/burp-results.png"}})

Nosso resultado é esse diferente em que temos o response code 302, e podemos ver qual foi a senha que deu certo (no caso, `1234567`).

## Como se proteger

Para se proteger de ataques de dicionário, você pode:

**Limitar o número de tentativas de login:** Usar ferramentas que limitem o número de tentativas de login, como lockouts, para evitar que um atacante tente várias senhas.

**Usar autenticação de dois fatores:** É uma boa solução também, pois mesmo que o atacante descubra a senha, ele ainda precisará de outro fator para acessar a conta. Por outro lado, é interessante ter outras formas também, caso contrário seu site poderá ser utilizado para descobrir senhas de outros serviços - por exemplo, caso seus usuários usem a mesma senha em vários sites.

**Usar senhas fortes:** É comum mostrar um indicador de quão forte é a senha para que o usuário possa saber se está usando senha muito fraca e evitar que seja descoberta facilmente.

**Monitorar tentativas de login:** Usar um serviço de monitoramento de segurança para identificar tentativas de login suspeitas.

**Login sem senha:** Outra forma de se proteger é não usar senha. Existem outras formas de autenticação, como fazer o login usando o Google, Facebook, ou envio de token por e-mail.

## Conclusão

Esse post foi focado em mostrar como um ataque de dicionário pode ser feito e trazer indicações de como se proteger.

Há diversas formas de se proteger, mas quis apenas explicá-las superficialmente, pois a proteção vai depender bastante de qual linguagem/frameworks você usa.
