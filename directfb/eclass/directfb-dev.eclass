# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $
#
# Author:
#   Lucian Muresan <lucianm AT users DOT sourceforge DOT net>
#   based upon code from the vdr-plugin.eclass by
#     Matthias Schwarzott <zzam@gentoo.org>
#     Joerg Bornkessel <hd_brummy@gentoo.org>

# directfb-dev.eclass
#

directfb-dev_pkg_setup() {
	if [ -z "${DFB_LOCAL_PATCHES_DIR}" ] ; then
		patch_help
	else
		if ! [ -d "${DFB_LOCAL_PATCHES_DIR}/${PN}/${PV}" ] ; then
			patch_help
		fi
	fi
}

patch_help() {
	einfo ""
	einfo ""
	ewarn "This code is highly experimental!"
	einfo ""
	einfo "You may add your own patches like this:"
	einfo ""
	einfo " - Add the following variable to your /etc/make.conf:"
	einfo "   DFB_LOCAL_PATCHES_DIR=\"/path/to/my/patches\""
	einfo ""
	einfo " - Create the following subdirectories inside your local patch directory:"
	einfo "   ${PN}/${PV}"
	einfo ""
	einfo " - Place your patches ending on *.diff or *.patch in the created"
	einfo "   \"${PV}\" directory, they will be applied in alpha-numerical order"
	einfo ""
}

directfb-dev_apply_local_patches() {
	cd ${S}
	if test -d "${DFB_LOCAL_PATCHES_DIR}/${PN}"; then
		echo
		einfo "Applying local patches found in"
		einfo "${DFB_LOCAL_PATCHES_DIR}:"
		for LOCALPATCH in ${DFB_LOCAL_PATCHES_DIR}/${PN}/${PV}/*.{diff,patch}; do
			test -f "${LOCALPATCH}" && epatch "${LOCALPATCH}"
		done
	fi
}

EXPORT_FUNCTIONS pkg_setup apply_local_patches
