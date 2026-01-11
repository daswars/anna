#!/bin/bash
# Generic auto-format hook for Claude Code
# Detects project type and runs appropriate formatter
set -e

# Read file path from stdin (Claude passes tool input as JSON)
file_path=$(jq -r '.file_path // .tool_input.file_path // empty' 2>/dev/null || echo "")
project_dir="${CLAUDE_PROJECT_DIR:-.}"

# Exit silently if no file path
[ -z "$file_path" ] && exit 0

# Get file extension
ext="${file_path##*.}"

# Function to detect and run the right formatter
format_file() {
  local file="$1"
  local ext="$2"

  case "$ext" in
    # JavaScript/TypeScript/JSON/CSS - prefer Biome, fallback to Prettier
    ts|tsx|js|jsx|mjs|cjs|json|css)
      if [ -f "$project_dir/biome.json" ] || [ -f "$project_dir/biome.jsonc" ]; then
        if command -v bunx &> /dev/null; then
          bunx biome check --write "$file" 2>&1 | head -10 || true
          return 0
        elif command -v npx &> /dev/null; then
          npx biome check --write "$file" 2>&1 | head -10 || true
          return 0
        fi
      fi
      if command -v prettier &> /dev/null; then
        prettier --write "$file" 2>/dev/null || true
        return 0
      fi
      ;;

    # Python - prefer Ruff, fallback to Black
    py|pyi)
      if command -v ruff &> /dev/null; then
        ruff format "$file" 2>/dev/null || true
        ruff check --fix "$file" 2>/dev/null || true
        return 0
      fi
      if command -v black &> /dev/null; then
        black "$file" 2>/dev/null || true
        return 0
      fi
      ;;

    # Go
    go)
      if command -v gofmt &> /dev/null; then
        gofmt -w "$file" 2>/dev/null || true
        return 0
      fi
      ;;

    # Rust
    rs)
      if command -v rustfmt &> /dev/null; then
        rustfmt "$file" 2>/dev/null || true
        return 0
      fi
      ;;

    # Shell scripts
    sh|bash|zsh)
      if command -v shfmt &> /dev/null; then
        shfmt -w "$file" 2>/dev/null || true
        return 0
      fi
      ;;

    # YAML
    yaml|yml)
      if command -v prettier &> /dev/null; then
        prettier --write "$file" 2>/dev/null || true
        return 0
      fi
      ;;
  esac

  return 0
}

# Run formatter
format_file "$file_path" "$ext"

exit 0
