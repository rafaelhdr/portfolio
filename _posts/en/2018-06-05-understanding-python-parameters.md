---
layout: post
title:  "Understanding Python parameters"
date:   2018-06-05 08:00:00 -0300
categories: python parameter
permalink: blog/understanding-python-parameters
lang: en
---
# Understanding Python parameters

In this post, I will write a simple function `full_profile` explaining some concepts of the python parameters. With it, we can understand how the popular function `my_function(*args, **kwargs)` works.

## Positional argument

This is the first type of argument we see. The sequence of arguments given is used:

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

full_profile(1, "rafael", 30)
```

Result:

```shell
Id: 1
Name: rafael
Age: 30
```

## Keyword argument

Sometimes it is better to use keyword arguments to improve readability.

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

full_profile(1, name="rafael", age=30)
```

Result:

```shell
Id: 1
Name: rafael
Age: 30
```

IMO, I prefer keyword argument because it is more explicit (but not always, for example, a `sum(1, 2)` don't change by the argument order, so it is OK to keep positional argument).

## Force keyword argument

If you change the order of the arguments, you can have the following problem:

```python
def full_profile(id, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

# If you change the order for some reason, the result will be wrong
full_profile(1, 30, "rafael")
```

Result:

```shell
Id: 1
Name: 30
Age: rafael
```

You can force the arguments to be keyword argument only by using `*`:

```python
def full_profile(id, *, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")

# This will not work anymore
full_profile(1, 30, "rafael")

# This will work
full_profile(1, name="rafael", age=30)

# This result is the same
full_profile(1, age=30, name="rafael")
```

Result:

```shell
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
TypeError: full_profile() takes 1 positional argument but 3 were given

Id: 1
Name: rafael
Age: 30

Id: 1
Name: rafael
Age: 30
```

## Add not defined positional arguments

If we need to add more information passed by the user, but not defined by the function, we can use the args.

```python
def full_profile(id, *args, name, age):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)

full_profile(1, "I am a developer", name="rafael", age=30)
```

Result:

```shell
Id: 1
Name: rafael
Age: 30
I am a developer
```

Now we understand the `*args` of the default `my_function(*args, **kwargs)`.

> We don't need to use the name `args`. It could be named something else, like `extra`. It is just a convention.

## Add not defined keyword arguments

If we need more information passed by the user, but not by the function, we can also use the kwargs.

```python
def full_profile(id, *args, name, age, **kwargs):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{key}: {value}")

full_profile(1, "I am a developer", name="rafael", age=30, Company="rafaelhdr")
```

Result:

```shell
Id: 1
Name: rafael
Age: 30
I am a developer
Company: rafaelhdr
```

And now we understand the `**kwargs` of the default `my_function(*args, **kwargs)`.

> Again, the `kwargs` is the convention, but you could use another name.

If we use the default `my_function(*args, **kwargs)` it will handle all the cases. But the arguments are all optional. If we define them in function arguments and the user don't set it, an error will be raised:

```python
def full_profile(id, *args, name, age, **kwargs):
    print(f"Id: {id}")
    print(f"Name: {name}")
    print(f"Age: {age}")
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{key}: {value}")

# age is removed of the arguments
full_profile(1, "I am a developer", name="rafael", Company="rafaelhdr")
```

Result:

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: full_profile() missing 1 required keyword-only argument: 'age'
```

# args and kwargs

We can think that `*args` is a List of **positional arguments** not defined and `**kwargs` is a Dictionary of the **keyword arguments** not defined.

## Reference

[Python Glossary - term parameter](https://docs.python.org/3/glossary.html#term-parameter)
