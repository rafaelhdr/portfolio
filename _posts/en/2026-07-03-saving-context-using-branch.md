---
layout: post
title:  "Claude saving context using /branch"
date:   2026-07-03 14:00:00 0100
categories: ai claude-code productivity context
permalink: blog/saving-context-using-branch
lang: en
excerpt: "How to use /branch in Claude Code to organize work and keep context small"
---
# Saving context using /branch

I recently learned how to properly use branches in Claude Code to organize work and keep context under control.

## Issue of large contexts

The context grows a lot as the conversation progresses. At some point, the AI tries to summarize it to save tokens and avoid context rot.

> Context rot is the performance degradation that happens when LLMs have to process increasingly long input contexts. Your LLM's performance degrades when it has to search through longer contexts to find relevant information, even though that information is technically available in the context window.

Source: [Context Rot – Redis](https://redis.io/blog/context-rot/)

## Suggestion

There is this `/branch` in Claude, which basically separates your current conversation (including context) into a new thread. The new thread has the same context as before, and we can do different actions.

So, you give the proper context (from your conversation). And instead of doing all suggestions at once, each new branch handles it separately (assuming they are unrelated).

Example:

```
# Bad

Make a plan to improve my website (context+)

[Claude generated some plan with suggestion X, Y and Z]

Make X (context++)

[Claude do it]

Make Y (context+++)

[Claude do it]

Make Z (context++++)
```

```
# Better

Make a plan to improve my website (context+)

[Claude generated some plan with suggestion X, Y and Z]
```

With this, open 2 tabs and run `claude --resume` (with this first one, we have 3)

```
Tab 1
/rename X
Make X (context++)

Tab 2
/branch Y
Make Y (context++)

Tab 3
/branch Z
Make Z (context++)
```

## (not) Real example

I'll show a minimal example just to explain how it works.

### Context

We have a single small page with a website portfolio.

I added 3 simple mistakes to be fixed by AI:

* Backend Engineer at the top and Fullstack Engineer at the bottom
* Typos like "passioante"
* Duplicate skill "HTML/CSS"

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

So, now we have 3 tabs (this first one, and open the other 2. You can also use tmux, or something similar).

In the first one, you keep it (or `/rename fix typos` for readability). For the second, `/branch remove duplicate skill tag`. For the third, `/branch fix inconsistent job title`.

Now, we have 3 tabs, with specific action for all of them.

And then, in each one you ask it to solve:

* Fix typos
* Remove duplicate skill tag
* Fix inconsistent job title

With that, you can have concurrent and optimized Claude (or other AI) tasks running and solving your issue.

## Context used

This is just a simple example with tiny prompts. It is not supposed to be a benchmark, but just to share the idea, I made it in both approaches, and got the context just for understanding reasons.

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

We can see it is slowly growing (even if I did it using very small prompts).

### Separate in branches

When we split into branches, each one has a smaller context.

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

You can avoid that using git worktrees (but I recommend worktrunk — very dev-friendly, and it creates a different folder for each solution)

Worktrunk: [worktrunk.dev](https://worktrunk.dev/)

But in my case, I like to give proper attention to each task. I don't need this for tiny tasks (like fixing a typo), but for bigger issues I would do X, solve it, and commit. Then (in the other /branch) do Y, and then Z.

# Read more

[Effective Context Engineering for AI Agents – Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

[Resume or fork sessions – Claude Code docs](https://code.claude.com/docs/en/how-claude-code-works#resume-or-fork-sessions)
