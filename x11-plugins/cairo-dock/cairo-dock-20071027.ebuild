# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit autotools eutils

DESCRIPTION="Cairo-dock is a kind of dock applet, which doesn't depend on any gnome package."
HOMEPAGE="http://developer.berlios.de/projects/cairo-dock/"
SRC_URI="http://download2.berlios.de/cairo-dock/cairo-dock-sources-${PV}.tar.bz2"

LICENSE="GPL"
IUSE="clock"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_unpack() {
	unpack cairo-dock-sources-${PV}.tar.bz2
	cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/cairo-dock"
	econf
	if use clock; then
		cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/plugins/clock"
		econf
	fi
}

src_compile() {
	cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/cairo-dock"
	emake || die "emake failed"
	if use clock; then
		cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/plugins/clock"
		emake || die "emake failed"
	fi
}

src_install() {
	cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/cairo-dock"
	emake DESTDIR="${D}" install || die "emake install failed"
	if use clock; then
		cd "/var/tmp/portage/x11-plugins/cairo-dock-${PV}/work/opt//cairo-dock/plugins/clock"
		emake DESTDIR="${D}" install || die "emake install failed"
	fi
	#dodoc ANNOUNCE AUTHORS ChangeLog NEWS README* TODO
}
