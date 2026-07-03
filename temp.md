
# Saving context using /branch

I had a nice lesson learned recently. How to use branches (in claude code) properly in order to organize our work. Targeting better usage of the context.

There are more than one way to prevent that, and now I would like to share how to do it using /branch from Claude

## Issue of large contexts

The context grows a lot with our usage of the conversation. Let's say we have a longer conversation, the AI tries to summarize it, in order to save token and avoid the context rot.

> Context rot is the performance degradation that happens when LLMs have to process increasingly long input contexts. Your LLM's performance degrades when it has to search through longer contexts to find relevant information, even though that information is technically available in the context window.

Source: https://redis.io/blog/context-rot/

## Suggestion

There is this `/branch` in Claude, which basically separate your current conversation (including context) into a new thread. The new thread has the same context as before, and we can do different actions.

So, you give the proper context (from your conversation). And instead of doing all suggestions at once, each new branch do it separated (assuming they are unrelated).

Example:

```
Bad

Make a plan to improve my website (context+)

[Claude generated some plan with suggestion X, Y and Z]

Make X (context++)

[Claude do it]

Make Y (context+++)

[Claude do it]

Make Z (context++++)
```

```
Better

Make a plan to improve my website (context+)

[Claude generated some plan with suggestion X, Y and Z]
```

With this, open 2 tabs and run `claude --resume` (with this first one, we have 3)

```
Tab 1
/rename X
Make X (context++)

Tab 2
/rename Y
Make Y (context++)

Tab 3
/rename Z
Make Z (context++)
```

## (not) Real example

I will show something very small, just to explain how it works, but with a minimal example.

### Context

We have a single small page with a website portfolio.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>John Doe – Backend Engineer</title>
  <style>
    body { font-family: sans-serif; max-width: 700px; margin: 0 auto; padding: 20px; }
    header, footer { background: #1a1a2e; color: white; padding: 16px; text-align: center; }
    section { padding: 24px 0; border-bottom: 1px solid #eee; }
    .skills span { background: #e0e7ff; padding: 4px 10px; border-radius: 12px; margin: 4px; display: inline-block; }
  </style>
</head>
<body>

  <header>
    <h1>John Doe</h1>
    <p>Backend Engineer</p>
  </header>

  <section id="hero">
    <h2>Building robust systems from the ground up</h2>
    <p>Available for freelance and full-time oportunities.</p>
  </section>

  <section id="description">
    <p>I am a passioante developer with 5+ years of experianced building scalable APIs and microservices. I love clean code, performance tuning, and solving hard backend challanges.</p>
  </section>

  <section id="skills">
    <h3>Skills</h3>
    <div class="skills">
      <span>Python</span><span>Node.js</span><span>PostgreSQL</span>
      <span>Docker</span><span>HTML/CSS</span><span>HTML/CSS</span>
    </div>
  </section>

  <footer>
    <p>© 2026 John Doe – Fullstack Engineer</p>
  </footer>

</body>
</html>
```

### Prompts

Plan:

```
❯ Make suggestions to improve this portfolio.html. Up to 3, as this is just an example.

(...)

● Updated plan
/plan to preview
User rejected Claude's plan:
╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Plan: Improve portfolio.html                                                                                                                                                                                          │
│                                                                                                                                                                                                                       │
│ Context                                                                                                                                                                                                               │
│                                                                                                                                                                                                                       │
│ The user has a simple portfolio page (/tmp/claude/portfolio.html) for "John Doe – Backend Engineer" and wants up to 3 improvement suggestions. The page has clear, fixable issues that hurt professional credibility. │
│                                                                                                                                                                                                                       │
│ ---                                                                                                                                                                                                                   │
│ Suggestions                                                                                                                                                                                                           │
│                                                                                                                                                                                                                       │
│ 1. Fix typos in the hero and description sections                                                                                                                                                                     │
│                                                                                                                                                                                                                       │
│ The page has four spelling errors that undermine credibility for a professional portfolio:                                                                                                                            │
│ - Line 23: oportunities → opportunities                                                                                                                                                                               │
│ - Line 26: passioante → passionate                                                                                                                                                                                    │
│ - Line 26: experianced → experienced                                                                                                                                                                                  │
│ - Line 26: challanges → challenges                                                                                                                                                                                    │
│                                                                                                                                                                                                                       │
│ File: portfolio.html, lines 23 and 26                                                                                                                                                                                 │
│                                                                                                                                                                                                                       │
│ ---                                                                                                                                                                                                                   │
│ 2. Remove duplicate skill tag                                                                                                                                                                                         │
│                                                                                                                                                                                                                       │
│ HTML/CSS appears twice in the skills list (line 33). One instance should be removed.                                                                                                                                  │
│                                                                                                                                                                                                                       │
│ File: portfolio.html, line 33                                                                                                                                                                                         │
│                                                                                                                                                                                                                       │
│ ---                                                                                                                                                                                                                   │
│ 3. Fix inconsistent job title                                                                                                                                                                                         │
│                                                                                                                                                                                                                       │
│ The <header> calls him a "Backend Engineer" but the <footer> says "Fullstack Engineer". These must match — pick one and use it consistently (including in the <title> tag, which already says "Backend Engineer").    │
│                                                                                                                                                                                                                       │
│ File: portfolio.html, lines 5, 17, and 39                                                                                                                                                                             │
│                                                                                                                                                                                                                       │
│ ---                                                                                                                                                                                                                   │
│ Verification                                                                                                                                                                                                          │
│                                                                                                                                                                                                                       │
│ After applying changes:                                                                                                                                                                                               │
│ - Open portfolio.html in a browser and visually confirm the skills list, header, and footer                                                                                                                           │
│ - Run a spell-check or re-read lines 23 and 26 to confirm no remaining typos                                                                                                                                          │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

Good, and the context is `22.3k/200k tokens (11%)` (I got this running `/context`)

So, now we make the 3 tabs (this first one, and open other 2. You can also use tmux, or something similar).

In the first one, you keep it (or `/rename fix typos` for readability). For the second, `/branch remove duplicate skill tag`. For the third, `/branch fix inconsistent job title`.

Now, we have 3 tabs, with specific action for all of them.

And then, in each one of them you ask them to solve it:

* Fix typos
* Remove duplicate skill tag
* Fix inconsistent job title

With that, you can have concurrent and optimized Claude (or other AI) tasks running and solving your issue.

## Context used

This is not a good example, as a single file with tiny prompts. I really don't think it is a good benchmark. But just to share the idea, I made it in both approaches, and got the context just for understanding reasons.

### Single solutions without branch

If we do everything without the branches, we have this:

```
Prompt: Make suggestions to improve this website page. Up to 3, as this is just an example.
/context: 22.3k/200k tokens
Prompt: Fix typos
/context: 26.3k/200k tokens
Prompt: remove duplicate skill tag
/context: 28.6k/200k tokens
Prompt: fix inconsistent job title
/context: 31k/200k tokens
```

### Separate in branches

In case we create each branch, we have smaller context.

```
Tab 1:
Prompt: Make suggestions to improve this website page. Up to 3, as this is just an example.
/context: 22.3k/200k tokens
Prompt: Fix typos
/context: 26.3k/200k tokens

===========================
Tab 2:
Prompt: remove duplicate skill tag
/context: 26k/200k tokens

===========================
Tab 3:
Prompt: fix inconsistent job title
/context: 26.2k/200k tokens
```

## Conflicts between the work

This is a single file example. But even in bigger projects, they might touch the same files.

You can avoid that using git worktrees (but I recommend using worktrunk. Very dev friendly and create different folder for each solution)

Worktrunk: https://worktrunk.dev/
