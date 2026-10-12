SUBDIRS = po

bin_PROGRAMS = sciafpad
sciafpad_SOURCES = src/main.cpp src/about.cpp

sciafpad_CPPFLAGS = \
    $(GTK4_CFLAGS) \
    $(SCINTILLA_CFLAGS) \
    -DLOCALEDIR=\"$(localedir)\"

sciafpad_LDADD = \
    $(GTK4_LIBS) \
    $(SCINTILLA_LIBS) \
    $(LIBINTL)

EXTRA_DIST = \
    src/about.h \
    tools/gen-changelog.sh \
    tools/msgmerge-wrapper.sh

docdir = $(datadir)/doc/$(PACKAGE)-$(VERSION)
dist_doc_DATA = README.md COPYING AUTHORS NEWS ChangeLog GENTOO.md DEBIAN.md

ChangeLog:
	$(top_srcdir)/tools/gen-changelog.sh $@

dist-hook: ChangeLog
	@if [ -f "$(distdir)/po/en.po" ]; then \
	    sed -i '/^"POT-Creation-Date:/d' "$(distdir)/po/en.po"; \
	fi

# Strip volatile POT-Creation-Date from po/en.po after build
all-local:
	@if [ -f po/en.po ]; then \
	    sed -i '/^"POT-Creation-Date:/d' po/en.po; \
	fi
