# Building sciafpad on Debian / Ubuntu

## Dependencies

Install the required build tools and libraries:

    sudo apt install build-essential autoconf automake libtool pkg-config
    sudo apt install libgtk-4-dev

The following are needed to build `bugaevc/scintilla`:

    sudo apt install valac gobject-introspection blueprint-compiler

## Building bugaevc/scintilla

sciafpad depends on the GTK4 port of Scintilla. Build it first:

    git clone https://github.com/bugaevc/scintilla.git
    cd scintilla/gtk4
    make demo

This produces `libscintilla.so` in `scintilla/bin/`.

## Building sciafpad

    ./autogen.sh
    ./configure SCINTILLA_ROOT=$HOME/cpp/scintilla/bugaevc
    make

Run:

    ./sciafpad

## Installation

    ./configure --prefix=/usr/local SCINTILLA_ROOT=$HOME/cpp/scintilla/bugaevc
    sudo make install

## Notes

- Debian 13 (trixie) ships GTK 4.18, which satisfies the `gtk4 >= 4.10`
  requirement.
- If you have `bugaevc/scintilla` installed system-wide, you may omit
  `SCINTILLA_ROOT`.
