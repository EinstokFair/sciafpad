#!/bin/sh
set -e

# po/Makefile.in.in and other gettext files are committed to git,
# so skip autopoint (which would otherwise try to overwrite them
# with the version from the local gettext installation).
AUTOPOINT=true autoreconf -fi
