#!/bin/bash
set -e

SCINTILLA_SRC="${SCINTILLA_SRC:?SCINTILLA_SRC not set}"
SCIAFPAD_SRC="${SCIAFPAD_SRC:?SCIAFPAD_SRC not set}"

REPO=$(cd "$(dirname "$0")/../.." && pwd)

build_one() {
    local name="$1"
    local src="$2"
    local debian_src="$REPO/build/debian/$name/debian"
    local upper="$REPO/build/debian/$name/upper"
    local work="$REPO/build/debian/$name/upper.work"
    local merged="$REPO/build/debian/$name/src"

    # cleanup
    sudo umount "$merged" 2>/dev/null || true
    sudo rm -rf "$upper" "$work" "$merged"

    # создать каталоги от root
    sudo mkdir -p "$upper" "$work" "$merged"

    sudo mount -t overlay overlay \
        -o "lowerdir=$debian_src:$src",upperdir="$upper",workdir="$work" \
        "$merged"

    # применить патчи
    cd "$merged"
    for p in debian/patches/*.patch; do
        [ -f "$p" ] && patch -p1 < "$p"
    done

    # сборка
    dpkg-buildpackage -b -us -uc

    # umount + cleanup
    sudo umount "$merged"
    sudo rm -rf "$upper" "$work" "$merged"
}

# === Scintilla ===
build_one scintilla-gtk4-bugaevc "$SCINTILLA_SRC"

# === Установить .deb (sciafpad нужен .pc) ===
sudo dpkg -i "$REPO"/build/debian/scintilla-gtk4-bugaevc/*.deb
sudo apt-get install -f -y || true

# === sciafpad ===
build_one sciafpad "$SCIAFPAD_SRC"

echo "=== Done ==="
ls -la "$REPO"/build/debian/scintilla-gtk4-bugaevc/*.deb
ls -la "$REPO"/build/debian/sciafpad/*.deb
