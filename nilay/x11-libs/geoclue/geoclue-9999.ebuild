# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/e/e-9999.ebuild,v 1.7 2006/10/22 05:44:35 vapier Exp $

inherit eutils git autotools

DESCRIPTION="Geoclue is a modular geoinformation service built on top of the
D-Bus messaging system."
EGIT_REPO_URI="git://anongit.freedesktop.org/git/geoclue"
SLOT="0"
IUSE="system-bus"
GEOCLUE_VERSION="0.11.1"
KEYWORDS="~amd64 ~x86"
DEPEND="
	sys-devel/libtool
	x11-libs/gtk+:2
	>dev-util/gtk-doc-1.0
	dev-libs/libxml2
	sys-apps/dbus
	>dev-libs/dbus-glib-0.60
	"

src_compile() {
	#eautoreconf
	elog "Welcome to using this package :P"
	local myuse=""
	./autogen.sh --prefix=/usr
	econf --prefix=/usr $(use_enable system-bus)
	emake
}

src_install() {
	#dodir /usr/share/ecomp
	#cp -R ecomp "${D}/usr/share/ecomp/ecomp_settings"
	emake install DESTDIR=${D} || die "Go ja!"
}
