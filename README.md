# Portfolio Site

Personal portfolio and blog built with Jekyll, deployed on GitHub Pages.

## Local development

```bash
bundle install
bundle exec jekyll serve
```

Open `http://localhost:4000`.

## Adding a project

Create a markdown file in `_projects/` with front matter:

```yaml
---
title: "Project Name"
category: "Category"
stack: ["Tech1", "Tech2"]
github: "https://github.com/michaelbarley/repo"
description: "One-line description."
order: 7
---
```

## Adding a blog post

Create a file in `_posts/` named `YYYY-MM-DD-title.md`:

```yaml
---
title: "Post Title"
date: YYYY-MM-DD
---
```

## Deployment

Push to `main`. GitHub Actions builds and deploys automatically.
