# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vcs-snapshot

# Upstream: bugaevc/scintilla, GTK4 fork, commit 3ba9b8f09851b60180ce57ee908c6eb57c751368
SCINTILLA_TAR="scintilla-gtk4-bugaevc-5.0.0~20251114"

DESCRIPTION="GTK4 Scintilla widget (ScintillaWidget), bugaevc fork"
HOMEPAGE="https://github.com/bugaevc/scintilla"
SRC_URI="https://github.com/EinstokFair/sciafpad/releases/download/v0.3.4/${SCINTILLA_TAR}.tar.xz
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

src_compile() {
	cd "${S}/gtk4" || die
	emake shared
}

src_install() {
	# .so
	insinto "/usr/$(get_libdir)"
	doins "${S}/bin/libscintilla.so"

	# headers
	insinto /usr/include/scintilla-gtk4-bugaevc
	doins "${S}/include/"*.h
	doins "${S}/gtk4/"*.h

	# pkg-config
	sed "s|@PREFIX@|${EPREFIX}/usr|g" \
		"${FILESDIR}/scintilla-gtk4-bugaevc.pc.in" \
		> "${T}/scintilla-gtk4-bugaevc.pc" || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${T}/scintilla-gtk4-bugaevc.pc"
}
