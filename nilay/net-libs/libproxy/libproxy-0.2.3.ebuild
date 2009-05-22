# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="A library handling all the details of proxy configuration."
HOMEPAGE="http://code.google.com/p/libproxy"
SRC_URI="http://libproxy.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	./configure --prefix=/usr --without-gnome --without-kde --with-webkit=no --with-mozjs=no --with-networkmanager=no
	emake || die "failed."
}

src_install() {
	emake install DESTDIR=${D} || die "failed."
}

