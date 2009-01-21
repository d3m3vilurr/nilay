# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="ECompizconfig Settings Manager"
SRC_URI="http://itask-module.googlecode.com/files/ecsm.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-python/ecompconfig-python
	>=dev-python/pygtk-2.10"

S="${PN}"

src_compile() {
	cd ${S}
	./setup.py build --prefix=/usr
}

src_install() {
	cd ${S}
	./setup.py install --root="${D}" --prefix=/usr
}

