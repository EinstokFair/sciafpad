#!/bin/sh
#
# Generate ChangeLog from git history.
# Usage: tools/gen-changelog.sh [output-file]
#
# If .git is not available (e.g. inside a dist tarball), the script
# silently exits without modifying the output file.
#

set -e

OUT="${1:-ChangeLog}"

# Change to the directory containing this script, then up one level
# to the source root. This makes the script work when called from
# an out-of-source build directory.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SRC_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
cd "$SRC_DIR"

if [ ! -d .git ]; then
    echo "tools/gen-changelog.sh: no .git directory, skipping." >&2
    exit 0
fi

if ! command -v git >/dev/null 2>&1; then
    echo "tools/gen-changelog.sh: git not found, skipping." >&2
    exit 0
fi

echo "Generating $OUT from git history..."

git log \
    --date=short \
    --pretty=format:'%ad  %an  <%ae>%n%n	* %s%n%n' \
    > "$OUT"

echo "Done: $OUT ($(wc -l < "$OUT") lines)"
