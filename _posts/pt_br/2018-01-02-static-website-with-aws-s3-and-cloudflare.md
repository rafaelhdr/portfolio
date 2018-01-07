---
layout: post
title:  "Site estático com AWS S3 e CloudFlare"
date:   2018-01-01 22:00:00 -0300
categories: aws s3 cloudflare static website
permalink: blog/static-website-with-aws-s3-and-cloudflare
lang: pt_br
---
# Site estático com AWS S3 e CloudFlare

> Atenção, os nomes CloudFlare (serviço próprio) e CloudFront (serviço da Amazon) são muito parecidos e então fácil de ser confundido no texto.

## Cloudflare com AWS S3

Acabei de atualizar o site rafaelhdr usando o Jekyll. Ele foi configurado para ser usado com o CloudFlare.

Estou usando-o para todos os meus sites, por isso não uso o AWS Route 53. Se quiser desenvolver seu site com o AWS Route 53, está documentado em [AWS Documentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html).

## Por que Cloudflare

Usar AWS Route 53 seria mais fácil, mas não possuo apenas o rafaelhdr. Alguns sites não estão hospedados na AWS, então escolhi usar um servidor DNS para todos eles fora da AWS.

## Requerimentos

Para esse tutorial, estou assumindo que você sabe o básico de AWS S3, como subir arquivos, e o básico de CloudFlare, como adicionar um domínio.

## Introdução

Vamos fazer esse site com poucas páginas HTML. Não vou usar um gerador HTML (como o Jekyll) porque o objetivo aqui é aprender sobre a infraestrutura. Se quiser desenvolver com o Jekyll, você pode adaptar o código daqui com o [plugin s3_website](https://github.com/laurilehmijoki/s3_website).

Depois que criarmos nosso site na AWS S3, iremos configurá-lo com o CloudFlare (e também com o CloudFront).

## AWS S3 Website

### Criar o bucket

Faremos o upload via console de nosso novo bucket.

O nome do bucket deve ser o mesmo nome de seu website. Então, se você estiver criando um site chamado *example.com*, o nome de seu bucket deve ser *example.com*. Use os parâmetros padrão, exceto **Manage public permissions** selecionando **Grant public read access to this bucket**.

Na verdade, esse acesso público é apenas para esse tutorial. Em produção, você não precisa dele.

### Subir os arquivos

Vamos criar um site simples com três arquivos. `index.html`, `page` e `subdir/index.html` (você pode baixá-los [aqui]({{"/assets/posts/2018-01-02-static-website-with-aws-s3-and-cloudflare/pages.zip" | absolute_url }}), para economizar tempo).

```html
<!-- index.html -->
<h1>Home</h1>

<ul>
    <li>Home - <a href="/">/</a> or <a href="/index.html">/index.html</a></li>
    <li>Page - <a href="/page">/page</a></li>
    <li>Sub-index - <a href="/subdir">/subdir</a> or <a href="/subdir/">/subdir/</a> or <a href="/subdir/index.html">/subdir/index.html</a></li>
</ul>
```

```html
<!-- page -->
<h1>Page</h1>

<ul>
    <li>Home - <a href="/">/</a> or <a href="/index.html">/index.html</a></li>
    <li>Page - <a href="/page">/page</a></li>
    <li>Sub-index - <a href="/subdir">/subdir</a> or <a href="/subdir/">/subdir/</a> or <a href="/subdir/index.html">/subdir/index.html</a></li>
</ul>
```

```html
<!-- subdir/index.html -->
<h1>Sub-index</h1>

<ul>
    <li>Home - <a href="/">/</a> or <a href="/index.html">/index.html</a></li>
    <li>Page - <a href="/page">/page</a></li>
    <li>Sub-index - <a href="/subdir">/subdir</a> or <a href="/subdir/">/subdir/</a> or <a href="/subdir/index.html">/subdir/index.html</a></li>
</ul>
```

Acesse seu bucket, e suba esses três arquivos (com acesso público).

> Para esse tutorial, você precisa editar o metadata de `page`. Clique em `page`, selecione Metadata e edite Content-type para `text/html`.

Pegue a URL de seu bucket e teste seu novo site. Por agora, cliquei no arquivo e em seu link.

As páginas funcionam bem, mas não os links. Para consertar, vamos utilizar **Static website hosting**.

1. Vá na raiz de seu bucket;
1. Selecione **Properties**;
1. Selecione **Static website hosting**;
1. Selecione **Use this bucket to host a website**;
1. Preencha **index.html** em **Index document**;
1. Copie o endpoint (em cima);
1. Salve.

Você pode testar e ver todos os links funcionando bem. O problema aqui é que não queremos esse link imenso de endpoint da amazon. Ajustamos isso com o CloudFlare.

## Configurando o CloudFlare

Configure seu domínio (em meu caso, é rafaelhdr.com.br) em **Add site**, ou apenas selecione seu domínio.

Na aba DNS, adicione o CNAME com seu domínio (rafaelhdr.com.br) e adicione o endpoint que você copiou do AWS S3 website (que você copiou no último passo) excluindo o protocolo, por exemplo `YOUR_DOMAIN.s3-website-us-west-2.amazonaws.com`.

E pronto. Seu site está funcionando com AWS S3 e CloudFlare.

## Usando o CloudFront

Então, por agora, você está usando Full SSL with CloudFlare, mas não Full (Strict). Isso significa que a conexão entre o cliente e o CloudFlare está encriptada, mas não a conexão entre o CloudFlare e AWS. Você pode resolver isso com o AWS CloudFront.

Vá no Console da AWS, em CloudFront.

1. Clique em **Create a Distribution**;
1. Clique em **Get started**;
1. Selecione o seu domínio em **Origin Domain Name**. Mantenha todas as opções padrão, exceto:
   * **Viewer Protocol Policy** selecione **Redirect HTTP to HTTPS**;
   * **Price Class** selecione **Use only US, Canada and Europe**;
   * **Alternate Domain Names (CNAMEs)** adicione o seu domínio;
   * **Default Root Object** coloque `index.html`;
   * Depois, cheque todas as opções que melhor se encaixam para você;
1. Clique em **Create distribution**.

Você pode ver o progresso, e depois de um tempo, irá mudar o status de **In progress** para **Deployed**.

Em **Domain name**, você verá o nome de domínio. Você pode testá-lo.

E por fim, você pode editar o DNS do CloudFlare. Mude o CNAME que tinha o seu **AWS S3 Static Website address** para **AWS CloudFront Domain Name** (`SOMETHING.cloudfront.net`).

Agora seu site está funcionando com AWS S3 e CloudFronto usando o CDN do CloudFlare.
