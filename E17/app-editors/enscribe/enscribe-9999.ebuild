# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/enscribe/enscribe-9999.ebuild,v 1.1 2005/09/07 03:55:40 vapier Exp $

inherit enlightenment

DESCRIPTION="Simple text editor using EFL and Esmart_Textarea"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
DEPEND="x11-libs/evas
	x11-libs/ecore
	media-libs/edje
	x11-libs/esmart"

src_compile() {
	ewarn "This package is classified at OLD package."
	enlightenment_src_compile
}
