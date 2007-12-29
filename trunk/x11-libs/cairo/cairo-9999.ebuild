# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git multilib

EGIT_REPO_URI="git://git.cairographics.org/git/cairo"

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="doc directfb glitz opengl pdf png ps svg xcb X"

RDEPEND="media-libs/fontconfig
	>=media-libs/freetype-2.1
	sys-libs/zlib
	>=x11-libs/pixman-0.9.4
	X? ( || ( (	x11-libs/libXrender
			x11-libs/libXt )
			virtual/x11 )
		virtual/xft )
	directfb? (dev-libs/DirectFB )
	glitz? ( >=media-libs/glitz-0.4.4 )
	png? ( media-libs/libpng )
	svg? (
		dev-libs/libxml2
		>=gnome-base/librsvg-2.0
		>=x11-libs/gtk+-2.0 )
	xcb? ( >=x11-libs/libxcb-0.9 )
	!<x11-libs/cairo-0.2
	>=app-text/poppler-0.5.1.20060506"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? (	>=dev-util/gtk-doc-1.3
		~app-text/docbook-xml-dtd-4.2 )"

src_compile() {
	if use glitz && use opengl; then
		export glitz_LIBS=-lglitz-glx
	fi
	sh autogen.sh --host=${CHOST} \
		--libdir=/usr/$(get_libdir) \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$(use_with X x) \
		$(use_enable X xlib) \
		$(use_enable xcb) \
		$(use_enable pdf) \
		$(use_enable png) \
		$(use_enable ps) \
		$(use_enable svg) \
		$(use_enable directfb) \
		$(use_enable doc gtk-doc) \
		$(use_enable glitz) || die "autogen failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
