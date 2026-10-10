# sciafpad {#mainpage}

A minimal GTK4 text editor built on top of
[Scintilla](https://www.scintilla.org/), specifically the
[bugaevc/scintilla](https://github.com/bugaevc/scintilla) GTK4 port.

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

## Screenshots

\image html screenshot1.png "File menu"

\image html screenshot2.png "Edit menu"

## Source code

- GitHub: <https://github.com/EinstokFair/sciafpad>
- Releases: <https://github.com/EinstokFair/sciafpad/releases>

## Building

See the project `README.md` on GitHub for build instructions.

## License

GPL-3.0-or-later. See `COPYING` for details.
