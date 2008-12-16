# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/embryo/embryo-9999.ebuild,v 1.4 2006/07/16 05:29:28 vapier Exp $

inherit enlightenment

DESCRIPTION="load and control programs compiled in small"
DEPEND="=dev-libs/eina-9999"

src_compile() {
	cd src/bin
	ls *.c|xargs -I{} python ${FILESDIR}/srcHack_icc.py {}
	cd ../../
	cd src/lib
	ls *.c|xargs -I{} python ${FILESDIR}/srcHack_icc.py {}
	cd ../../
	einfo "Pre-hack done. (For icc?)"
	enlightenment_src_compile
}
