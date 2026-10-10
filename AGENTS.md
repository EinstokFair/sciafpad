# AGENTS.md

Guidance for AI agents working with the `sciafpad` repository.

## Project

- **Name**: sciafpad
- **Purpose**: A minimal GTK4 text editor built on Scintilla (bugaevc GTK4 port).
- **Language**: C++17
- **Build system**: Autotools
- **UI toolkit**: GTK4 (>= 4.10)
- **Editor engine**: Scintilla GTK4 port (bugaevc)
- **License**: GPL-3.0-or-later

## Repository layout

| Path | Purpose |
|---|---|
| `src/main.cpp` | All editor code (single translation unit) |
| `configure.ac` | Autoconf input |
| `Makefile.am` | Automake input |
| `autogen.sh` | Wrapper for `autoreconf` |
| `doc/Doxyfile` | Doxygen configuration |
| `doc/mainpage.md` | Doxygen main page |
| `doc/howto-release.en.md` | Release howto (English) |
| `doc/howto-release.ru.md` | Release howto (Russian) |
| `po/` | Gettext translations |
| `build/gentoo/` | Gentoo ebuild |
| `build/debian/` | Debian packaging |
| `tools/gen-changelog.sh` | Generates `ChangeLog` from git history |
| `GENTOO.md` | Gentoo installation instructions |
| `DEBIAN.md` | Debian/Ubuntu installation instructions |
| `.github/workflows/build.yml` | CI: build on push to `main` |
| `.github/workflows/docs.yml` | CI: deploy docs on tag `v*` |

## Build commands

Generate Autotools files (do **not** use `autoreconf -fi` — it calls `autopoint` and overwrites `po/Makefile.in.in` with an older version):

    aclocal -I m4
    autoconf
    automake --add-missing --copy

Configure (out-of-source build in `build/autotools/`):

    cd build/autotools
    ../../configure SCINTILLA_ROOT=/path/to/scintilla

Build:

    make

Build distribution tarball:

    make dist

Run the full Autotools check (build, install, uninstall, dist):

    make distcheck

## Dependencies

### Build-time

- C++17 compiler (GCC 14+ recommended)
- Autoconf, Automake, pkg-config
- Gettext (>= 0.21) and `autopoint`
- GTK 4.10+ development headers
- Scintilla GTK4 port (bugaevc), built and installed
- For translations: `msgfmt`, `msgmerge`, `xgettext`

### Runtime

- `libgtk-4`
- `libscintilla` (from the bugaevc GTK4 port)

## Scintilla GTK4 port

The editor links against the bugaevc GTK4 port of Scintilla. It is **not**
included in the repository — it must be built separately:

    git clone https://github.com/bugaevc/scintilla.git
    cd scintilla/gtk4
    make

Pass the port's root directory to `./configure`:

    ./configure SCINTILLA_ROOT=/path/to/scintilla

## Known issues

- `make` fails with `fatal error: ScintillaView.h: No such file or directory`
  if the Scintilla GTK4 port is not built or `SCINTILLA_ROOT` is wrong.
  The `configure` script now checks for `ScintillaView.h` and aborts with a
  clear message if it is missing.
- `autoreconf -fi` calls `autopoint`, which overwrites `po/Makefile.in.in`
  with an older version and triggers a gettext infrastructure mismatch.
  Use `aclocal -I m4`, `autoconf`, `automake --add-missing --copy` instead.
- The bugaevc GTK4 port does not support GTK3. GTK4 is required.

## Commit conventions

- Commit messages: `<area>: <short description>` (e.g. `configure.ac: check for ScintillaView.h`).
- For version bumps: `Bump version to <version>; update README link`.
- For packaging changes: `build/gentoo: ...` or `build/debian: ...`.
- For CI changes: `.github/workflows: ...`.

## Release process

See `doc/howto-release.en.md` (English) and `doc/howto-release.ru.md` (Russian).

Summary:

1. Bump version in `configure.ac` and `README.md`.
2. Regenerate Autotools files (see above).
3. Build the tarball with `make dist`.
4. Commit and push.
5. Tag the release: `git tag vX.Y.Z && git push origin vX.Y.Z`.
6. Create a GitHub release: `gh release create vX.Y.Z ...`.
7. Upload the tarball: `gh release upload vX.Y.Z sciafpad-X.Y.Z.tar.xz`.

## CI

Two workflows:

- `build.yml` — runs on push to `main`. Steps: install deps, build the
  Scintilla GTK4 port, configure, build, `make distcheck`, upload tarball.
- `docs.yml` — runs on tag `v*`. Steps: install Doxygen, generate docs,
  copy screenshots, deploy to `gh-pages` under `v/X.Y.Z/`.

Tag naming rules (enforced by `docs.yml`):

- Format: `v<major>.<minor>.<patch>[-suffix]` (e.g. `v0.3.3`, `v1.0.0-rc1`).
- Double dash is forbidden.
- Missing `v` prefix causes the workflow to fail.

## Documentation

- Doxygen output is deployed to `https://einstokfair.github.io/sciafpad/v/X.Y.Z/`.
- Root of the Pages site links to the latest release's documentation.
- `doc/Doxyfile` uses `OUTPUT_LANGUAGE = Russian` and `INPUT` includes
  `mainpage.md`, `howto-release.en.md`, `howto-release.ru.md`.

## Packaging

- **Gentoo**: ebuild at `build/gentoo/app-editors/sciafpad/sciafpad-X.Y.Z.ebuild`.
- **Debian**: `debian/` directory at `build/debian/`.
- Instructions: `GENTOO.md`, `DEBIAN.md`.

## Do not

- Do not run `autoreconf -fi`.
- Do not commit `po/Makefile.in.in` from an older gettext version.
- Do not commit generated files (`configure`, `Makefile.in`, `aclocal.m4`,
  `autom4te.cache/`, `build/`, `doc/build/`, `*.gmo`, `stamp-po`).
- Do not add infrastructure-specific paths (`$HOME/cpp/...`) to committed files.
- Do not use GTK3.
