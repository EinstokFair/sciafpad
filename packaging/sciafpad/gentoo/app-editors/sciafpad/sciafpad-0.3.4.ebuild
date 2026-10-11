# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="A minimal GTK4 text editor based on the bugaevc/scintilla port"
HOMEPAGE="https://github.com/EinstokFair/sciafpad"
SRC_URI="https://github.com/EinstokFair/sciafpad/releases/download/v${PV}/sciafpad-${PV}.tar.xz
	-> sciafpad-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=gui-libs/gtk-4.10:4
	>=dev-libs/glib-2.66:2
	dev-libs/scintilla-gtk4-bugaevc
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
	dev-util/pkgconf
"
