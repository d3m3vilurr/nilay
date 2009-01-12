# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-0_p37894.ebuild,v 1.1 2008/10/26 15:32:03 jokey Exp $

inherit autotools subversion

MY_P="WebKit"
DESCRIPTION="Open source web browser engine (SVN Live)"
HOMEPAGE="http://www.webkit.org/"
SRC_URI=""

# --- SVN ----
ESVN_REPO_URI="http://svn.webkit.org/repository/webkit/trunk/WebKit"
ESVN_PROJECT="Webkit"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug gstreamer pango soup sqlite svg xslt"

RDEPEND=">=x11-libs/gtk+-2.8
	>=dev-libs/icu-3.8.1-r1
	>=net-misc/curl-7.15
	media-libs/jpeg
	media-libs/libpng
	dev-libs/libxml2
	sqlite? ( >=dev-db/sqlite-3 )
	gstreamer? (
		>=media-libs/gst-plugins-base-0.10
		>=gnome-base/gnome-vfs-2.0
		)
	soup? ( >=net-libs/libsoup-2.23.1 )
	xslt? ( dev-libs/libxslt )
	pango? ( x11-libs/pango )"

DEPEND="${RDEPEND}
	dev-util/gperf
	dev-util/pkgconfig
	virtual/perl-Text-Balanced"

S="${WORKDIR}/${MY_P}"

#src_unpack() {
#	unpack ${A}
#	cd "${S}"

#	eautoreconf
#}

src_compile() {
	# It doesn't compile on alpha without this LDFLAGS
	die "This ebuild doesn't work!"
	eautoreconf
	use alpha && append-ldflags "-Wl,--no-relax"

	local myconf
		use pango && myconf="${myconf} --with-font-backend=pango"
		use soup && myconf="${myconf} --with-http-backend=soup"

	econf \
		$(use_enable sqlite database) \
		$(use_enable sqlite icon-database) \
		$(use_enable sqlite dom-storage) \
		$(use_enable sqlite offline-web-applications) \
		$(use_enable gstreamer video) \
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
