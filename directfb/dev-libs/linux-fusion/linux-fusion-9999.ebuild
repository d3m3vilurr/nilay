# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $

inherit eutils linux-mod git directfb-dev

DESCRIPTION="provide statistical information for the Linux /proc file system"
HOMEPAGE="http://directfb.org/wiki/index.php/Fusion_Proc_Filesystem"
EGIT_REPO_URI="git://git.directfb.org/git/directfb/core/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

MODULE_NAMES="fusion(drivers/char:${S}:${S}/linux/drivers/char/fusion)"
BUILD_TARGETS="all"
MODULESD_REALTIME_DOCS="AUTHORS ChangeLog README"

pkg_setup() {
	linux-mod_pkg_setup
	directfb-dev_pkg_setup
}

src_unpack() {
	git_src_unpack
	apply_local_patches
	convert_to_m Makefile
}

src_install() {
	linux-mod_src_install
	insinto /usr/include/linux
	doins "${S}"/linux/include/linux/fusion.h || die
	dodoc README ChangeLog TODO
	insinto /etc/udev/rules.d
	newins "${FILESDIR}"/fusion.udev 60-fusion.rules
}
