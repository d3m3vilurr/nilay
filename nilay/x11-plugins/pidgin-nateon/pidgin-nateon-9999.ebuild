# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-hotkeys/pidgin-hotkeys-0.2.3.ebuild,v 1.10 2008/01/07 23:09:51 tester Exp $

inherit eutils subversion

DESCRIPTION="pidgin-nateon is a plug-in to support nateon protocol."

HOMEPAGE="http://dev.haz3.com/phpBB3/viewforum.php?f=9"

ESVN_REPO_URI="http://dev.haz3.com/svn/nateon/trunk"
ESVN_PROJECT="pidgin-nateon"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="net-im/pidgin
>=x11-libs/gtk+-2.0.0"

DEPEND="${RDEPEND}
dev-util/pkgconfig"

#pkg_setup() {
#   if ! built_with_use net-im/pidgin gtk; then
#      eerror "You need to compile net-im/pidgin with USE=gtk"
#      die "Missing gtk USE flag on net-im/pidgin"
#   fi
#}

src_compile() {
	pwd
	epatch "${FILESDIR}"/01-remapped_libtool.patch
	eautoreconf
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
}
