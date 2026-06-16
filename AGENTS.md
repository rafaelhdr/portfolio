# AGENTS.md

## Project overview

Personal website/blog built with Jekyll. Multi-language (EN / PT-BR) via `jekyll-polyglot`. Uses the `minima` theme with custom SCSS overrides.

## Tech stack

| Layer | Tool | Version |
|-------|------|---------|
| Runtime | Ruby | 3.4.9 |
| SSG | Jekyll | 4.4.x |
| Theme | minima | 2.5.x |
| Server | webrick | 1.9.x |
| i18n | jekyll-polyglot | 1.13.x |
| Dev env | Docker (compose) | — |

No Node.js, no frontend build pipeline — pure Jekyll with SCSS.

## Key commands

```sh
# Local dev (Docker)
docker compose up                 # serves on http://localhost:4000

# Build (no Docker)
bundle exec jekyll build          # outputs to _site/

# Update gems
bundle update
```

## Directory structure

```
.
├── _config.yml          # Jekyll config (theme, plugins, languages, URL…)
├── _includes/           # HTML partials (head.html, scripts.html…)
├── _layouts/            # Post/page layout templates
├── _posts/
│   ├── en/              # English blog posts
│   └── pt_br/           # Portuguese blog posts
├── _sass/               # Custom SCSS partials (color.scss, syntax…)
├── css/style.scss       # Main stylesheet, imports _sass/ partials
├── assets/              # Images, main.scss (imports minima), etc.
├── pages/               # Static pages (about, portfolio…)
├── Dockerfile
├── docker-compose.yml
├── Gemfile / Gemfile.lock
├── .gitlab-ci.yml       # Deploy pipeline (GitLab Pages)
└── .gitignore
```

## Conventions

- No comments unless necessary — keep code self-explanatory.
- Follow existing naming and style patterns when adding new posts or pages.
- Blog posts use filename format `YYYY-MM-DD-slug.md` with YAML front matter.
- Both languages (`_posts/en/` and `_posts/pt_br/`) must have matching posts with the same filename.

## Language / i18n

Controlled by `jekyll-polyglot`. Config in `_config.yml`:
- `languages: ["en", "pt_br"]`
- `default_lang: "en"`
- `parallel_localization: true`

To add a new language, update the `languages` array and duplicate `_posts/en/` posts to the new language directory.

## Dockerfile notes

- Based on `ruby:3.4.9-slim-bookworm`
- Workdir is `/app`
- CMD is `jekyll serve --host 0.0.0.0`
- Known bug: `bundler install` (line 7) is a typo — should be `bundle install`. Doesn't break the build because `bundler` also resolves (Bundler gem ships with a `bundler` binary).

## Deploy

Push to `master` → GitLab CI builds with `ruby:3.4.9-bookworm` → deploys to GitLab Pages.
