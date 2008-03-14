# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla-launcher/mozilla-launcher-1.58.ebuild,v 1.6 2008/02/26 19:52:14 rich0 Exp $

inherit eutils

DESCRIPTION="Script that launches mozilla or firefox (Hacked for Firefox 3.0
beta4)"
HOMEPAGE="http://sources.gentoo.org/viewcvs.py/gentoo-src/mozilla-launcher/"
SRC_URI="http://nidev.kkaul.com/ff_xpis/dists/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="x11-apps/xdpyinfo"

S=${WORKDIR}

src_install() {
	exeinto /usr/libexec
	newexe ${P} mozilla-launcher || die
}

pkg_postinst() {
	local f
	ewarn "PLEASE LOOK HERE!!!!!!!!!! VERY VERY IMPORTANT THING!"
	ewarn "This ebuild contains hacked version of mozilla-launcher."
	ewarn "It is not official ebuild , and The version of this package "
	ewarn "can make your portage detect official new ebuild of mozilla-launcher."
	ewarn "You have been warned."
	ewarn ":-)"
	find "${ROOT}/usr/bin" -maxdepth 1 -type l | \
	while read f; do
		[[ $(readlink ${f}) == mozilla-launcher ]] || continue
		einfo "Updating ${f} symlink to /usr/libexec/mozilla-launcher"
		ln -sfn /usr/libexec/mozilla-launcher ${f}
	done
}
