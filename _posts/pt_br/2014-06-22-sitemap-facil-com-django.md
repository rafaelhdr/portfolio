---
layout: post
title:  "Sitemap fácil com Django"
date:   2014-06-22 12:00:00 -0300
categories: django sitemap
permalink: blog/python-django/sitemap-facil-com-django
lang: pt_br
---
# Sitemap fácil com Django

Confesso que demorei um pouco para fazer meu sitemap.xml funcionar na primeira vez, ao utilizar o Django. Mas ele é bastante simples, e vou tentar explicar em como fazê-lo funcionar com alguns poucos passos.

Para isso, vamos fazer um sitemap para um blog, em que temos páginas estáticas e posts do blog.

Observação: Para fazê-lo funcionar, iremos editar apenas o arquivo urls.py. Adicione as informações após o que você já possui no urls.py (com exceção do from ... import ...)

## Classes de sitemap

Para começar, vamos utilizar duas classes de sitemap. Uma delas será para buscar os posts (BlogSiteMap), e outra será para as páginas estáticas (ViewSitemap).

from django.contrib.sitemaps import Sitemap

```python
# ... (códigos que você já tem o urly.py)
class BlogSitemap(Sitemap):
    priority = 0.5
    def items(self):
        return Post.objects.all() # Não esquecer de importar Post
    def lastmod(self, obj):
        return obj.pub_date

class ViewSitemap(Sitemap):
    priority = 0.5
    def items(self):
        return ['home', 'about_us', 'contact', 'page1', 'page2']
    def location(self, item):
        return reverse(item)
```

Em ambas em defini uma prioridade default de 0.5 (mude como achar melhor), mas as outras informações ele descobre com cada objeto.

## BlogSitemap

Em items, ele retornará todos os objetos da minha lista de posts. Para obter a última modificação, apenas informei que essa informação está no atributo pub_date do objeto post. E para descobrir a localização (a url), minha classe tem uma função chamada get_absolute_url, que é utilizado para descobrir.

Se não conhece o get_absolute_url, basta criar uma função no seu model com esse nome, e retornar a página (não precisa de protocolo nem domínio, pois isso é responsabilidade de outras classes. No caso, Site, que normalmente vem implementada). Se quiser saber mais, veja na [documentação oficial](https://docs.djangoproject.com/en/1.8/ref/models/instances/#get-absolute-url).

## ViewSitemap

Em items, eu mesmo defini as páginas. Como são strings, não possuem o método get_absolute_url, e então defini na mão como obter sua localização. Esse método reverse é ótimo para que ele mesmo busque de minhas urls, pois caso eu resolva mudar a url, não preciso ficar caçando no código onde alterar.

## Inserindo na urls.py

E mais o código abaixo, está quase pronto.

```python
sitemaps = {
        'blog': BlogSitemap,
        'book': BookSitemap,
        'views': ViewSitemap,
}
urlpatterns += patterns('',
        (r'^sitemap\.xml$', 'django.contrib.sitemaps.views.sitemap', {'sitemaps': sitemaps}),
)
```

O que você fez, foi cadastrar essas informações de sitemaps para que o próprio gerador do Django cuide do resto.

## Configurações
Últimos detalhes para funcionar.

É preciso editar o seu settings.py, adicionando 'django.contrib.sitemaps' aos seus INSTALLED_APPS.

E também cadastrar no seu BD (normalmente utilizando o admin) com o seu próprio site. Normalmente ele vem como localhost (como na imagem abaixo):

![sitemap rafaelhdr]({{"/assets/posts/2014-06-22-sitemap-facil-com-django/sitemap-rafaelhdr.png" | absolute_url }})

Este é um jeito fácil de implementar o sitemaps.xml.

Mas há outras configurações, e você pode vê-las no site oficial: [https://docs.djangoproject.com/en/1.8/ref/contrib/sitemaps/](https://docs.djangoproject.com/en/1.8/ref/contrib/sitemaps/).
