# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gfxboot/gfxboot.ebuild,v 1.1
# 2007/29/03 16:55:00 Rion Exp $


inherit rpm distutils versionator

#to update linguas list you can do ls *.po | sed 's/\(\w*\).po/linguas_\1/'
#in po dir of SuSE theme and insert list here

IUSE_LINGUAS="linguas_af
linguas_ar
linguas_bg
linguas_ca
linguas_cs
linguas_da
linguas_de
linguas_el
linguas_en
linguas_es
linguas_et
linguas_fi
linguas_fr
linguas_gu
linguas_hi
linguas_hr
linguas_hu
linguas_id
linguas_it
linguas_ja
linguas_lt
linguas_mr
linguas_nb
linguas_nl
linguas_pa
linguas_pl
linguas_pt_BR
linguas_pt
linguas_ro
linguas_ru
linguas_sk
linguas_sl
linguas_sr
linguas_sv
linguas_ta
linguas_tr
linguas_uk
linguas_xh
linguas_zh_CN
linguas_zh_TW
linguas_zu"

IUSE="themes doc ${IUSE_LINGUAS}"

MY_PV=$(replace_version_separator 3 '-')
VC=$(get_version_components)
MY_S="${WORKDIR}/${PN}-"
for i in ${VC}; do MY_S="${MY_S}${i}."; done
MY_S=${MY_S%.}
MY_S=${MY_S%.*}

DESCRIPTION="gfxboot allows you to create gfx menus for bootmanagers."
HOMEPAGE="http://suse.com"
SRC_URI="http://download.opensuse.org/distribution/SL-OSS-factory/inst-source/suse/src/gfxboot-${MY_PV}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

THEMES="SuSE NLD SLES Zen"

DEPEND="dev-lang/nasm
	>=media-libs/freetype-2
	themes? ( dev-libs/fribidi )
	doc? ( app-text/xmlto )"

src_unpack () {
	local LANGS=""
	for LNG in ${IUSE_LINGUAS}; do
		if use ${LNG}; then
			LANGS="${LANGS} ${LNG#linguas_}"
		fi;
	done;
	LANGS="${LANGS# }"
	einfo "${LANGS}"

	rpm_src_unpack ${A}
	mv ${MY_S} ${S}
	cd "${WORKDIR}"
	mv themes "${S}/"
	cd "${S}"
	epatch "${FILESDIR}"/bininstall.patch

	local FTRANS;
	local DND;
	find themes/SuSE/ -type f -name "help-boot.*.html" | while read f ; do
		FTRANS=`basename ${f}`
		FTRANS="${FTRANS#help-boot.}"
		FTRANS="${FTRANS%.html}"
		DND="0"
		for lng in ${LANGS}
		do
			if [ "${lng}" == "${FTRANS}" ]; then
				DND="1"
			fi;
		done;
		if [ "${DND}" == "0" ]; then
			einfo "deleting ${f}"
			rm ${f}
		fi;
	done;

	find themes/SuSE/ -type f -name "help-install.*.html" | while read f ; do
		FTRANS=`basename ${f}`
		FTRANS="${FTRANS#help-install.}"
		FTRANS="${FTRANS%.html}"
		DND="0"
		for lng in ${LANGS}
		do
			if [ "${lng}" == "${FTRANS}" ]; then
				DND="1"
			fi;
		done;
		if [ "${DND}" == "0" ]; then
			einfo "deleting ${f}"
			rm ${f}
		fi;
	done;

	find themes/SuSE/po/ -type f -name "*.po" | while read f ; do
		FTRANS=`basename ${f}`
		FTRANS="${FTRANS%.po}"
		DND="0"
		for lng in ${LANGS}
		do
			if [ "${lng}" == "${FTRANS}" ]; then
				DND="1"
			fi;
		done;
		if [ "${DND}" == "0" ]; then
			einfo "deleting ${f}"
			rm ${f}
		fi;
	done;

#	if use themes; then
#		for th in ${THEMES}; do
#			sed -i -e "s/addsuffix .tr,en \$(notdir \$(basename \$(wildcard po\/\*.po)))/addsuffix .tr,${LANGS}/" themes/${th}/Makefile
#		done;
#	fi;

}

src_compile() {
	cd "${S}"
	emake X11LIBS=/usr/X11R6/lib/ || die "Make failed!"
	if use themes; then
		for th in ${THEMES}; do
			emake prep -C themes/${th}/ || die "Preparing of ${th} theme failed!"
		done;
		emake themes || die "Make themes failed!"
	fi;
	if use doc; then
		emake doc || die "Make doc failed!"
	fi;
}
		
src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	if use doc; then
		mkdir -p ${D}/usr/share/doc/gfxboot
		cp -a doc/gfxboot.txt ${D}/usr/share/doc/gfxboot/
		cp -a doc/gfxboot.html ${D}/usr/share/doc/gfxboot/
	fi;
	if use themes; then
		#mv ${D}themes ${D}usr/share/gfxboot
		for th in ${THEMES}; do
			cd ${D}usr/share/gfxboot/themes/${th}
			find . -type l -exec rm '{}' \; -exec ln -sf /usr/share/gfxboot/themes/SuSE/'{}' '{}' \;
		done;
	else
		rm -rf ${D}usr/share/gfxboot/themes
	fi;
}

pkg_postinst() {
	einfo "read manual on how to build theme"
	einfo "if you build gfxboot with doc use flag, manual must be in
	/usr/share/doc/gfxboot"
}
