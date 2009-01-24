# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-9999.ebuild,v 1.4 2005/03/25 17:51:29 vapier Exp $

inherit enlightenment
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/THEMES/${PN2}"
DESCRIPTION="Theme for E17 that is developed by E17 Main team."

DEPEND="=x11-wm/e-9999"
IUSE="+init-theme +e17-theme force-install"

src_compile() {
	if ! use force-install; then
		ewarn "b_and_w has been default theme for E17."
		ewarn "If you have installed it, Remove it and update your E17."
		die "No need to install this package."
	fi
	cd b_and_w
	epatch ${FILESDIR}/only_e17_theme.patch
	einfo "Build theme edj...."
	make
}

src_install() {
	einfo "This ebuild install only E17 theme."
	einfo "If you want to build exquisite, illume theme,"
	einfo "Get the sources from /usr/portage/distfiles/svn-src and build it
	yourself."
	cd b_and_w
	insinto /usr/share/enlightenment/data/themes/
	newins b_and_w.edj b_and_w.edj
	if use init-theme; then
		insinto /usr/share/enlightenment/data/init/
		newins init.edj b_and_w-init.edj
	fi
}
