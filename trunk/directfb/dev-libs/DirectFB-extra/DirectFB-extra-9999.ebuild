# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $

IUSE="avi debug flash fusion imlib mmx mpeg quicktime svg swfdec xine"

inherit eutils git directfb-dev


DESCRIPTION="DirectFB extra package (image and video providers, df_xine)"
HOMEPAGE="http://www.directfb.org/"
KEYWORDS=""
EGIT_REPO_URI="git://git.directfb.org/git/directfb/extras/${PN}.git"

LICENSE="GPL-2"
SLOT="0"


RDEPEND="
	~dev-libs/DirectFB-${PV}
	imlib? ( >=media-libs/imlib2-1.1.2 )
	fusion? ( ~media-libs/FusionSound-${PV} )
	quicktime? ( virtual/quicktime )
	svg? ( >=x11-libs/libsvg-cairo-0.1.6 )
	mpeg? ( >=media-libs/libmpeg3-1.5 )
	flash? ( media-libs/libflash )
	xine? ( >=media-libs/xine-lib-1.0.0 )
	swfdec? ( >=media-libs/swfdec-0.3.0 )
	"
	#avi? ( media-video/avifile )

DEPEND="${RDEPEND}
	dev-util/pkgconfig" 

pkg_setup() {
	directfb-dev_pkg_setup
}

src_unpack() {
	git_src_unpack
	apply_local_patches
}

src_compile() {
	local CONFPARAMS="
		$(use_enable debug)
		$(use_enable mmx)
		$(use_enable imlib imlib2)
		$(use_enable svg)
		$(use_enable quicktime openquicktime)
		$(use_enable avi avifile)
		$(use_enable mpeg libmpeg3)
		$(use_enable flash)
		$(use_enable xine)
		$(use_enable swfdec)
		"
	cd ${S}
	if [ "${PV}" = "9999" ]; then
		./autogen.sh --prefix=/usr ${CONFPARAMS} || die
		# this should be really made obsolete some day
		sed -i \
		    -e 's:libmpeg3\.h:libmpeg3/libmpeg3.h:g' \
		    configure interfaces/IDirectFBVideoProvider/idirectfbvideoprovider_libmpeg3.c	
		econf ${CONFPARAMS} || die		
	else	
		sed -i \
		    -e 's:libmpeg3\.h:libmpeg3/libmpeg3.h:g' \
		    configure interfaces/IDirectFBVideoProvider/idirectfbvideoprovider_libmpeg3.c	
		econf ${CONFPARAMS} || die
	fi
	emake || die 
}

src_install() {
	emake install DESTDIR=${D} || die "make install failed" 
	dodoc AUTHORS ChangeLog NEWS README
}
