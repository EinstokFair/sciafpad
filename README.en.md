[![Build](https://github.com/EinstokFair/sciafpad/actions/workflows/build.yml/badge.svg)](https://github.com/EinstokFair/sciafpad/actions/workflows/build.yml)

# sciafpad

A minimal GTK4 text editor built on top of [Scintilla](https://www.scintilla.org/),
specifically the [bugaevc/scintilla](https://github.com/bugaevc/scintilla) GTK4 port.

It aims to be as simple as Leafpad, but uses Scintilla as the editing engine
instead of `GtkTextView`. No syntax highlighting, no plugins — just a plain
text editor.

## Features

- GTK4 native user interface
- Scintilla-based text editing widget
- Open / Save / Save As (via `GtkFileDialog`)
- Undo / Redo / Cut / Copy / Paste (via Scintilla's `SCI_*` messages)
- Window title reflects the current file name
- About dialog

## Dependencies

- C++17 compiler (GCC 14+ recommended)
- GTK 4.10 or newer
- `bugaevc/scintilla` GTK4 port, built and installed

### Building `bugaevc/scintilla`

If you don't have `libscintilla.so` yet:

    git clone https://github.com/bugaevc/scintilla.git
    cd scintilla/gtk4
    make demo

This produces `libscintilla.so` in `scintilla/bin/`.

## Build

Autotools is used:

    ./autogen.sh
    ./configure
    make

Run:

    ./sciafpad

## Configure options

If `bugaevc/scintilla` is not in `$HOME/cpp/scintilla/bugaevc`, pass its path:

    ./configure SCINTILLA_ROOT=/path/to/scintilla

## Installation

    make install

By default installs to `/usr/local`. Use `--prefix` to change:

    ./configure --prefix=$HOME/.local

## License

GPL-3.0-or-later. See `COPYING` for details.

## Packaging

- [Gentoo](GENTOO.md) — ebuild included, instructions for local overlay
- [Debian/Ubuntu](DEBIAN.md) — debian/ directory included

## Documentation

API documentation is available at
<https://einstokfair.github.io/sciafpad/v/0.3.8.1/>.
