# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# bugaevc/scintilla, зафиксированный коммит, который использует sciafpad.
# Обновление: заменить SHA1 здесь, обновить PV (0_pYYYYMMDD) и Manifest.
SCINTILLA_SHA="3ba9b8f09851b60180ce57ee908c6eb57c751368"

DESCRIPTION="GTK4 Scintilla widget (bugaevc fork), used by sciafpad"
HOMEPAGE="https://github.com/bugaevc/scintilla"
SRC_URI="https://github.com/bugaevc/scintilla/archive/${SCINTILLA_SHA}.tar.gz
	-> scintilla-${SCINTILLA_SHA}.tar.gz"

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

S="${WORKDIR}/scintilla-${SCINTILLA_SHA}"

PATCHES=(
	"${FILESDIR}/scintilla-gtk4.patch"
)

src_compile() {
	cd "${S}/gtk4" || die
	emake shared
}

src_install() {
	cd "${S}/gtk4" || die
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}