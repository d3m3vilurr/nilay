# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-murrine/gtk-engines-murrine-0.53.1.ebuild,v 1.5 2007/07/19 13:48:48 angelos Exp $

inherit subversion

MY_PN="murrine"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Murrine GTK+2 Cairo Engine (SVN)"

# SVN
ESVN_REPO_URI="http://svn.gnome.org/svn/murrine/trunk"
ESVN_PROJECT="murrine"
ESVN_BOOTSTRAP="autogen.sh"
HOMEPAGE="http://cimi.netsons.org/pages/murrine.php"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="+themes animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.12.0
themes? ( x11-themes/murrine-themes )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	local myconf="--enable-animation"
	if use animation-rtl; then
		export myconf="--enable-animationrtl"
	fi

	econf --enable-rgba ${myconf}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
