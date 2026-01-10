# Anna Weber - Künstler-Portfolio

Ein modernes, zweisprachiges Portfolio für die Künstlerin Anna Weber, erstellt mit Hugo und Tailwind CSS.

## Über das Projekt

Diese Website präsentiert die Gemälde und Skulpturen von Anna Weber (geb. 1986, Düsseldorf). Das Portfolio umfasst Werke aus den Jahren 2015-2022 und bietet eine elegante, responsive Darstellung ihrer künstlerischen Arbeit.

## Tech-Stack

- **[Hugo](https://gohugo.io/)** - Statischer Site-Generator
- **[Tailwind CSS v4](https://tailwindcss.com/)** - Utility-first CSS Framework
- **[Cloudflare Pages](https://pages.cloudflare.com/)** - Hosting & Deployment
- **Vanilla JavaScript** - Lightbox & Dark Mode

## Voraussetzungen

- [Hugo](https://gohugo.io/installation/) (Extended Version empfohlen)
- [Git](https://git-scm.com/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/) (optional, für Deployment)

## Installation

```bash
# Repository klonen
git clone <repository-url>
cd anna-hugo

# Entwicklungsserver starten
hugo server
```

Die Seite ist dann unter `http://localhost:1313` erreichbar.

## Entwicklung

```bash
# Entwicklungsserver mit Live-Reload
hugo server -D

# Produktion-Build erstellen
hugo build
```

Die generierten Dateien befinden sich im `public/`-Verzeichnis.

## Deployment

```bash
# Build erstellen und auf Cloudflare Pages deployen
hugo build
wrangler pages publish public
```

## Projektstruktur

```
anna-hugo/
├── content/           # Markdown-Inhalte (DE/EN)
│   ├── paintings/     # Gemälde-Seite
│   ├── sculptures/    # Skulpturen-Seite
│   ├── biography/     # Biografie
│   ├── exhibitions/   # Ausstellungen
│   └── ...
├── data/              # YAML-Datendateien
│   ├── paintings.yaml # Gemälde-Katalog
│   ├── sculptures.yaml# Skulpturen-Katalog
│   └── ...
├── layouts/           # Hugo-Templates
│   ├── _default/      # Basis-Layouts
│   ├── partials/      # Wiederverwendbare Komponenten
│   └── ...
├── assets/images/     # Original-Bilder (Hugo generiert Thumbnails)
├── i18n/              # Übersetzungen (DE/EN)
├── hugo.yaml          # Hugo-Konfiguration
└── wrangler.toml      # Cloudflare-Konfiguration
```

## Features

- **Zweisprachig** - Deutsch und Englisch mit Sprachumschalter
- **Dark Mode** - Systembasiert mit manueller Umschaltung
- **Lightbox-Galerie** - Großansicht mit Navigation
- **Responsive Design** - Optimiert für alle Bildschirmgrößen
- **SEO-optimiert** - Strukturierte Daten und Meta-Tags
- **Hugo Image Processing** - Automatische Thumbnail-Generierung

## Bildverarbeitung (Hugo Image Processing)

Hugo generiert automatisch optimierte Bildversionen beim Build:

| Verwendung | Größe | Format | Qualität |
|------------|-------|--------|----------|
| Galerie-Thumbnails | 400px | WebP | 80% |
| Lightbox | 1600px | WebP | 90% |
| Blur-up Placeholder | 20px | WebP | 20% |

### Neues Bild hinzufügen

1. Original-Bild in `assets/images/paintings/YYYY/` oder `assets/images/sculptures/` ablegen
2. Nur das `image:` Feld in der YAML-Datei setzen (kein `thumbnail:` nötig)
3. Hugo generiert alle Versionen automatisch beim Build

### Technische Details

- Responsive Images mit `srcset` für verschiedene Bildschirmgrößen
- WebP-Format für optimale Kompression
- Lazy Loading für schnellere Seitenladezeiten
- Blur-up Placeholder während Bilder laden
- Build-Zeit: ca. 2 Minuten für ~500 generierte Bilder

## Content-Management mit OpenCode GitHub

Dieses Projekt nutzt [OpenCode](https://github.com/anomalyco/opencode) als KI-gestütztes Content-Management-System. Neue Inhalte können direkt über GitHub Issues hinzugefügt werden.

### So funktioniert's

1. **Issue erstellen** - Nutze eines der Issue-Templates:
   - [Neues Gemälde](.github/ISSUE_TEMPLATE/neues-gemaelde.yml)
   - [Neue Skulptur](.github/ISSUE_TEMPLATE/neue-skulptur.yml)
   - [Neue Ausstellung](.github/ISSUE_TEMPLATE/neue-ausstellung.yml)
   - [Neuer Text](.github/ISSUE_TEMPLATE/neuer-text.yml)

2. **Formular ausfüllen** - Titel, Jahr, Technik, Bilder hochladen

3. **OpenCode arbeitet** - Der KI-Agent:
   - Verarbeitet die Bilder
   - Aktualisiert die YAML-Dateien
   - Erstellt einen Pull Request

4. **Review & Merge** - PR prüfen und mergen → automatisches Deployment

### Manuelle Befehle

In jedem Issue oder PR-Kommentar:

```
/opencode erkläre dieses Issue
/oc füge das Bild zur Galerie hinzu
```

### Setup (einmalig)

1. GitHub App installieren: [github.com/apps/opencode-agent](https://github.com/apps/opencode-agent)
2. `ANTHROPIC_API_KEY` als Repository Secret hinzufügen

## Inhalte manuell bearbeiten

| Datei | Beschreibung |
|-------|--------------|
| `data/paintings.yaml` | Gemälde hinzufügen/bearbeiten |
| `data/sculptures.yaml` | Skulpturen hinzufügen/bearbeiten |
| `data/exhibitions.yaml` | Ausstellungen aktualisieren |
| `i18n/de.yaml` | Deutsche Übersetzungen |
| `i18n/en.yaml` | Englische Übersetzungen |
| `hugo.yaml` | Seitentitel und Menüs |

### Neues Kunstwerk manuell hinzufügen

In `data/paintings.yaml`:

```yaml
- id: "painting-XXX"
  title_de: "Titel auf Deutsch"
  title_en: "Title in English"
  year: 2024
  medium_de: "Öl auf Leinwand"
  medium_en: "Oil on canvas"
  dimensions: "100 x 80 cm"
  image: "/images/paintings/artwork.jpg"
  weight: 1
# Kein thumbnail-Feld nötig - Hugo generiert automatisch
```

## Lizenz

Alle Rechte an den Kunstwerken und Inhalten liegen bei Anna Weber.

---

Erstellt mit [Hugo](https://gohugo.io/)
