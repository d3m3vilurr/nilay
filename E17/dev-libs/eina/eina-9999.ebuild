# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eet/eet-9999.ebuild,v 1.4 2005/03/25 17:51:29 vapier Exp $

inherit enlightenment

DESCRIPTION="Eina is a multi-platform library that provides optimized data types and a few tools that could be used for projects."

DEPEND="dev-libs/glib:2
doc? ( app-doc/doxygen )
"
IUSE="mmx sse sse2 altivec pthread tests e17benchmark doc"

src_compile() {
	export MY_ECONF="
	$(use_enable mmx cpu-mmx)
	$(use_enable sse cpu-sse)
	$(use_enable sse2 cpu-sse2)
	$(use_enable altivec cpu-altivec)
	$(use_enable pthread)
	$(use_enable tests)
	$(use_enable e17benchmark e17)
	--enable-default-mempool
	--enable-ememoa
	"
	if ! use doc; then
		MY_ECONF="${MY_ECONF} --disable-doc"
	fi	
	enlightenment_src_compile
}	
