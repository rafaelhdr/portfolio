---
title:  "Django queryset annotated timezone"
date:   2024-07-15 08:00:00 -0300
categories: django queryset
permalink: blog/django-queryset-with-timezones
lang: en
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

Annotate this line passing the date as argument (`sql_date`)

## Scenario

Let's say we have our model with naive date and time with a dedicated timezone field. In the queryset you want to sort or filter. You can use an annotation to sort what happens first depending on the timezone.

> Why not just use datetime aware of the timezone? In my case, I had recurrent events, and making it naive was required to compare events on different dates (some dates had different summertime).

## Code

I will use the following repository as reference [GitHub](https://gitlab.com/rafaelhdr/dj_queryset_timezone).

Let's check the models.py:

```
class Event(models.Model):
    name = models.CharField(max_length=100)
    weekdays = models.CharField(max_length=100)
    time = models.TimeField()
    timezone = models.CharField(max_length=100)
```

And the following test:

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

In this test, the event in London happens on 12:00 of London timezone, which is 11:00 UTC. But the event in Paris should happen first, because it is 10:01 UTC (12:01 of Paris).

I was able to achieve that with the following RawQuery annotation:

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

Let's check each step:

* We use `dt` to know which date is being used for the comparison. This is required because we do comparison at the same timezone (e.g. UTC) and we need the datetime to be converted to the following day.
** For example: 2:00 in Sydney (Australia) would be 15h of the previous day in UTC.
** Why not use a random date? Because depending on the date, we have summertime, and this conversion would be different.
* `"(%s || ' ' || time || ' ')::timestamp` this code is to concatenate the datetime naive.
* `AT TIME ZONE timezone` we force the result to be timezone aware. As result, we can compare datetimes aware of the different timezones between events.

## Simplified version

This was a simplified solution. In my case, I had to verify if the given dt belongs to the weekday of the event. But I hope this was good enough to share the main idea.
