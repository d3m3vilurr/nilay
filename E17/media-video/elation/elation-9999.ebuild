# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/elation/elation-9999.ebuild,v 1.2 2005/04/10 20:38:57 vapier Exp $

inherit enlightenment

DESCRIPTION="an e17 media player"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
DEPEND=">=dev-libs/eet-0.9.9
	>=x11-libs/evas-0.9.9
	>=media-libs/edje-0.5.0
	>=x11-libs/ecore-0.9.9
	>=dev-libs/embryo-0.9.0
	>=media-libs/emotion-0.0.1"
