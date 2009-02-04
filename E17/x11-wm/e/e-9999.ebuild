# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/e/e-9999.ebuild,v 1.7 2006/10/22 05:44:35 vapier Exp $

inherit enlightenment eutils git

DESCRIPTION="The E17 window manager. this ebuild is unified version of E and
Ecomorph."
EGIT_REPO_URI="git://github.com/jeffdameth/ecomorph-e17.git"
IUSE="pam dbus slow-desktop exchange ecomorph"
RDEPEND="pam? ( sys-libs/pam )
	dbus? ( x11-libs/e_dbus )
	ecomorph? ( x11-wm/ecompiz )
	ecomorph? ( x11-wm/emerald )
	"
DEPEND="${RDEPEND}
	>=x11-libs/ecore-9999
	>=media-libs/edje-9999
	>=dev-libs/eet-9999
	>=dev-libs/efreet-9999
	>=dev-libs/embryo-9999
	>=x11-libs/evas-9999
	exchange? ( =dev-libs/exchange-9999 )
	ecomorph? ( gnome-base/librsvg )
	ecomorph? ( x11-libs/gtk+:2 )
	x11-proto/xproto
	sys-devel/libtool"

src_unpack() {
	if use ecomorph; then
		einfo "------------------------------------------------------"
		elog "After you finish the installation ecomorph,"
		elog "you can use (your portage overlay)/x11-wm/e/files/start-ecomorph.sh"
		elog "that is very simple starting script."
		ewarn "................... anyone here? please listen........"
		ewarn "You've enabled ecomorph flag."
		ewarn "This makes e-9999.ebuild build from 3rd party GIT repository."
		ewarn "Do NOT report problems related to Ecomorph to OFFICIAL E TEAM!"
		elog "Bug reporting : http://code.google.com/p/itask-module/wiki/Stuff"
		einfo "------------------------------------------------------"
		git_src_unpack
	else
		enlightenment_src_unpack
	fi
}

src_compile() {
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
