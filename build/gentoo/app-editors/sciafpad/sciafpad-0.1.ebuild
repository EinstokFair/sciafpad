# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A minimal GTK4 text editor based on the bugaevc/scintilla port"
HOMEPAGE="https://github.com/EinstokFair/sciafpad"
SRC_URI="https://github.com/EinstokFair/sciafpad/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=gui-libs/gtk-4.10:4
	>=dev-libs/glib-2.66:2
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-build/autoconf
	dev-build/automake
	sys-devel/libtool
	dev-util/pkgconf
"

src_unpack() {
	default

	git clone https://github.com/bugaevc/scintilla.git \
		"${WORKDIR}/scintilla-bugaevc" || die
	pushd "${WORKDIR}/scintilla-bugaevc/gtk4" >/dev/null || die
	make demo || die
	popd >/dev/null || die
}

src_configure() {
	econf SCINTILLA_ROOT="${WORKDIR}/scintilla-bugaevc"
}

src_install() {
	default

	insinto /usr/lib/sciafpad
	doins "${WORKDIR}/scintilla-bugaevc/bin/libscintilla.so"
}
