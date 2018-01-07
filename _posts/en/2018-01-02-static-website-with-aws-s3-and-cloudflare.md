---
layout: post
title:  "Static website with AWS S3 and CloudFlare"
date:   2018-01-01 22:00:00 -0300
categories: aws s3 cloudflare static website
permalink: blog/static-website-with-aws-s3-and-cloudflare
lang: en
---
# Static website with AWS S3 and CloudFlare

> Attention, the name CloudFlare (service) and CloudFront (Amazon service) look alike and it is easy to confuse it with the text.

## Cloudflare with AWS S3

I've just updated rafaelhdr using Jekyll. It is configured to be used with CloudFlare.

I am using it for all my websites, that is why I am not using AWS Route 53. If you want to develop a website with AWS Route 53, it is documented at [AWS Documentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html).

## Why Cloudflare

Using AWS Route 53 would be easier, but I don't own only rafaelhdr. Some sites are not hosted at AWS, so I choose to use a DNS service for all of them outside AWS.

## Requirements

For this tutorial, I am assuming you already know the basics of AWS S3, like upload files, and the basics of CloudFlare, like add the Domain.

## Introduction

We will make a simple website with a few HTML pages. I will not use some HTML generator (like Jekyll) because the objective is to learn about the infrastructure. If you want work with Jekyll, you can adapt the code from here with [s3_website plugin](https://github.com/laurilehmijoki/s3_website).

After we create our website at AWS S3, we will configure it with CloudFlare (and also with CloudFront).

## AWS S3 Website

### Create the bucket

We will upload via console at our new bucket.

The bucket names must match the names of the website that you are hosting. So, if your site is *example.com*, your bucket name is *example.com*. Use the default parameters, except **Manage public permissions** selecting the **Grant public read access to this bucket**.

Actually, the public access is only necessary for this tutorial. For production purposes, you don`t need it.

### Upload the files

Let's create a simple website, with 3 files. `index.html`, `page` and `subdir/index.html` (you can download these files [here]({{"/assets/posts/2018-01-02-static-website-with-aws-s3-and-cloudflare/pages.zip" | absolute_url }}), to save time).

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

Access your bucket, and upload the three files (with public access).

> For this tutorial, you need to edit `page` metadata. Click on `page` file, select Metadata and edit Content-type to `text/html`.

Get the site URL at the bucket, and test your new website. For now, click on the file and click at the link.

The pages work fine, but not the links. To fix it, we can just use **Static website hosting**.

1. Go to your bucket root;
1. Select **Properties**;
1. Select **Static website hosting**;
1. Select **Use this bucket to host a website**;
1. Fill **index.html** at **Index document**;
1. Copy the endpoint (top);
1. Save.

You can test and see all links working fine. The problem here is that we don't want this big amazon endpoint. So let's fix it with CloudFlare.

## Setting up CloudFlare

Configure your domain (in my case, it is rafaelhdr.com.br) at **Add site**, or just select your domain.

At DNS tab, add a CNAME with your domain (rafaelhdr.com.br) and add the endpoint you from AWS S3 website (you copied it at the last step) excluding the protocol, for example `YOUR_DOMAIN.s3-website-us-west-2.amazonaws.com`.

That is all. Your website is working with AWS S3 and Cloudflare.

## Using CloudFront

So, for now, you are using Full SSL with CloudFlare, but not Full (Strict). That means the connection between the client and CloudFlare is encrypted, but it is not between CloudFlare and AWS. You can solve this with AWS CloudFront.

Go to AWS Console, at CloudFront.

1. Create a Distribution;
1. Click on **Get started**;
1. Select your domain at **Origin Domain Name**. Keep all default options, except:
   * **Viewer Protocol Policy** select **Redirect HTTP to HTTPS**;
   * **Price Class** select **Use only US, Canada and Europe**;
   * **Alternate Domain Names (CNAMEs)** add your domain;
   * **Default Root Object** set `index.html`;
   * Later, check all options and you can decide what is better for you;
1. Click on **Create distribution**.

You can see the progress, and after some time, it will change the Status **In progress** to **Deployed**.

At the **Domain name**, you will find out the domain name. You can test it.

And at last, you can edit your CloudFlare DNS. Change your CNAME from the **AWS S3 Static Website address** to the **AWS CloudFront Domain Name** (`SOMETHING.cloudfront.net`).

Now, your site is working AWS S3 and CloudFront using CloudFlare CDN.
