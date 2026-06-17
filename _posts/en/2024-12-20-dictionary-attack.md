---
title:  "Dictionary Attack - How to brute force a password"
date:   2024-12-15 14:00:00 0100
categories: security burp
permalink: blog/dictionary-attack
lang: en
excerpt: "Demonstration on performing a dictionary attack using Burp Suite against a Django login, with countermeasure suggestions."
---
# How to Perform a Dictionary Attack to Crack a Password

## Context

A dictionary attack involves using a list of common words to try to discover a secret (e.g., a user's password).

If a website lacks proper protections, it can be compromised by such an attack.

In this post, we will show how to perform a dictionary attack. At the end, we will provide suggestions on how to protect yourself.

For our test, the user's password will be `1234567`, which is the ninth most common password according to [Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:10,000_most_common_passwords).

## Disclaimer

**Ethics Warning:** This guide is intended for educational purposes only and for authorized security testing. Ensure you have explicit permission before performing attacks on any system.

## Environment

To simulate the attack, we will locally run a simple web page using Django.

### Dockerfile

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

To run the setup, execute the following commands:

```
docker build -t unsafe-django .
docker run -p 8000:8000 unsafe-django`
```

Once complete, you can access the page at `http://localhost:8000/admin/`.

![Login do Django]({{"/assets/posts/2024-12-20-dictionary-attack/django-login.png"}})

## Burp Suite

Burp Suite is one of the most popular tools for web application security testing, widely used by security analysts and developers to identify vulnerabilities such as code injection, authentication flaws, and sensitive data exposure.

For the dictionary attack, we will use the **Intruder** tool. Let's go step by step.

You can install Burp Suite by following the instructions at [Download and Install](https://portswigger.net/burp/documentation/desktop/getting-started/download-and-install).

### Using Intruder

Open your Burp Suite.

![Burp Initial Screen]({{"/assets/posts/2024-12-20-dictionary-attack/burp-initial.png"}})

I am using the Community Edition, so I just need to click **Next** and then **Start Burp** in the following window.

Now Burp is ready to use. First, we need to capture our request. Go to the **Proxy** tab and click **Open Browser**.

We will use this browser to detect the request we want to attack. In this case, it's the login.

In the browser, go to `http://localhost:8000/admin/`. In your Burp Suite, click **Intercept Off** (to start intercepting requests).

Back in the browser, try logging in with the username `admin` and any password, such as `123456` (assuming we don’t know the admin password yet). Back in Burp, you will see the intercepted request waiting. We want to replicate it, so right-click on it and select **Send to Intruder**.

![Burp Proxy]({{"/assets/posts/2024-12-20-dictionary-attack/burp-btn-send-to-intruder.png"}})

Now, we can go to the **Intruder** tab.

In this new tab, you will see the intercepted request. Select the password value you used and click **Add**.

![Burp Sniper Attack]({{"/assets/posts/2024-12-20-dictionary-attack/burp-sniper-attack.png"}})

We will use **Simple List** as our Payload type. This allows us to provide a file containing our password dictionary. For this example, I will use a dictionary with only 20 passwords.

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

I took these passwords from [Wikipedia](https://en.wikipedia.org/wiki/Wikipedia:10,000_most_common_passwords). Just save them to a file and load it into Burp (click `Load...` and select your file).

With everything ready, you should see something like this:

![Burp Ready to Start]({{"/assets/posts/2024-12-20-dictionary-attack/burp-ready-to-start.png"}})

Now click **Start Attack**, and you will see Burp attempting all the passwords in the dictionary.

After a few moments, you will see that the password `1234567` was successfully found.

![Burp Results]({{"/assets/posts/2024-12-20-dictionary-attack/burp-results.png"}})

The successful result is evident by the response code 302, and we can see the correct password (`1234567`).

## How to Protect Yourself

To protect against dictionary attacks, you can:

**Limit the number of login attempts:** Use tools to limit the number of login attempts, such as lockouts, to prevent attackers from trying multiple passwords.

**Use two-factor authentication (2FA):** This is an effective solution because even if the attacker discovers the password, they will still need another factor to access the account. However, consider providing alternative methods to prevent your site from being used to test passwords from other services (e.g., if users reuse passwords).

**Use strong passwords:** Provide a password strength indicator to help users understand if their password is too weak and easily discoverable.

**Monitor login attempts:** Use a security monitoring service to identify suspicious login attempts.

**Passwordless login:** Consider alternative authentication methods, such as logging in with Google, Facebook, or email-based tokens.

## Conclusion

This post focused on demonstrating how a dictionary attack can be executed and provided suggestions on how to protect against it.

There are various ways to enhance security, but these were briefly explained since the best solutions depend significantly on the language/frameworks you use.
