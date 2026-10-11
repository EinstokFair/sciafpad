#!/bin/bash
set -euo pipefail

REPO=$(cd "$(dirname "$0")/../.." && pwd)
src="$SCINTILLA_SRC"
out="/tmp/bashscript/ScintillaWidget"
work="$out/work"
garbage="$out/garbage"
control="$out/control"
pc_in="$REPO/packaging/ScintillaWidget/scintilla-gtk4-bugaevc.pc.in"

mkdir -p "$out"

# 1. overlayfs: debian/ + исходники
if ! mountpoint -q "$work"; then
    mkdir -p "$work" "$garbage" "$control"
    sudo mount -t overlay overlay \
        -o "lowerdir=$REPO/packaging/ScintillaWidget:$src",upperdir="$garbage",workdir="$control" \
        "$work"
fi

# 2. Собрать .so + заголовки + .pc через build-widget.sh
"$REPO/packaging/ScintillaWidget/build-widget.sh"

# 3. .pc.in — debian/rules ожидает его в work/debian/
cp "$pc_in" "$work/debian/scintilla-gtk4-bugaevc.pc.in"

# 4. dpkg-buildpackage
cd "$work"
dpkg-buildpackage -b -us -uc -d

echo ">>> .deb files:"
ls -la "$out"/*.deb 2>/dev/null || ls -la /tmp/bashscript/*.deb
