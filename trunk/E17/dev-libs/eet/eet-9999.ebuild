# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-9999.ebuild,v 1.4 2005/03/25 17:51:29 vapier Exp $

inherit enlightenment

DESCRIPTION="E file chunk reading/writing library"
HOMEPAGE="http://www.enlightenment.org/pages/eet.html"

DEPEND="=dev-libs/eina-9999
	media-libs/jpeg
	sys-libs/zlib
	gnutls? ( net-libs/gnutls )
	openssl? ( dev-libs/openssl )
	"
IUSE="gnutls openssl doc"

src_compile() {
	export MY_ECONF="
	$(use_enable doc)
	$(use_enable gnutls)
	$(use_enable openssl)
	$(use_enable openssl cypher)
	$(use_enable openssl cipher)
	$(use_enable gnutls signature)
	$(use_enable openssl signature)
	"
	enlightenment_src_compile
}
