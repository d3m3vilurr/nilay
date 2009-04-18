# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/e/e-9999.ebuild,v 1.7 2006/10/22 05:44:35 vapier Exp $

inherit eutils git autotools

DESCRIPTION="Ecomp - compiz for ecomorph"
EGIT_REPO_URI="git://github.com/jeffdameth/ecomp.git"
SLOT="0"
DEPEND="
	>=x11-libs/ecore-9999
	>=media-libs/edje-9999
	>=dev-libs/eet-9999
	>=dev-libs/efreet-9999
	>=dev-libs/embryo-9999
	>=x11-libs/evas-9999
	x11-proto/xproto
	sys-devel/libtool
	x11-libs/gtk+:2
	gnome-base/librsvg
	"

src_unpack() {
	git_src_unpack
	#eautoreconf
	#pwd
}

src_compile() {
	elog "Do you really want to use Ecomorph?!"
	elog "copy /usr/share/ecomp/ecomp_settings to"
	elog "YOUR_HOME_FOLDER/.config/ecomp, to work properly"
	pwd
	./autogen.sh --prefix=/usr
	if ! built_with_use x11-libs/evas png ; then
		eerror "Re-emerge evas with USE=png"
		die "Re-emerge evas with USE=png"
	fi
	#econf --prefix=/usr
	#make all
	emake
}

src_install() {
	dodir /usr/share/ecomp
	cp -R ecomp "${D}/usr/share/ecomp/ecomp_settings"
	emake install DESTDIR=${D} || die "Go ja!"
}
