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
├── static/images/     # Bilder der Kunstwerke
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

## Inhalte bearbeiten

| Datei | Beschreibung |
|-------|--------------|
| `data/paintings.yaml` | Gemälde hinzufügen/bearbeiten |
| `data/sculptures.yaml` | Skulpturen hinzufügen/bearbeiten |
| `data/exhibitions.yaml` | Ausstellungen aktualisieren |
| `i18n/de.yaml` | Deutsche Übersetzungen |
| `i18n/en.yaml` | Englische Übersetzungen |
| `hugo.yaml` | Seitentitel und Menüs |

### Neues Kunstwerk hinzufügen

In `data/paintings.yaml`:

```yaml
- title_de: "Titel auf Deutsch"
  title_en: "Title in English"
  year: 2024
  medium_de: "Öl auf Leinwand"
  medium_en: "Oil on canvas"
  dimensions: "100 x 80 cm"
  image: "/images/paintings/2024/artwork.jpg"
  thumb: "/images/paintings/2024/artwork-thumb.jpg"
  weight: 1
```

## Lizenz

Alle Rechte an den Kunstwerken und Inhalten liegen bei Anna Weber.

---

Erstellt mit [Hugo](https://gohugo.io/)
