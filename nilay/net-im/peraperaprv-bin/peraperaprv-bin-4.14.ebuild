# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="P3:PeraPeraPrv is a Pure Java written Twitter client"
HOMEPAGE="http://d.hatena.ne.jp/lynmock/20071107/p2"
PKG_VER="P3_4_14"
SRC_URI="http://www.geocities.jp/lynmock/work/P3/${PKG_VER}.zip"

LICENSE="FREEWARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5
"

DEPEND="${RDEPEND}
"

src_install() {
	insinto /opt/peraperaprv-bin
	doins -r ${PKG_VER}/* || die "doins failed"
	dobin ${FILESDIR}/peraperaprv || die "dobin failed"
}

pkg_postinst() {
	ewarn "P3 on icedtea6 can raise segfault."
	ewarn "use other jvm(ex: sun-jre-bin). :)"
	ewarn ""
}
