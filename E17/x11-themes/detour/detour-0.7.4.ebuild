# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-9999.ebuild,v 1.4 2005/03/25 17:51:29 vapier Exp $

inherit eutils
#ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/THEMES/${PN2}"
DESCRIPTION="Theme for E17 that is developed by E17 Main team."
SRC_URI="http://detour.googlecode.com/files/${P}_e17.edj"
DEPEND="=x11-wm/e-9999"
IUSE=""
KEYWORDS="amd64 x86"
SLOT="0"
src_unpack() {
	mkdir ${S}
	cp ${DISTDIR}/${A} ${S}/
}
src_install() {
	cd ${S}
	einfo "This ebuild install only E17 theme."
	insinto /usr/share/enlightenment/data/themes/
	newins "detour-${PV}_e17.edj" "detour-${PV}_e17.edj"
}
