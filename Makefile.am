EXTRA_DIST = tools/gen-changelog.sh

bin_PROGRAMS = sciafpad
sciafpad_SOURCES = src/main.cpp

sciafpad_CPPFLAGS = \
    $(GTK4_CFLAGS) \
    -I$(SCINTILLA_ROOT)/gtk4 \
    -I$(SCINTILLA_ROOT)/include

sciafpad_LDADD = \
    $(GTK4_LIBS) \
    -L$(SCINTILLA_ROOT)/bin \
    -lscintilla

sciafpad_LDFLAGS = \
    -Wl,-rpath,$(SCINTILLA_ROOT)/bin

docdir = $(datadir)/doc/sciafpad
dist_doc_DATA = README.md COPYING AUTHORS NEWS ChangeLog

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
