# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/entropy/entropy-9999.ebuild,v 1.1 2006/01/17 00:47:22 vapier Exp $

inherit enlightenment

DESCRIPTION="a File Manager For e17"
ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/OLD/${PN}"
DEPEND="media-libs/epsilon
	x11-libs/ewl
	x11-libs/etk
	sys-fs/evfs
	media-libs/libextractor
	>=media-libs/imlib2-1.2.1
	>=media-libs/libpng-1.2.8
	>=x11-libs/ecore-0.9.9"

src_compile() {
	ewarn "This package is classified at OLD."
	export MY_ECONF="
		--enable-plugin-extractor
	"
	enlightenment_src_compile
}

