# Building sciafpad on Gentoo

> **Note:** This repository ships an ebuild for this package:
> [`build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild`](build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild).
> It can be used directly with a local overlay, or copied into your own.


## Dependencies

Install the required system packages:

    emerge --ask dev-vcs/git
    emerge --ask gui-libs/gtk
    emerge --ask dev-build/autoconf
    emerge --ask dev-build/automake
    emerge --ask sys-devel/libtool
    emerge --ask dev-util/pkgconf

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

- Gentoo's `gui-libs/gtk` provides GTK 4.10+ (required).
- If you have `bugaevc/scintilla` installed system-wide, you may omit
  `SCINTILLA_ROOT` and adjust `Makefile.am` accordingly.
