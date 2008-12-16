# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
 
inherit flag-o-matic eutils

DESCRIPTION="The J Framebuffer Terminal/Multilingual Enhancement with UTF-8 support for Korean"
HOMEPAGE="http://kldp.net/projects/hangul-jfbterm"
SRC_URI="http://kldp.net/frs/download.php/3369/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="ppc ppc64 sparc x86"
IUSE=""

DEPEND="!app-i18n/jfbterm
 	app-i18n/libhangul
	>=sys-apps/sed-4
 	>=sys-devel/autoconf-2.58
 	sys-devel/automake
 	sys-devel/libtool
 	sys-libs/ncurses"
RDEPEND=""

S="${WORKDIR}/jfbterm-0.4.7-uxp-0.2.0"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	replace-flags -march=pentium3 -mcpu=pentium3

	export WANT_AUTOCONF=2.5
	econf --prefix=/usr --sysconfdir=/etc || die "econf failed"
	# jfbterm peculiarly needs to be compiled twice.
	emake -j1 || die "make failed"
	emake -j1 || die "make failed"
	sed -i -e 's/a18/8x16/' jfbterm.conf.sample
}

src_install() {
	dodir /etc /usr/share/fonts/jfbterm
	make DESTDIR=${D} install || die

	dodir /usr/share/terminfo
	tic terminfo.jfbterm -o${D}/usr/share/terminfo || die

	mv ${D}/etc/jfbterm.conf{.sample,}

	doman jfbterm.1 jfbterm.conf.5

	dodoc AUTHORS ChangeLog INSTALL* NEWS README*
	dodoc jfbterm.conf.sample*
}
