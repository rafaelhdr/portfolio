---
layout: post
title:  "Django queryset annotated timezone"
date:   2024-07-15 08:00:00 -0300
categories: django queryset
permalink: blog/django-queryset-with-timezones
lang: pt_br
---
# Django queryset annotated timezone

## TL;DR

```
    def annotate_tz_aware(self, dt):
        sql_date = dt.strftime("%Y-%m-%d")
        return (
            self
            .annotate(
                dt=RawSQL("(%s || ' ' || time || ' ')::timestamp AT TIME ZONE timezone", (sql_date,)),
            )
        )
```

Annotate dessa linha passando a data (`sql_date`)

## Cenário

Vamos imaginar o seguinte cenário. Você possui seu model com date e time naive com um campo separado para timezone. E na queryset você precisa ordenar ou filtrar. Você pode usar um annotation para poder ordenar o que vem antes variando com o timezone.

> Por que não usar datetime com timezone convertendo para UTC em todos? No meu caso em específico, eu precisava de eventos recorrentes, preferindo deixar date e time naive, e fazendo as conversões pela própria queryset ou ao retornar ao usuário.

## Código base

Tendo como base o seguinte repositório [GitHub](https://gitlab.com/rafaelhdr/dj_queryset_timezone).

Vamos olhar o models.py:

```
class Event(models.Model):
    name = models.CharField(max_length=100)
    weekdays = models.CharField(max_length=100)
    time = models.TimeField()
    timezone = models.CharField(max_length=100)
```

E o seguinte teste:

```
    def test_sort_different_tz_events(self):
        london_event = Event.objects.create(
            name='Event 1',
            weekdays='mon,tue,wed,thu,fri',
            time='12:00',
            timezone='Europe/London',
        )
        paris_event = Event.objects.create(
            name='Event 2',
            weekdays='mon,tue,wed,thu,fri',
            time='12:01',
            timezone='Europe/Paris',
        )

        dt = date(2024, 7, 15)
        events = Event.objects.annotate_tz_aware(dt).order_by('dt')
        assert events[0] == paris_event
        assert events[1] == london_event
```

Nesse teste, o evento em Londres acontece às 12:00 de Londres, que seria 11:00 UTC. Mas o event de Paris deve acontecer antes, pois é 12:01 de Paris, mas 10:01 UTC.

Consegui alcançar o objetivo com RawQuery fazendo o seguinte annotation:

```
class EventManager(models.Manager):

    def annotate_tz_aware(self, dt):
        sql_date = dt.strftime("%Y-%m-%d")
        return (
            self
            .annotate(
                dt=RawSQL("(%s || ' ' || time || ' ')::timestamp AT TIME ZONE timezone", (sql_date,)),
            )
        )


class Event(models.Model):
    name = models.CharField(max_length=100)
    weekdays = models.CharField(max_length=100)
    time = models.TimeField()
    timezone = models.CharField(max_length=100)

    objects = EventManager()
```

Vou explicar cada passo do `annotate_tz_aware`.

* Usamos o `dt` para passar qual data está sendo feita a comparação. Isso é necessário pois fazemos a comparação no mesmo timezone (UTC no exemplo) e precisamos da data caso seja convertido para o dia seguinte.
** Exemplo: 2:00 em Sydney (Austrália) seriam 15h do dia anterior em UTC. Precisamos levar isso em consideração na hora da conversão.
** Por que não usar uma data aleatória? Pois dependendo da data do ano, temos o horário de verão, então essa conversão será diferente.
* `"(%s || ' ' || time || ' ')::timestamp` esse trecho é apenas para concatenar como um datetime sem a noção de timezone.
* `AT TIME ZONE timezone` vamos forçar que o resultado seja no timezone do evento. E dessa forma fazemos a comparação com o datetime ciente do timezone na hora de ordenar.

## Simplificação

Esse foi um jeito bem simplificado do que fiz. No caso, não verifiquei se dt tem o weekday do evento. Mas espero ter passado a ideia principal.
