# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/e_modules/e_modules-9999.ebuild,v 1.6 2006/09/14 15:21:04 vapier Exp $

inherit enlightenment

ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/PROTO/exalt"
DESCRIPTION="efl based front end network manager"
IUSE="dhclient wpa_supplicant vpnc"
DEPEND="=x11-libs/e_dbus-9999
	=x11-libs/ecore-9999
	wpa_supplicant? ( net-wireless/wpa_supplicant )
	vpnc? ( net-misc/vpnc )"

src_compile () {
	if ! use dhclient && ! use wpa_supplicant && ! use vpnc; then
		einfo "To support dhcp in exalt : add 'dhclient' flag"
		einfo "To support wpa_supplicant : add 'wpa_supplicant' flag"
		einfo "To support vpnc(not implemented) : add 'vpnc' flag"
	fi
	if use dhclient; then
		ewarn "It's broken in Gentoo."
		ewarn "Official portage tree doesn't have dhclient ebuild."
		ewarn "It will be added by nilay."
		die "Not supported : dhclient"
	fi
	enlightenment_src_compile
}

