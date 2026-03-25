#!/usr/bin/env bash
# Sanitize STEP file headers to remove personal information.
# Usage: ./scripts/sanitize-step.sh [file ...]
# If no files given, processes all .step files under 3d-files/

set -euo pipefail

sanitize_file() {
  local file="$1"
  local basename
  basename=$(basename "$file")

  # Replace FILE_NAME fields:
  #   arg1 (path)   -> filename only
  #   arg3 (author) -> anonymous
  sed -i '' \
    -e "s|FILE_NAME('[^']*'|FILE_NAME('${basename}'|" \
    -e "s|('fnakatani')|('')|" \
    "$file"

  echo "Sanitized: $file"
}

if [ $# -gt 0 ]; then
  files=("$@")
else
  files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find 3d-files -iname '*.step' -print0 2>/dev/null)
fi

if [ ${#files[@]} -eq 0 ]; then
  echo "No STEP files found."
  exit 0
fi

for f in "${files[@]}"; do
  sanitize_file "$f"
done
