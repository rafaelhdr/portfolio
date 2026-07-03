---
layout: post
title:  "Claude salvando contexto com /branch"
date:   2026-07-03 14:00:00 0100
categories: ai claude-code produtividade contexto
permalink: blog/saving-context-using-branch
lang: pt_br
excerpt: "Como usar o /branch no Claude Code para organizar o trabalho e manter o contexto pequeno"
---
# Salvando contexto com /branch

Aprendi recentemente como usar branches no Claude Code corretamente para organizar o trabalho e manter o contexto sob controle.

## O problema dos contextos grandes

O contexto cresce muito conforme a conversa avança. Em algum momento, a IA tenta resumir tudo para economizar tokens e evitar o context rot.

> Context rot is the performance degradation that happens when LLMs have to process increasingly long input contexts. Your LLM's performance degrades when it has to search through longer contexts to find relevant information, even though that information is technically available in the context window.

Fonte: [Context Rot – Redis](https://redis.io/blog/context-rot/)

## Sugestão

Existe o `/branch` no Claude, que basicamente separa sua conversa atual (incluindo o contexto) em uma nova thread. A nova thread tem o mesmo contexto de antes, e podemos fazer ações diferentes nela.

Então, você estabelece o contexto adequado (a partir da sua conversa). E em vez de executar todas as sugestões de uma vez, cada novo branch cuida de uma separadamente (assumindo que não têm relação entre si).

Exemplo:

```
# Ruim

Faça um plano para melhorar meu site (context+)

[Claude gerou um plano com sugestões X, Y e Z]

Faça X (context++)

[Claude faz]

Faça Y (context+++)

[Claude faz]

Faça Z (context++++)
```

```
# Melhor

Faça um plano para melhorar meu site (context+)

[Claude gerou um plano com sugestões X, Y e Z]
```

Com isso, abra mais 2 abas e rode `claude --resume` em cada uma (com a primeira, temos 3 no total)

```
Aba 1
/rename X
Faça X (context++)

Aba 2
/branch Y
Faça Y (context++)

Aba 3
/branch Z
Faça Z (context++)
```

## Exemplo (não) real

Vou mostrar um exemplo mínimo só para explicar como funciona.

### Contexto

Temos uma página simples de portfólio.

Adicionei 3 erros simples para serem corrigidos pela IA:

* Backend Engineer no topo e Fullstack Engineer no rodapé
* Erros de digitação como "passioante"
* Skill duplicada "HTML/CSS"

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

Plano:

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

O contexto está em `22.3k/200k tokens (11%)` (obtive isso rodando `/context`)

Agora temos 3 abas (esta primeira, e abrimos as outras 2. Você também pode usar tmux ou algo similar).

Na primeira, você mantém como está (ou usa `/rename fix typos` para facilitar a leitura). Na segunda, `/branch remove duplicate skill tag`. Na terceira, `/branch fix inconsistent job title`.

Agora temos 3 abas, cada uma com uma ação específica.

E então, em cada uma você pede para resolver:

* Fix typos
* Remove duplicate skill tag
* Fix inconsistent job title

Com isso, você pode ter tarefas do Claude (ou outra IA) rodando de forma simultânea e otimizada.

## Contexto utilizado

Este é só um exemplo simples com prompts pequenos — não é um benchmark. Mas só para ilustrar a ideia, fiz das duas formas e registrei o contexto.

### Solução única sem branch

Se fizermos tudo sem branches:

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

Dá para ver que vai crescendo devagar (mesmo usando prompts bem pequenos).

### Separando em branches

Quando dividimos em branches, cada um tem um contexto menor:

```
Aba 1:
Prompt: Make suggestions to improve this website page. Up to 3, as this is just an example.
/context: 22.3k/200k tokens
Prompt: Fix typos
/context: 26.3k/200k tokens

===========================
Aba 2:
Prompt: remove duplicate skill tag
/context: 26k/200k tokens

===========================
Aba 3:
Prompt: fix inconsistent job title
/context: 26.2k/200k tokens
```

## Conflitos entre as tarefas

Este é um exemplo com um único arquivo. Mas mesmo em projetos maiores, os branches podem tocar os mesmos arquivos.

Você pode evitar isso usando git worktrees (mas recomendo o worktrunk — muito amigável para devs, e cria uma pasta diferente para cada solução)

Worktrunk: [worktrunk.dev](https://worktrunk.dev/)

No meu caso, prefiro dar atenção adequada a cada tarefa. Para coisas pequenas (como corrigir um typo) não preciso disso, mas para problemas maiores eu faria X, resolveria, commitaria. Depois (no outro /branch) faria Y, e então Z.

# Leia mais

[Effective Context Engineering for AI Agents – Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

[Resume or fork sessions – Claude Code docs](https://code.claude.com/docs/en/how-claude-code-works#resume-or-fork-sessions)
