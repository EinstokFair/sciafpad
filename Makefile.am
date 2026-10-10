SUBDIRS = po

bin_PROGRAMS = sciafpad
sciafpad_SOURCES = src/main.cpp

sciafpad_CPPFLAGS = \
    $(GTK4_CFLAGS) \
    $(SCINTILLA_CFLAGS) \
    -DLOCALEDIR=\"$(localedir)\"

sciafpad_LDADD = \
    $(GTK4_LIBS) \
    $(SCINTILLA_LIBS) \
    $(LIBINTL)

EXTRA_DIST = tools/gen-changelog.sh

docdir = $(datadir)/doc/sciafpad
dist_doc_DATA = README.md COPYING AUTHORS NEWS ChangeLog GENTOO.md DEBIAN.md

ChangeLog:
	$(top_srcdir)/tools/gen-changelog.sh $@

dist-hook: ChangeLog

# Packaging recipes
EXTRA_DIST += \
	build/gentoo/app-editors/sciafpad/sciafpad-0.1.ebuild \
	build/gentoo/app-editors/sciafpad/metadata.xml \
	build/debian/control \
	build/debian/rules \
	build/debian/changelog \
	build/debian/copyright \
	build/debian/sciafpad.install \
	build/debian/source/format

# Strip volatile POT-Creation-Date from po/en.po after build
all-local:
	@if [ -f po/en.po ]; then \
	    sed -i '/^"POT-Creation-Date:/d' po/en.po; \
	fi
