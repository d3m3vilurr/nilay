# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/esmart/esmart-9999.ebuild,v 1.8 2006/09/24 12:22:05 vapier Exp $

inherit enlightenment

DESCRIPTION="a basic widget set that is easy to use based on EFL for mobile touch-screen devices."
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/TMP/st/elementary"
DEPEND="sys-devel/libtool
	>=x11-libs/evas-9999
	>=x11-libs/ecore-9999
	>=media-libs/edje-9999"

IUSE="X fbcon"

#src_compile() {
#	local myconf=""
#	econf $(use_enable X 
