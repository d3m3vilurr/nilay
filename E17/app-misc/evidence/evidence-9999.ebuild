# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/evidence/evidence-9999.ebuild,v 1.12 2006/07/16 07:15:07 vapier Exp $

ECVS_MODULE="evidence"
ECVS_SERVER="evidence.cvs.sourceforge.net:/cvsroot/evidence"
inherit enlightenment eutils flag-o-matic

DESCRIPTION="GTK2 file-manager"
HOMEPAGE="http://evidence.sourceforge.net/"

LICENSE="GPL-2"
IUSE="X debug gnome kde vorbis perl truetype xine mpeg"

RDEPEND=">=dev-util/pkgconfig-0.5
	=x11-libs/gtk+-2*
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	perl? ( dev-libs/libpcre )
	X? ( x11-libs/libX11 x11-libs/libXt )
	truetype? ( =media-libs/freetype-2* )
	kde? ( kde-base/kdelibs )
	xine? ( >=media-libs/xine-lib-1_rc1 )
	mpeg? ( media-libs/libmpeg3 )
	media-libs/libao
	virtual/fam
	>=x11-libs/evas-9999
	>=dev-db/edb-9999
	>=dev-libs/eet-9999
	>=x11-libs/ecore-9999
	>=media-libs/imlib2-9999
	gnome? ( >=gnome-base/gnome-vfs-2.0
		>=media-libs/libart_lgpl-2.0
		>=gnome-base/libgnomecanvas-2.0 )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_compile() {
	# if we turn this on evas gets turned off (bad !)
	#use gnome && MY_ECONF="${MY_ECONF} --enable-canvas-gnomecanvas"

#		$(use_enable gnome backend-gnomevfs2)
	ewarn "This package is old. Because it uses edb(OLD package)."
	ewarn "Not sure that it can be built!"
	ewarn "YOU'VE BEEN WARNED! AND DON'T CRY WHEN FAIL. ;-("
	export MY_ECONF="
		--enable-ecore-ipc
		--enable-canvas-evas2
		--enable-extra-themes
		--enable-extra-iconsets
		--disable-thumbnailer-avi
		$(use_enable xine thumbnailer-xine)
		$(use_enable mpeg thumbnailer-mpeg3)
		$(use_enable perl pcre)
		$(use_enable X x)
		$(use_enable vorbis plugin-vorbis)
		$(use_enable truetype plugin-ttf)
		$(use_enable debug)
		$(use_with kde)
		"
	enlightenment_src_compile
}

src_install() {
	enlightenment_src_install

	# Fixup broken symlinks
	dosym efm /usr/share/evidence/icons/default
	dosym efm /usr/share/evidence/themes/default
	chown -R root:0 "${D}"/usr/share/evidence

	dodoc docs/*
}
