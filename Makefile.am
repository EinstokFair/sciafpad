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
