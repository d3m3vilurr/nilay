# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-rezlooks/gtk-engines-rezlooks-0.6.ebuild,v 1.1 2007/02/11 03:28:52 compnerd Exp $

DESCRIPTION="Aurora GTK+ Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=56438"
SRC_URI="http://gnome-look.org/CONTENT/content-files/56438-Aurora-1.0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.19"

S="${WORKDIR}/aurora-${PV}"

src_unpack() {
	unpack "${A}"
	cd "${WORKDIR}"

	tar -xpf aurora-${PV}.tar.gz

	mkdir "${WORKDIR}/gtkrc_themes"
	tar -jxpf gtkrc_themes.tar.bz2 -C gtkrc_themes
}

src_compile() {
	econf --enable-animation || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	# Install the themes
	cd "${WORKDIR}"/gtkrc_themes
	for x in $(ls)
	do
		insinto /usr/share/themes/$x/gtk-2.0
		doins $x/gtk-2.0/gtkrc || die "doins gtkrc failed"

		if [[ -e $x/gtk-2.0/panel.png ]]; then
			doins $x/gtk-2.0/panel.png || die "doins panel.png failed"
		fi
	done
}
