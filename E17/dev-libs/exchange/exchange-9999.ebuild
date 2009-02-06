# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit enlightenment

DESCRIPTION="the enlighten way to exchange data!"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/PROTO/${PN}"
IUSE="ewl etk"

# Removed EWL GUI due to lack of updated code in CVS
#	X? ( x11-libs/ewl dev-libs/efreet )
DEPEND="dev-libs/libxml2
	=x11-libs/ecore-9999
	ewl? ( =x11-libs/ewl-9999 )
	etk? ( =x11-libs/etk-9999 )
	"
src_compile () {
	export MY_ECONF="$(use_enable ewl)
	$(use_enable etk)"
	enlightenment_src_compile
}
