# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bilingual (German/English) artist portfolio for Anna Weber built with Hugo and Tailwind CSS v4. Content is primarily YAML-driven (not markdown). German is the default language at root `/`, English at `/en/`.

## Commands

```bash
# Development server
hugo server -D

# Production build
hugo --gc --minify

# Install dependencies (Tailwind CSS CLI via Bun)
bun install

# Lint CSS/JSON (Biome)
bun run lint
bun run lint:fix

# Deploy to Cloudflare Pages
wrangler pages publish public
```

## Architecture

### Data-Driven Content

All artwork and content lives in YAML files under `data/`:
- `paintings.yaml` - Artwork catalog with bilingual titles/medium
- `sculptures.yaml` - Sculptures catalog
- `exhibitions.yaml` - Exhibition history
- `biography.yaml` - Education, residencies, contact
- `texts.yaml` - Artist statements

### Hugo Image Processing

Original images go in `assets/images/`. Hugo automatically generates optimized versions via partials:

**Thumbnails** (`partials/thumbnail.html`): 300w/400w/600w WebP at q55
**Lightbox** (`partials/responsive-image.html`): 400w/800w/1200w WebP at q85 with JPEG fallback
**Placeholders**: 20px WebP blur-up

**Never create manual thumbnails** - only set the `image:` field in YAML.

### Key Layouts

- `layouts/index.html` - Homepage with featured works
- `layouts/paintings/list.html` - Gallery with lightbox
- `layouts/partials/_artwork-card.html` - Reusable artwork card (button/link variants)
- `layouts/partials/lightbox.html` - Full-screen image viewer
- `layouts/_default/baseof.html` - Base layout with SEO, dark mode

### Bilingual System

- Translations in `i18n/de.yaml` and `i18n/en.yaml`
- Site config and menus in `hugo.yaml`
- Content fields use `_de`/`_en` suffixes (e.g., `title_de`, `title_en`)

## Adding Content

### New Artwork

1. Place image in `assets/images/paintings/YYYY/` or `assets/images/sculptures/`
2. Add entry to `data/paintings.yaml` or `data/sculptures.yaml`:

```yaml
- id: painting-2024-001-name
  title_de: Deutscher Titel
  title_en: English Title
  year: 2024
  medium_de: Öl auf Leinwand
  medium_en: Oil on canvas
  dimensions: 100 x 80 cm
  image: /images/paintings/2024/painting-2024-001-name.jpg
  weight: 1
```

3. New entries go at the **beginning** of the YAML list

### Naming Convention

Files: `painting-YYYY-NNN-slug.jpg`
- Slug from German title, kebab-case
- Umlauts: ä→ae, ö→oe, ü→ue, ß→ss

### Translation Rules

**Never translate**: Artist names, artwork titles (if artistic), gallery names, addresses, cities, dimensions, years

**Always translate**: `title_de`/`title_en`, `medium_de`/`medium_en`, `content_de`/`content_en`

**Standard mappings**:
- o.T. → Untitled
- Öl auf Leinwand → Oil on canvas
- Acryl und Lack auf Leinwand → Acrylic and varnish on canvas

## Technical Notes

- **Dark mode**: Class-based via `@custom-variant dark (&:where(.dark, .dark *))` in CSS, toggle in header, persisted to localStorage
- **Fonts**: Self-hosted DM Sans Variable in `static/fonts/`, with `font-display: optional` to prevent CLS
- **Forms**: Formspree integration (ID in `hugo.yaml` params)
- **Hosting**: Cloudflare Pages (config in `wrangler.toml`)
- **CSS**: Tailwind v4 with `@theme` inline pattern in `assets/css/main.css` - no tailwind.config.js
- **Linting**: Biome for CSS and JSON files only (see `biome.json`)

## Content Management via GitHub Issues

New content can be added through GitHub Issue templates in `.github/ISSUE_TEMPLATE/`:
- `neues-gemaelde.yml` - New painting
- `neue-skulptur.yml` - New sculpture
- `neue-ausstellung.yml` - New exhibition
- `neuer-text.yml` - New text

OpenCode agent processes issues automatically, updates YAML files, and creates PRs.
