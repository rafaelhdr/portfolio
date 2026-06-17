---
layout: post
title:  "rafaelhdr and Jekyll"
date:   2017-11-20 20:00:00 -0300
categories: rafaelhdr jekyll
permalink: rafaelhdr-new-website-with-jekyll
lang: en
excerpt: "Explains the migration from WordPress/Django to Jekyll for a bilingual, open-source personal website with CI/CD and S3 hosting."
---
# New rafaelhdr

And again I am changing my website. At first, I used WordPress, migrated to Django and now I am using Jekyll.

## Motivation

I wanted to make it bilingual and simple. Besides, I always like to learn new tech things.

## Why Jekyll

It covers all my motivation.

I wanted to learn it because a lot of people use it for GitHub. Several GitHub pages use it, so it is one more reason (over other static site generators alternatives).

## Advantages

* My site is now open-source;
* Cheap (S3 site, instead of EC2 running Docker);
* Versioned (git);
* CI/CD integration (GitLab Pipeline)
* High availability (99,99% [according to AWS](https://aws.amazon.com/s3/faqs/));
* Fast (tested with [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) - 63/100 improved to 89/100);
* It is Markdown.

## And more

The site is the same. I am keeping the old content, but not translating. New content will be bilingual.

The layout is not the best. It is simple (the default from Jekyll). I hope to work on it, but not for now.

I expect to post more. I am looking for new job and I think this will be a good opportunity to show myself. My next post will be about integrating static website with CloudFlare (that is what I am using for now).

Hope everybody likes it :)
