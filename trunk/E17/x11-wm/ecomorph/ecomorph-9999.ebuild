# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/e/e-9999.ebuild,v 1.7 2006/10/22 05:44:35 vapier Exp $

inherit enlightenment eutils git

DESCRIPTION="the e17 window manager with modified compiz."
EGIT_REPO_URI="git://staff.get-e.org/users/jeffdameth/e.git"
IUSE="pam dbus slow-desktop exchange"

RDEPEND="pam? ( sys-libs/pam )
	dbus? ( x11-libs/e_dbus )"
DEPEND="${RDEPEND}
	>=x11-libs/ecore-9999
	>=media-libs/edje-9999
	>=dev-libs/eet-9999
	>=dev-libs/efreet-9999
	>=dev-libs/embryo-9999
	>=x11-libs/evas-9999
	exchange? ( =dev-libs/exchange-9999 )
	x11-proto/xproto
	sys-devel/libtool
	!x11-wm/e17
	" #x11-wm/ecompiz
KEYWORDS="x86"
# S="./e"
src_compile() {
#	cd ${S}
	if ! built_with_use x11-libs/evas png ; then
		eerror "Re-emerge evas with USE=png"
		die "Re-emerge evas with USE=png"
	fi
	if use slow-desktop; then
		ewarn "You've enabled slow desktop features. For old cpu user."
		export MY_ECONF="--with-profile=SLOW_PC"
	else
		export MY_ECONF="--with-profile=FAST_PC"
	fi
	enlightenment_src_compile
}

