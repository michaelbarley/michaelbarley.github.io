# Adding a Project to the Portfolio Site

How to get a new portfolio project onto the Jekyll site. This guide is written so that Claude Code (or any automation) can follow it end-to-end given a project directory and a few inputs.

---

## Repos involved

There are two separate repos:

| Repo | Location | Purpose |
|------|----------|---------|
| `michaelbarley/knowledge-base` | `/home/michael-barley/Documents/knowledge-base` | Contains project source code under `portfolio-projects/` and a local copy of the site under `portfolio-projects/portfolio-site/` |
| `michaelbarley/michaelbarley.github.io` | `/home/michael-barley/Documents/michaelbarley.github.io` | The actual portfolio site deployed via GitHub Pages. Clone it if it doesn't exist locally |

Changes must be pushed to **both** repos. The knowledge-base keeps the local copy in sync, and `michaelbarley.github.io` is what GitHub Pages actually builds.

---

## Inputs

Before starting, gather the following:

| Input | Example | Where it comes from |
|-------|---------|---------------------|
| `PROJECT_DIR` | `portfolio-projects/07-dimensional-modeling` | The local directory containing the finished project |
| `REPO_NAME` | `dimensional-modeling` | URL-friendly name for the GitHub repo and portfolio slug |
| `TITLE` | `SaaS Subscription Analytics` | Human-readable display name |
| `CATEGORY` | `Analytics Engineering` | Must match an existing category (see reference section) or be a new one |
| `STACK` | `["dbt", "PostgreSQL", "Docker Compose"]` | Tech tags - must match existing tags exactly where they overlap |
| `DESCRIPTION` | `Star schema for SaaS subscription billing with SCD Type 2 snapshots...` | One-line summary used on the project card and the GitHub repo description |
| `ORDER` | `7` | Next integer after the highest existing `order` value in `_projects/` |

---

## Step 1. Prepare the README

The project README is the single source of truth. The portfolio site page is derived from it, so get the README right first.

### Content rules

- No em dashes. Use hyphens (`-`) not `—`.
- No references to other portfolio projects ("Project 1", "the batch pipeline project", etc.). Each repo must stand alone.
- No "Why this project" section that positions it relative to other projects.
- Do not add a co-author line to commits.

### Recommended structure

1. **H1 title** - project name
2. **Opening paragraph** - what it does in 2-3 sentences
3. **Stack line** - `**Stack:** Tech1, Tech2, Tech3`
4. **Architecture diagram** - Mermaid flowchart showing data flow
5. **Why [topic]** (optional) - motivation for the approach, framed standalone
6. **How it works** - walk through each stage
7. **Data model** (if applicable) - Mermaid ER diagram
8. **Custom tests / quality checks** (if applicable)
9. **Running it** - `docker compose up` and follow-up commands
10. **Design decisions** - rationale for key technical choices

## Step 2. Push the project to GitHub

From the project directory:

```bash
cd <PROJECT_DIR>

# Initialise if not already a git repo
git init
git branch -m main
git add .
git commit -m "Initial commit"

# Create the public repo and push in one step
gh repo create michaelbarley/<REPO_NAME> --public --source=. --push

# Set the repo description
gh repo edit michaelbarley/<REPO_NAME> --description "<DESCRIPTION>"
```

### Verify

- [ ] Repo is public at `https://github.com/michaelbarley/<REPO_NAME>`
- [ ] README renders correctly on GitHub
- [ ] Repo description is set
- [ ] Single commit, no co-author

## Step 3. Create the portfolio site page

Create `_projects/<REPO_NAME>.md` in **both** the knowledge-base copy and the live site repo. The body content should match the GitHub README exactly (minus the H1 title and Stack line, which the layout handles via frontmatter).

```markdown
---
title: "<TITLE>"
category: "<CATEGORY>"
stack: <STACK>
github: "https://github.com/michaelbarley/<REPO_NAME>"
description: "<DESCRIPTION>"
order: <ORDER>
mermaid: true
---

<body content from README, starting from the opening paragraph, excluding the H1 title and Stack line>
```

### Frontmatter field reference

| Field | Purpose | Rules |
|-------|---------|-------|
| `title` | Display name on card and detail page | Short and descriptive |
| `category` | Groups projects on the /projects/ page | Reuse existing categories where possible |
| `stack` | Tech stack tags on the card | Powers the filter buttons. Must match existing tag strings exactly (e.g. `"Docker Compose"` not `"docker-compose"`) |
| `github` | Link to the GitHub repo | Must point to the repo created in step 2 |
| `description` | One-line summary | Shown on the project card. Should match the GitHub repo description |
| `order` | Sort position | Integer, ascending. Must not collide with existing projects |
| `mermaid` | Enable Mermaid.js | Only include if the page has mermaid code blocks |

### Content rules for the portfolio page

- The layout (`_layouts/project.html`) automatically renders the title, category badge, GitHub link, and tech stack tags. Do not repeat these in the body.
- Body content must match the GitHub README (same sections, same wording, same diagrams). The only differences should be the omitted H1 and Stack line.
- No em dashes. Use hyphens.
- No references to other portfolio projects.

## Step 4. Verify consistency

Before committing, check:

- [ ] `description` in frontmatter matches the GitHub repo description
- [ ] `stack` values match existing tags exactly (check other `_projects/*.md` files)
- [ ] `order` value doesn't collide with an existing project
- [ ] `github` URL matches the repo from step 2
- [ ] Body content matches the GitHub README (minus H1 and Stack line)
- [ ] No em dashes anywhere
- [ ] No references to other portfolio projects
- [ ] Mermaid diagrams use fenced code blocks (not images)

## Step 5. Test locally (optional)

```bash
cd /home/michael-barley/Documents/michaelbarley.github.io
bundle exec jekyll serve
```

Check:

- `http://localhost:4000/projects/` - card appears in the correct category and position
- Click the card - detail page renders all sections and diagrams
- Click filter buttons - project's stack tags filter correctly
- "View on GitHub" link goes to the correct repo

## Step 6. Deploy

Three things need pushing. Do them in this order:

### 6a. Push the project repo (already done in step 2)

Confirm `https://github.com/michaelbarley/<REPO_NAME>` exists and has the correct README.

### 6b. Push the portfolio site

```bash
cd /home/michael-barley/Documents/michaelbarley.github.io
git add _projects/<REPO_NAME>.md
git commit -m "Add <TITLE> to portfolio"
git push
```

GitHub Pages rebuilds automatically on push to main. The project will be live at `https://michaelbarley.github.io/projects/<REPO_NAME>/` within a minute or two.

### 6c. Push the knowledge-base

```bash
cd /home/michael-barley/Documents/knowledge-base
git add portfolio-projects/<PROJECT_DIR>/README.md portfolio-projects/portfolio-site/_projects/<REPO_NAME>.md
git commit -m "Add <TITLE> to portfolio"
git push
```

This keeps the knowledge-base copy in sync with the live site.

---

## Reference: existing categories

Check `_projects/` for the current list. At time of writing:

- Batch & Orchestration
- Streaming & Real-Time
- Analytics Engineering
- Storage & Lakehouse
- Data Quality
- DevOps & Infrastructure

Reuse these where a project fits. Only create a new category if the project genuinely doesn't belong in any existing one.

## Reference: existing stack tags

To see all tags currently in use:

```bash
grep -h "^stack:" /home/michael-barley/Documents/michaelbarley.github.io/_projects/*.md
```

Match these exactly to avoid duplicate filter buttons.

## Reference: determining the next order value

```bash
grep -h "^order:" /home/michael-barley/Documents/michaelbarley.github.io/_projects/*.md | sort -t: -k2 -n | tail -1
```

Use the next integer after whatever this returns.

## Reference: cloning the portfolio site repo

If `michaelbarley.github.io` isn't cloned locally:

```bash
git clone git@github.com:michaelbarley/michaelbarley.github.io.git /home/michael-barley/Documents/michaelbarley.github.io
```
