# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Uncompressing tool for *.alz formats."
HOMEPAGE="http://www.kipple.pe.kr/win/unalz/"
SRC_URI="http://www.kipple.pe.kr/win/unalz/${P}.tgz"

LICENSE="ZLiB"
SLOT="0"
KEYWORDS="amd64 ia32 sparc x86-fbsd x86"
IUSE=""

DEPEND="virtual/libiconv"
RDEPEND=""

src_compile() {
	epatch ${FILESDIR}/unalz-install-path-fix.patch
	#if use iconv; then
	#	make posix-utf8
	#else
	cd unalz
	make linux-utf8
	#fi
}

src_install() {
	cd unalz
	make install
}

