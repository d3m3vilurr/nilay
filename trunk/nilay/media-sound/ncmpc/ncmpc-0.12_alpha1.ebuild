# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ncmpc/ncmpc-0.11.1-r2.ebuild,v 1.8 2007/10/09 14:44:58 angelos Exp $

inherit eutils autotools

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.musicpd.org/?page=ncmpc"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.bz2"
LICENSE="GPL-2"
IUSE="clock mouse lirc artist search colors key-screen raw-mode nls debug"

SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86 ~x86-fbsd"

RDEPEND="sys-libs/ncurses
	dev-libs/popt
	>=dev-libs/glib-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	elog "Please note that THIS EBUILD is in alpha stage!"
}


src_unpack() {
	unpack "${A}"
	mv ncmpc-0.12~alpha1 ${P}
	cd "${S}"
}

src_compile() {
	econf $(use_enable clock clock-screen) \
		  $(use_enable colors) \
		  $(use_enable artist artist-screen) \
		  $(use_enable lirc) \
		  $(use_enable debug) \
		  $(use_enable mouse) \
		  $(use_enable key-screen) \
		  $(use_enable search search-screen) \
		  $(use_with nls) \
		  $(use_with raw-mode)

	emake || die "make failed"
}

src_install() {
	make install DESTDIR=${D} docdir=/usr/share/doc/${PF} \
		|| die "install failed"

	prepalldocs
}
