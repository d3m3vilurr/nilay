# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# This ebuild file is KLDP gentoo-kr Overlay Modified Version, Thankyou !
# NOTICE: This package depend on kdelibs built with aRts
ARTS_REQUIRED=yes
inherit cmake-utils kde

MY_PN="nateon"
MY_MAJOR_VER="1.0beta"
MY_TRUE_VER="1.0"
MY_MINOR_VER="20080131"
MY_SVN_VER="svn110"
# NOTICE: SVN_VER included in src filename instead of MINOR_VER
MY_P="${MY_PN}-${MY_MAJOR_VER}-${MY_SVN_VER}"
PKG_SUFFIX=""

DESCRIPTION="SK Communication Nateon Messenger for Linux"
HOMEPAGE="http://kldp.net/projects/nateon"
SRC_URI="http://tmp.sjkoon.com/pds/${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~ppc"

SLOT="0"
IUSE="no-messagebox"


DEPEND="x11-libs/libX11
x11-libs/libXScrnSaver
x11-libs/libXext
x11-libs/libXrender
kde-base/kdelibs
kde-base/kdebase
kde-base/arts
dev-util/cmake
dev-util/subversion
>=kde-base/kdelibs-3.5.7
>=dev-db/sqlite-3.3.13"


RDEPEND="${DEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_TRUE_VER}"

src_compile() {
	if use no-messagebox ; then
		mycmakeargs="-DWITHOUT_MESSAGEBOX=ON"
	fi
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
