---
layout: post
title:  "Shereland open-source"
date:   2018-03-11 12:00:00 -0300
categories: shereland open-source
permalink: blog/shereland-open-source
lang: en
excerpt: "Announces a book-sharing web app rebuilt with microservices, GraphQL, and Go, using 8 Docker images orchestrated together."
---
# Shereland open-source

Shereland is a site for sharing books. It is useful for finding what books your friends could lend to you.

It was developed using Python Django, being a good playground for trying new technologies and learning.

But after a lot of new things at my last company, I wanted to change it, using microservices, graphql and Go.

## Why

**Microservices** - I like infrastructure and microservices will help me to make a better infrastructure for my projects.

**Graphql** - It is awesome. Very easy to update and work with.

**Go** - Actually, I am still learning. I could make it much faster with node.js and Python. So, I am forcing myself to do things in Go and learn it.

## Status

It is composed of 8 Docker images:

1. Caddy Server - HTTP Server with Let's Encrypt (not mine: [source](https://github.com/abiosoft/caddy-docker))
1. Graphql - Front service working as an API ([source](https://gitlab.com/shereland/graphql)). It is too big (now) because I added all logic to it. It is supposed to be separated into more microservices.
1. Monolithic DB - The database for everything. It is supposed to be split into several databases, one for each microservice (MariaDB).
1. MySQL Docker Backuper - Service for backup the database ([source](https://github.com/rafaelhdr/mysql-docker-backuper)).
1. Shereland - The Python Django project that I created (closed-source).
1. Redis DB - Store users sessions and on future work as a cache.
1. Thumbnail - Only for albuns from the blog, using imaginary (not mine: [source](https://github.com/h2non/imaginary)). Actually, it is temporary. I want the album thumbnail being generated when the photo is uploaded (instead of resizing when a user opens the post page).
1. Web - Front service for HTML ([source](https://gitlab.com/shereland/web)).

It is accessible via [beta](https://beta.shereland.com/blog/). After bugfixes and more tests, I will use it as default.

## Regrets

I wanted the first release very simple. All requests to `/blog/*` are redirected to the new service. I wanted to improve it first because it has a lot of access (SEO).

But if I would take the decision again, I would start with something even simpler, with only graphql and HTML handled by the legacy website.

## About the tests

**web** microservice has nice tests (Unit Tests and Integration Tests with Pact). But I didn't code tests for **graphql**. Why?

A little time after developing the **web** microservice I saw an interesting [post about monitoring "Testing Microservices, the sane way"](https://medium.com/@copyconstruct/testing-microservices-the-sane-way-9bb31d158c16). I also saw the "Service Reliability Hierarchy" from [Google SRE Book](https://landing.google.com/sre/book/chapters/part3.html). So, I decided to focus on monitoring.

## Future

There are a lot of work to do on Shereland. My focus will be automation and later monitoring. The first and second way (check [The Three Ways](https://itrevolution.com/the-three-ways-principles-underpinning-devops/)).

Automation: Build the pipeline for `graphql` and `web` microservices.

Monitoring: Add Prometheus to check my performance metrics.
