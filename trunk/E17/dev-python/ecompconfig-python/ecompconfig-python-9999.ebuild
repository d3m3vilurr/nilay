# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/e/e-9999.ebuild,v 1.7 2006/10/22 05:44:35 vapier Exp $

inherit eutils autotools

DESCRIPTION="ecompconfig-python - python binding for libecompconfig"
SRC_URI="http://itask-module.googlecode.com/files/ecompconfig-python.tar.gz"
SLOT="0"
DEPEND="x11-libs/libecompconfig"
S="./${PN}/"
src_compile() {
	cd ${S}
	econf --prefix=/usr
	emake
}

src_install() {
	cd ${S}
	emake install DESTDIR=${D} || die "Go ja!"
}
