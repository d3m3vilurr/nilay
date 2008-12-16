# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/e_modules/e_modules-9999.ebuild,v 1.6 2006/09/14 15:21:04 vapier Exp $

inherit enlightenment

PN2="${PN/e_modules-/}"

ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/E-MODULES-EXTRA/${PN2}"
DESCRIPTION="e17 module: ${PN2}"

DEPEND=">=media-libs/edje-0.5.0
	>=x11-wm/e-0.16.999"
