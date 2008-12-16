# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/edb/edb-9999.ebuild,v 1.5 2005/06/30 22:26:48 vapier Exp $

inherit enlightenment flag-o-matic

DESCRIPTION="Enlightenment Data Base"
HOMEPAGE="http://www.enlightenment.org/Libraries/Edb/"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
IUSE="ncurses"

DEPEND="ncurses? ( sys-libs/ncurses )"

src_compile() {
	ewarn "This package is too old."
	ewarn "If you build evas with edb support, remove edb support."
	ewarn "It can be built still.... but...."
	export MY_ECONF="
		--enable-compat185
		--enable-dump185
		$(use_enable ncurses)
	"
	use ppc && filter-lfs-flags
	enlightenment_src_compile
}
