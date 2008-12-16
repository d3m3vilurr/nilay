# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $

IUSE=""

inherit eutils git directfb-dev

DESCRIPTION="LiTE is a Toolbox Engine (for DirectFB)"
HOMEPAGE="http://www.directfb.org/"
EGIT_REPO_URI="git://git.directfb.org/git/directfb/libs/${PN}.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="~dev-libs/DirectFB-${PV}"

pkg_setup() {
	directfb-dev_pkg_setup
}

src_unpack() {
	git_src_unpack

	apply_local_patches
}
src_compile() {
	cd ${S}
	if [ "${PV}" = "9999" ]; then
		./autogen.sh --prefix=/usr || die
	else
		econf || die
	fi
	emake || die 
}

src_install() {
	emake install DESTDIR=${D} || die "make install failed" 
	dodoc AUTHORS ChangeLog NEWS README
}
