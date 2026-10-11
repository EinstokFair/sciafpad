# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vcs-snapshot

# Upstream: bugaevc/scintilla, GTK4 fork, commit 3ba9b8f09851b60180ce57ee908c6eb57c751368
SCINTILLA_TAR="scintilla-gtk4-bugaevc-5.0.0_20251114"
SCINTILLA_VERSION="5.0.0"

DESCRIPTION="GTK4 Scintilla widget (ScintillaWidget), bugaevc fork"
HOMEPAGE="https://github.com/bugaevc/scintilla"
SRC_URI="https://github.com/EinstokFair/sciafpad/releases/download/v0.3.5/${SCINTILLA_TAR}.tar.xz
	-> scintilla-gtk4-bugaevc-5.0.0_p20251114.tar.xz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=gui-libs/gtk-4.10:4
	>=dev-libs/glib-2.66:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/pkgconf
"

# vcs-snapshot.eclass переименует корень ScintillaWidget/ → ${P}/
# (S = ${WORKDIR}/${P} = scintilla-gtk4-bugaevc-5.0.0_p20251114)

src_prepare() {
	default
	# Add -Wl,-soname to LDFLAGS in the upstream makefile so that the
	# resulting libscintilla.so has SONAME libscintilla.so.5.
	sed -i 's|^\(LDFLAGS += -shared -Wl,--no-undefined -Wl,--version-script=$(VERSION_SCRIPT)\)$|\1\nLDFLAGS += -Wl,-soname,libscintilla.so.5|' \
		"${S}/gtk4/makefile" || die
	grep -n 'soname' "${S}/gtk4/makefile" || die "soname not added"
}

src_compile() {
	cd "${S}/gtk4" || die
	# Generate scintilla-marshal.h and ScintillaEnums.h explicitly.
	# The upstream makefile does not declare dependencies from .o files
	# to these generated headers, so `make -B shared` may fail with
	# "scintilla-marshal.h: No such file or directory".
	emake scintilla-marshal.h
	emake scintilla-marshal.c
	emake ScintillaEnums.h
	emake shared
}

src_install() {
	# .so with SONAME and symlinks
	insinto "/usr/$(get_libdir)"
	newins "${S}/bin/libscintilla.so" "libscintilla.so.${SCINTILLA_VERSION}"
	dosym "libscintilla.so.${SCINTILLA_VERSION}" "/usr/$(get_libdir)/libscintilla.so.5"
	dosym "libscintilla.so.${SCINTILLA_VERSION}" "/usr/$(get_libdir)/libscintilla.so"

	# headers
	insinto /usr/include/scintilla-gtk4-bugaevc
	doins "${S}/include/"*.h
	doins "${S}/gtk4/"*.h

	# pkg-config
	sed -e "s|@PREFIX@|${EPREFIX}/usr|g" \
	    -e "s|@LIBDIR@|${EPREFIX}/usr/$(get_libdir)|g" \
	    -e "s|@INCLUDEDIR@|${EPREFIX}/usr/include/scintilla-gtk4-bugaevc|g" \
	    -e "s|@VERSION@|${SCINTILLA_VERSION}|g" \
	    "${FILESDIR}/scintilla-gtk4-bugaevc.pc.in" \
	    > "${T}/scintilla-gtk4-bugaevc.pc" || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${T}/scintilla-gtk4-bugaevc.pc"
}
