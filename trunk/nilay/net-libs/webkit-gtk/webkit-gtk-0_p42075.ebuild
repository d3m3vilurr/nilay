# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-0_p37894.ebuild,v 1.1 2008/10/26 15:32:03 jokey Exp $

inherit autotools

MY_P="WebKit-r${PV/0\_p}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkit.org/"
SRC_URI="http://builds.nightly.webkit.org/files/trunk/src/${MY_P}.tar.bz2"


LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="coverage debug video pango sqlite svg xslt geoclue"
EPATCH_OPTS="-R -p0"

RDEPEND=">=x11-libs/gtk+-2.8
	>=dev-libs/icu-3.8.1-r1
	>=net-misc/curl-7.15
	media-libs/jpeg
	media-libs/libpng
	dev-libs/libxml2
	sqlite? ( >=dev-db/sqlite-3 )
	video? (
		>=media-libs/gst-plugins-base-0.10
		>=gnome-base/gnome-vfs-2.0
		)
	>=net-libs/libsoup-2.25.4
	xslt? ( dev-libs/libxslt )
	pango? ( x11-libs/pango )"

DEPEND="${RDEPEND}
	dev-util/gperf
	dev-util/pkgconfig
	geoclue? ( =x11-libs/geoclue-9999 )
	virtual/perl-Text-Balanced"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	#eautoreconf
	./autogen.sh --prefix=/usr
}

src_compile() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	local myconf
		use pango && myconf="${myconf} --with-font-backend=pango"

	econf \
		$(use_enable sqlite database) \
		$(use_enable sqlite icon-database) \
		$(use_enable sqlite dom-storage) \
		$(use_enable sqlite offline-web-applications) \
		$(use_enable video) \
		$(use_enable svg) \
		$(use_enable debug) \
		$(use_enable xslt) \
		$(use_enable coverage) \
		${myconf} \
		|| die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
