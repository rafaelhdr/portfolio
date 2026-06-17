---
layout: post
title:  "Website redesign with AI"
date:   2026-06-17 14:00:00 0100
categories: web ai portfolio rafaelhdr jekyll docker
permalink: blog/website-redesign-with-ai
lang: en
excerpt: "Why and how I did the redesign of my own website"
---
# Website redesign of rafaelhdr.com.br

AI came, and this is the first time I am updating this website using AI.

This technology is not something new for me. I use it daily at work/personal life. I already had experience.

But for so long I wanted to update my portfolio, but had other priorities.

## Motivation

I am looking for a new job. It has been 8 years in The Silver Logic. There was a lot of learning, but since last year it was clear for me that I wanted to change. And in January I communicated to boss/peers/friends.

Lately I have been more focused on this. And I wasn't very proud of the current version of rafaelhdr.com.br (design-wise).

Honestly, design is not my strongest skill, but I wanted to have something nice for visitors. Something I am proud of (previously, the homepage had just a hello from me)

I am happy for now. It definitely can be improved, but I could do it another time. So far, it is enough.

## References

I had some friends websites as first reference. Something to start with:

* [alexandreanicio.dev](https://alexandreanicio.dev/)
* [samueljansem.dev](https://samueljansem.dev/contact/)

And then I went to [Reddit](https://www.reddit.com/r/webdev/comments/143acrg/show_me_your_portfolios/)

It has so many good examples. But some of them are too much (great, but I wouldn't focus on achieve that). Like this running an OS in the browser [dustinbrett.com](https://dustinbrett.com/) or this very beautiful one [alyssafaustino.com](https://alyssafaustino.com/).

But then I got 3 that were really good reference. I was gonna base my redesign having them as reference:

* [gianmarcocavallo.com](https://gianmarcocavallo.com/)
* [radnaabazar.com](https://www.radnaabazar.com/en)
* [m7mad.dev](https://m7mad.dev/)

And finally, when I want to explain something for the AI, or even to have a good example for myself, I am going to [Dribbble](https://dribbble.com/).

## What I did

I started by making the AI get context, and then generate the AGENTS.md (for future prompts).

And second, I was upgrading the packages, Docker, Ruby, Jekyll etc. And created the docker compose for easier local testing.

Finally, divide and conquer. I was accessing each page, and working on what was bothering me. What is not clear, and what could be better. This process included opening the other devs' portfolio websites to get some ideas.

The development was just done by AI. I still review what is happening (to see if something is going very wrong). For example, for some reason it converted a page to HTML (totally unnecessary, and I would like still review/write content, and markdown is much easier for that).

But everything was very quick to do. It is hard to compare with the method I used to do years ago.

## Tools used

I didn't use Claude (or ChatGPT). This process is also a learning for myself. The Silver Logic adopted Claude, investing in workshops and learning. I still have a lot to learn on that, but I want to test alternatives in my personal time.

The reason for alternatives are mainly because I don't like much to be locked. I would like to know the options, and be able choose what to use. And I see a lot of potential. For example, in a side project, I am doing a lot of small easy AI tasks. For that, I want to use a cheap/quick AI model. For other tasks, I would like to pay more, in order to save my time.

Nowadays, I am using these 2 tools:

### AionUI

Source: [AionUI](https://aionui.com/)

It can do a lot, and I still have a lot to learn. It has so many templates, and be able to connect to so many models (a few of them free).

It was helpful for the insight time. When I want to review some text, research some solutions. When it was more related to the product, and not specifically to the code, I was using it.

### OpenCode

Source: [OpenCode](https://opencode.ai/)

For coding itself, I am using it in the terminal.

If the task is small, just build it. I review and then it is merged.

If the task is medium or big, then I explain, give guidelines, and ask in the Plan mode. After the plan, I advise or do any adjustment, and then use the Build mode.

## Not fully AI

For building, it was great. But for the content, I still believe I should be the one generating the content.

In the end, it is my own website. It should have my personality, and my information here. But small adjustments, like adding URL and grammar review, is for AI.
