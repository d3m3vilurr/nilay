# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $

IUSE="accuracy cdda cddb debug extra-warnings ieee-floats lite mad vorbis"

inherit eutils git directfb-dev


DESCRIPTION="DirectFB audio sub system for multiple applications"
HOMEPAGE="http://www.directfb.org/"
EGIT_REPO_URI="git://git.directfb.org/git/directfb/core/${PN}.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	~dev-libs/DirectFB-${PV}
	lite? ( >=dev-libs/LiTE-0.0.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.0 )
	mad? ( media-libs/libmad )
	cddb? ( >=media-libs/libcddb-1.0.0 )
	"

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
		$(use_enable extra-warnings)
		$(use_enable ieee-floats)
		$(use_enable accuracy)
		$(use_with lite)
		$(use_enable vorbis)
		$(use_enable mad)
		$(use_enable cdda)
		"
	cd ${S}
	if [ "${PV}" = "9999" ]; then
		./autogen.sh --prefix=/usr ${CONFPARAMS} || die
	else
		econf ${CONFPARAMS} || die
	fi
	emake || die 
}

src_install() {
	emake install DESTDIR=${D} || die "make install failed" 
	dodoc AUTHORS ChangeLog NEWS README
}
