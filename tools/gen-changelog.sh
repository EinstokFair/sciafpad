#!/bin/sh
#
# Generate ChangeLog from git history.
# Usage: tools/gen-changelog.sh [output-file]
#

set -e

OUT="${1:-ChangeLog}"

if [ ! -d .git ]; then
    echo "error: not a git repository" >&2
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "error: git not found" >&2
    exit 1
fi

echo "Generating $OUT from git history..."

git log \
    --date=short \
    --pretty=format:'%ad  %an  <%ae>%n%n	* %s%n%n' \
    > "$OUT"

echo "Done: $OUT ($(wc -l < "$OUT") lines)"
