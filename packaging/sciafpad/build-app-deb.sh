#!/bin/bash
set -euo pipefail

REPO=$(cd "$(dirname "$0")/../.." && pwd)
src="$SCIAFPAD_SRC"
out="/tmp/sciafpad-deb"

mkdir -p "$out"

cd "$src"
dpkg-buildpackage -b -us -uc -d

echo ">>> .deb files:"
mv -v "$src/../sciafpad_"*.deb "$out/" 2>/dev/null || true
mv -v "$src/../sciafpad-dbgsym_"*.deb "$out/" 2>/dev/null || true
mv -v "$src/../sciafpad_"*.changes "$out/" 2>/dev/null || true
mv -v "$src/../sciafpad_"*.buildinfo "$out/" 2>/dev/null || true
ls -la "$out"/*.deb 2>/dev/null || echo "no .deb found"
