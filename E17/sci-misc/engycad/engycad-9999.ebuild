# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit enlightenment

DESCRIPTION="CAD program built on the EFL"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
RDEPEND="media-libs/imlib2
	dev-db/edb
	x11-libs/evas
	x11-libs/ecore"
DEPEND="${RDEPEND}"
