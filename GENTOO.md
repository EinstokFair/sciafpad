# Building sciafpad on Gentoo

> **Note:** This repository ships an ebuild for this package:
> [`build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild`](build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild).
> See the section "Using the bundled ebuild" below for instructions.

## Dependencies

Install the required system packages:

    emerge --ask dev-vcs/git
    emerge --ask gui-libs/gtk
    emerge --ask dev-build/autoconf
    emerge --ask dev-build/automake
    emerge --ask dev-build/libtool
    emerge --ask dev-util/pkgconf

## Building bugaevc/scintilla

sciafpad depends on the GTK4 port of Scintilla. Build it first:

    git clone https://github.com/bugaevc/scintilla.git
    cd scintilla/gtk4
    make demo

This produces `libscintilla.so` in `scintilla/bin/`.

## Building sciafpad manually

    ./autogen.sh
    ./configure SCINTILLA_ROOT=$HOME/cpp/scintilla/bugaevc
    make

Run:

    ./sciafpad

## Installation

    ./configure --prefix=/usr/local SCINTILLA_ROOT=$HOME/cpp/scintilla/bugaevc
    sudo make install

## Using the bundled ebuild

The ebuild shipped in this repository is written for **Portage**, Gentoo's
package manager. It assumes you have a **local overlay** — a directory
registered with Portage where you can put your own ebuilds without
touching the official tree.

### Step 1: Create a local overlay

If you don't already have one, create it with `eselect repository`:

    mkdir -p ~/local-overlay
    sudo eselect repository create local-overlay ~/local-overlay

Alternatively, add an entry to `/etc/portage/repos.conf/local-overlay.conf`:

    [local-overlay]
    location = /home/user/local-overlay
    auto-sync = no

Then create the standard directory layout:

    mkdir -p ~/local-overlay/metadata
    mkdir -p ~/local-overlay/profiles

Create `~/local-overlay/metadata/layout.conf`:

    masters = gentoo

Create `~/local-overlay/profiles/repo_name`:

    local-overlay

Create `~/local-overlay/profiles/categories`:

    app-editors

### Step 2: Copy the ebuild into the overlay

    mkdir -p ~/local-overlay/app-editors/sciafpad
    cp build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild \
       ~/local-overlay/app-editors/sciafpad/
    cp build/gentoo/app-editors/sciafpad/metadata.xml \
       ~/local-overlay/app-editors/sciafpad/

### Step 3: Generate the Manifest

Portage requires a `Manifest` file listing checksums of all sources:

    cd ~/local-overlay/app-editors/sciafpad
    sudo ebuild sciafpad-0.1.ebuild manifest

### Step 4: Install

    sudo emerge --ask app-editors/sciafpad

Portage will:
1. Download the source tarball.
2. Unpack it.
3. Fetch and build `bugaevc/scintilla` (as specified in `src_unpack`).
4. Configure and build sciafpad.
5. Install the binary into `/usr/bin/` and `libscintilla.so` into
   `/usr/lib/sciafpad/`.

### Step 5: Verify

    which sciafpad
    sciafpad

## Notes

- Gentoo's `gui-libs/gtk` provides GTK 4.10+ (required).
- The ebuild is a **starting point**; you may want to adjust `KEYWORDS`,
  `LICENSE`, or add a separate package for `bugaevc/scintilla` if you
  maintain a larger overlay.
- If you have `bugaevc/scintilla` installed system-wide, you may omit
  `SCINTILLA_ROOT` and adjust `Makefile.am` accordingly.
