#!/bin/bash
set -euo pipefail

REPO=$(cd "$(dirname "$0")/../.." && pwd)
src="$SCIAFPAD_SRC"
out="/tmp/autotools/sciafpad"
work="$out/work"
garbage="$out/garbage"
control="$out/control"

widget_work="/tmp/bashscript/ScintillaWidget/work"
widget_pc="$widget_work/bin/pkgconfig"

if [ ! -f "$widget_pc/scintilla-gtk4-bugaevc.pc" ]; then
    echo "!!! widget .pc not found at $widget_pc; run build-widget.sh first" >&2
    exit 1
fi

mkdir -p "$out"

if ! mountpoint -q "$work"; then
    mkdir -p "$work" "$garbage" "$control"
    sudo mount -t overlay overlay \
        -o "lowerdir=$REPO/build/sciafpad/debian:$src",upperdir="$garbage",workdir="$control" \
        "$work"
fi

cd "$work"
./autogen.sh

export PKG_CONFIG_PATH="$widget_pc:$PKG_CONFIG_PATH"

./configure
make
