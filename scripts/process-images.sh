#!/bin/bash
# =============================================================================
# Anna Weber Portfolio - Image Processing Script
# =============================================================================
# Dieses Script verarbeitet hochgeladene Bilder für das Portfolio:
# - Konvertiert PNG zu JPG
# - Generiert Thumbnails
# - Validiert Dateinamen
# - Optimiert Bildqualität
#
# Verwendung:
#   ./scripts/process-images.sh <input-file> <type> <year> <slug>
#   ./scripts/process-images.sh uploaded.png painting 2024 blaue-stunde
#
# =============================================================================

set -e

# -----------------------------------------------------------------------------
# Konfiguration
# -----------------------------------------------------------------------------
THUMB_WIDTH=400           # Thumbnail-Breite in Pixel
FULL_MAX_WIDTH=1200       # Maximale Breite für Vollbilder
JPEG_QUALITY=85           # JPEG-Qualität (1-100)
THUMB_QUALITY=80          # Thumbnail-Qualität

# Pfade
PAINTINGS_DIR="static/images/paintings"
SCULPTURES_DIR="static/images/sculptures"

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------------------
# Hilfsfunktionen
# -----------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Prüft ob ImageMagick installiert ist
check_dependencies() {
    if ! command -v convert &> /dev/null; then
        log_error "ImageMagick ist nicht installiert. Bitte installieren: brew install imagemagick"
    fi
    if ! command -v identify &> /dev/null; then
        log_error "ImageMagick identify ist nicht verfügbar."
    fi
}

# Validiert den Slug (kebab-case, lowercase, keine Umlaute)
validate_slug() {
    local slug="$1"
    if [[ ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
        log_error "Ungültiger Slug: '$slug'. Nur lowercase a-z, 0-9 und Bindestriche erlaubt."
    fi
}

# Konvertiert Umlaute zu ASCII
convert_umlauts() {
    echo "$1" | sed 's/ä/ae/g; s/ö/oe/g; s/ü/ue/g; s/Ä/Ae/g; s/Ö/Oe/g; s/Ü/Ue/g; s/ß/ss/g'
}

# Generiert Slug aus Titel
generate_slug() {
    local title="$1"
    echo "$title" | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/ä/ae/g; s/ö/oe/g; s/ü/ue/g; s/ß/ss/g' | \
        sed 's/[^a-z0-9]/-/g' | \
        sed 's/--*/-/g' | \
        sed 's/^-//; s/-$//'
}

# Ermittelt nächste freie Nummer für ein Jahr
get_next_number() {
    local type="$1"
    local year="$2"
    local dir
    local pattern

    if [[ "$type" == "painting" ]]; then
        dir="$PAINTINGS_DIR/$year"
        pattern="painting-$year-"
    else
        dir="$SCULPTURES_DIR"
        pattern="sculpture-$year-"
    fi

    if [[ ! -d "$dir" ]]; then
        echo "001"
        return
    fi

    local max_num=$(ls "$dir" 2>/dev/null | \
        grep -oP "${pattern}\K[0-9]{3}" | \
        sort -n | \
        tail -1)

    if [[ -z "$max_num" ]]; then
        echo "001"
    else
        printf "%03d" $((10#$max_num + 1))
    fi
}

# Prüft Bildformat
check_image_format() {
    local file="$1"
    local format=$(identify -format "%m" "$file" 2>/dev/null)
    echo "$format"
}

# -----------------------------------------------------------------------------
# Hauptfunktionen
# -----------------------------------------------------------------------------

# Konvertiert PNG zu JPG
convert_to_jpg() {
    local input="$1"
    local output="$2"

    log_info "Konvertiere zu JPG: $input -> $output"
    convert "$input" -quality $JPEG_QUALITY "$output"
    log_success "Konvertierung abgeschlossen"
}

# Optimiert und skaliert Vollbild
process_full_image() {
    local input="$1"
    local output="$2"

    local width=$(identify -format "%w" "$input")

    log_info "Verarbeite Vollbild: $input (${width}px breit)"

    if [[ $width -gt $FULL_MAX_WIDTH ]]; then
        log_info "Skaliere von ${width}px auf max ${FULL_MAX_WIDTH}px"
        convert "$input" \
            -resize "${FULL_MAX_WIDTH}x>" \
            -quality $JPEG_QUALITY \
            -strip \
            "$output"
    else
        convert "$input" \
            -quality $JPEG_QUALITY \
            -strip \
            "$output"
    fi

    local new_width=$(identify -format "%w" "$output")
    local new_height=$(identify -format "%h" "$output")
    local size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)

    log_success "Vollbild: ${new_width}x${new_height}, $(($size / 1024))KB"
}

# Generiert Thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"

    log_info "Generiere Thumbnail: $output"

    convert "$input" \
        -resize "${THUMB_WIDTH}x>" \
        -quality $THUMB_QUALITY \
        -strip \
        "$output"

    local width=$(identify -format "%w" "$output")
    local height=$(identify -format "%h" "$output")
    local size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)

    log_success "Thumbnail: ${width}x${height}, $(($size / 1024))KB"
}

# Validiert generierte Dateien
validate_output() {
    local full="$1"
    local thumb="$2"
    local expected_name="$3"

    log_info "Validiere generierte Dateien..."

    # Prüfe ob Dateien existieren
    [[ -f "$full" ]] || log_error "Vollbild nicht gefunden: $full"
    [[ -f "$thumb" ]] || log_error "Thumbnail nicht gefunden: $thumb"

    # Prüfe Dateiformat
    local full_format=$(identify -format "%m" "$full")
    local thumb_format=$(identify -format "%m" "$thumb")

    [[ "$full_format" == "JPEG" ]] || log_error "Vollbild ist kein JPEG: $full_format"
    [[ "$thumb_format" == "JPEG" ]] || log_error "Thumbnail ist kein JPEG: $thumb_format"

    # Prüfe Thumbnail-Breite
    local thumb_width=$(identify -format "%w" "$thumb")
    [[ $thumb_width -le $THUMB_WIDTH ]] || log_warn "Thumbnail breiter als erwartet: ${thumb_width}px"

    # Prüfe Dateinamen-Pattern
    local basename=$(basename "$full")
    if [[ ! "$basename" =~ ^(painting|sculpture)-[0-9]{4}-[0-9]{3}-[a-z0-9-]+\.jpg$ ]]; then
        log_error "Ungültiger Dateiname: $basename"
    fi

    log_success "Validierung erfolgreich"
}

# Hauptprozess für ein Bild
process_image() {
    local input_file="$1"
    local type="$2"        # painting oder sculpture
    local year="$3"
    local slug="$4"

    # Validierung
    [[ -f "$input_file" ]] || log_error "Eingabedatei nicht gefunden: $input_file"
    [[ "$type" =~ ^(painting|sculpture)$ ]] || log_error "Ungültiger Typ: $type (painting oder sculpture)"
    [[ "$year" =~ ^[0-9]{4}$ ]] || log_error "Ungültiges Jahr: $year"
    validate_slug "$slug"

    # Nummer ermitteln
    local num=$(get_next_number "$type" "$year")
    log_info "Nächste freie Nummer: $num"

    # Zielverzeichnis
    local target_dir
    if [[ "$type" == "painting" ]]; then
        target_dir="$PAINTINGS_DIR/$year"
    else
        target_dir="$SCULPTURES_DIR"
    fi

    # Verzeichnis erstellen falls nötig
    mkdir -p "$target_dir"

    # Dateinamen
    local base_name="${type}-${year}-${num}-${slug}"
    local full_path="$target_dir/${base_name}.jpg"
    local thumb_path="$target_dir/${base_name}-thumb.jpg"

    log_info "Ziel: $full_path"

    # Prüfe Eingabeformat
    local input_format=$(check_image_format "$input_file")
    log_info "Eingabeformat: $input_format"

    # Temporäre Datei für Konvertierung
    local temp_file=$(mktemp /tmp/anna-img-XXXXXX.jpg)

    # Konvertiere zu JPG falls nötig
    if [[ "$input_format" == "PNG" ]]; then
        convert_to_jpg "$input_file" "$temp_file"
    else
        cp "$input_file" "$temp_file"
    fi

    # Verarbeite Vollbild
    process_full_image "$temp_file" "$full_path"

    # Generiere Thumbnail
    generate_thumbnail "$full_path" "$thumb_path"

    # Validiere Ergebnis
    validate_output "$full_path" "$thumb_path" "$base_name"

    # Aufräumen
    rm -f "$temp_file"

    # Ausgabe für YAML
    echo ""
    echo "=========================================="
    echo "YAML-Eintrag:"
    echo "=========================================="
    echo "- id: $base_name"
    echo "  image: /images/${type}s/$([[ "$type" == "painting" ]] && echo "$year/")${base_name}.jpg"
    echo "  thumbnail: /images/${type}s/$([[ "$type" == "painting" ]] && echo "$year/")${base_name}-thumb.jpg"
    echo "=========================================="
}

# -----------------------------------------------------------------------------
# CLI Interface
# -----------------------------------------------------------------------------

show_help() {
    cat << EOF
Anna Weber Portfolio - Image Processing Script

Verwendung:
  $0 <input-file> <type> <year> <slug>
  $0 --batch <directory> <type> <year>
  $0 --validate <directory>
  $0 --regenerate-thumbs <directory>

Argumente:
  input-file    Eingabebild (PNG oder JPG)
  type          'painting' oder 'sculpture'
  year          Jahr (4 Ziffern, z.B. 2024)
  slug          URL-freundlicher Name (kebab-case)

Optionen:
  --batch       Verarbeite alle Bilder in einem Verzeichnis
  --validate    Validiere alle Bilder in einem Verzeichnis
  --regenerate-thumbs  Generiere alle Thumbnails neu

Beispiele:
  $0 upload.png painting 2024 blaue-stunde
  $0 foto.jpg sculpture 2024 bronze-figur
  $0 --validate static/images/paintings/2024
  $0 --regenerate-thumbs static/images/paintings

EOF
}

validate_directory() {
    local dir="$1"
    local errors=0

    log_info "Validiere Verzeichnis: $dir"

    for file in "$dir"/*.jpg; do
        [[ -f "$file" ]] || continue

        local basename=$(basename "$file")

        # Überspringe Thumbnails
        [[ "$basename" == *-thumb.jpg ]] && continue

        # Prüfe Dateinamen-Format
        if [[ ! "$basename" =~ ^(painting|sculpture)-[0-9]{4}-[0-9]{3}-[a-z0-9-]+\.jpg$ ]]; then
            log_warn "Ungültiger Dateiname: $basename"
            ((errors++))
        fi

        # Prüfe ob Thumbnail existiert
        local thumb="${file%.jpg}-thumb.jpg"
        if [[ ! -f "$thumb" ]]; then
            log_warn "Thumbnail fehlt für: $basename"
            ((errors++))
        fi

        # Prüfe Bildformat
        local format=$(identify -format "%m" "$file" 2>/dev/null)
        if [[ "$format" != "JPEG" ]]; then
            log_warn "Kein JPEG: $basename ($format)"
            ((errors++))
        fi
    done

    if [[ $errors -eq 0 ]]; then
        log_success "Keine Fehler gefunden"
    else
        log_warn "$errors Fehler gefunden"
    fi

    return $errors
}

regenerate_thumbnails() {
    local dir="$1"

    log_info "Regeneriere Thumbnails in: $dir"

    for file in "$dir"/*.jpg; do
        [[ -f "$file" ]] || continue

        local basename=$(basename "$file")

        # Überspringe existierende Thumbnails
        [[ "$basename" == *-thumb.jpg ]] && continue

        local thumb="${file%.jpg}-thumb.jpg"
        generate_thumbnail "$file" "$thumb"
    done

    log_success "Thumbnails regeneriert"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

check_dependencies

case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --validate)
        validate_directory "${2:-.}"
        exit $?
        ;;
    --regenerate-thumbs)
        regenerate_thumbnails "${2:-.}"
        exit 0
        ;;
    --batch)
        log_error "Batch-Modus noch nicht implementiert"
        ;;
    *)
        if [[ $# -lt 4 ]]; then
            show_help
            exit 1
        fi
        process_image "$1" "$2" "$3" "$4"
        ;;
esac
