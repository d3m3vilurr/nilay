# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/engrave/engrave-9999.ebuild,v 1.6 2006/08/25 07:04:03 vapier Exp $

inherit enlightenment

DESCRIPTION="library for editing the contents of edje files"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
DEPEND="sys-devel/bison
	sys-devel/flex
	>=x11-libs/ecore-0.9.9
	>=x11-libs/evas-0.9.9"
