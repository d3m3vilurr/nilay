# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/e_modules/e_modules-9999.ebuild,v 1.6 2006/09/14 15:21:04 vapier Exp $

inherit enlightenment

ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/PROTO/exalt"
DESCRIPTION="efl based front end network manager"
IUSE="dhclient wpa_supplicant vpnc"
DEPEND="=x11-libs/e_dbus-9999
	=x11-libs/ecore-9999
	=x11-libs/elementary-9999
	net-wireless/wpa_supplicant"

