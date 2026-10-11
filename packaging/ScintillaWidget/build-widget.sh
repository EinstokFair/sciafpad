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

if ! mountpoint -q "$work"; then
    mkdir -p "$work" "$garbage" "$control"
    sudo mount -t overlay overlay \
        -o "lowerdir=$REPO/packaging/ScintillaWidget:$src",upperdir="$garbage",workdir="$control" \
        "$work"
fi

# 1. Собрать .so
cd "$work/gtk4"
make -B shared

# 2. Заголовки — в work/include/scintilla-gtk4-bugaevc/
inc="$work/include/scintilla-gtk4-bugaevc"
mkdir -p "$inc"
cp "$src/include/"*.h "$inc/"
cp "$src/gtk4/"*.h "$inc/"

# 3. Сгенерировать .pc
pcdir="$work/bin/pkgconfig"
mkdir -p "$pcdir"
sed -e "s|@PREFIX@|$work|g" \
    -e "s|@LIBDIR@|$work/bin|g" \
    -e "s|@INCLUDEDIR@|$inc|g" \
    -e "s|@VERSION@|5.0.0|g" \
    "$pc_in" > "$pcdir/scintilla-gtk4-bugaevc.pc"

echo ">>> Done:"
ls -la "$work/bin/libscintilla.so"
ls -la "$pcdir/scintilla-gtk4-bugaevc.pc"
ls "$inc/" | head
