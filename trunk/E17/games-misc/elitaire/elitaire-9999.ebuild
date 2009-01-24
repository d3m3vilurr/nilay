# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
inherit games enlightenment

DEPEND="x11-libs/ewl
	media-libs/edje
	dev-libs/eet
	x11-libs/evas
	x11-libs/ecore
	x11-libs/esmart"
DESCRIPTION="EFL based solitaire game"
HOMEPAGE="http://www.mowem.de/elitaire"

src_compile() {
	export MY_ECONF="
		--with-scores-group=${GAMES_GROUP}
		--with-scores-user=${GAMES_USER}
		--localstatedir=${GAMES_STATEDIR}
	"
	enlightenment_src_compile
}
