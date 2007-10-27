# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla-firefox/mozilla-firefox-2.0-r2.ebuild,v 1.2 2006/12/03 17:02:55 genstef Exp $

WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-2 mozilla-launcher makeedit multilib fdo-mime mozextension autotools

#PATCH="${PN}-3.0_pre20061216-patches-0.1"
#LANGS="ar bg ca cs da de el en-GB es-AR es-ES eu fi fr fy-NL ga-IE gu-IN hu it ja ko lt mk mn nb-NO nl nn-NO pl pt-BR pt-PT ru sk sl sv-SE tr zh-CN zh-TW"
#NOSHORTLANGS="en-GB es-AR pt-BR zh-TW"

DESCRIPTION="Firefox Web Browser"
HOMEPAGE="http://www.mozilla.org/projects/firefox/"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"
IUSE="java mozdevelop xforms restrict-javascript startup-notification"

SRC_URI="http://releases.mozilla.org/pub/mozilla.org/firefox/releases/granparadiso/alpha8/source/granparadiso-alpha8-source.tar.bz2"
# http://dev.gentooexperimental.org/~anarchy/dist/${PATCH}.tar.bz2"


# These are in
#
#  http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${PV}/linux-i686/xpi/
#
# for i in $LANGS $SHORTLANGS; do wget $i.xpi -O ${P}-$i.xpi; done
#for X in ${LANGS} ; do
#	SRC_URI="${SRC_URI}
#		linguas_${X/-/_}? ( http://gentooexperimental.org/~genstef/dist/${P}-xpi/${P}-${X}.xpi )"
#	IUSE="${IUSE} linguas_${X/-/_}"
#	# english is handled internally
#	if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
#		SRC_URI="${SRC_URI}
#			linguas_${X%%-*}? ( http://gentooexperimental.org/~genstef/dist/${P}-xpi/${P}-${X}.xpi )"
#		IUSE="${IUSE} linguas_${X%%-*}"
#	fi
#done

RDEPEND="java? ( virtual/jre )
	>=www-client/mozilla-launcher-1.39
	>=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.11.1-r1
	>=dev-libs/nspr-4.6.1"
#	>=net-libs/xulrunner-1.9_pre20061231"

DEPEND="${RDEPEND}
	java? ( >=dev-java/java-config-0.2.0 )
	startup-notification? ( >=x11-libs/startup-notification-0.2 )"

PDEPEND="restrict-javascript? ( x11-plugins/noscript )"

S="${WORKDIR}/mozilla"

#linguas() {
#	local LANG SLANG
#	for LANG in ${LINGUAS}; do
#		if has ${LANG} en en_US; then
#			has en ${linguas} || linguas="${linguas:+"${linguas} "}en"
#			continue
#		elif has ${LANG} ${LANGS//-/_}; then
#			has ${LANG//_/-} ${linguas} || linguas="${linguas:+"${linguas} "}${LANG//_/-}"
#			continue
#		elif [[ " ${LANGS} " == *" ${LANG}-"* ]]; then
#			for X in ${LANGS}; do
#				if [[ "${X}" == "${LANG}-"* ]] && \
#					[[ " ${NOSHORTLANGS} " != *" ${X} "* ]]; then
#					has ${X} ${linguas} || linguas="${linguas:+"${linguas} "}${X}"
#					continue 2
#				fi
#			done
#		fi
#		ewarn "Sorry, but mozilla-firefox does not support the ${LANG} LINGUA"
#	done
#	einfo "Selected language packs (first will be default): $linguas"
#}

pkg_setup(){
	if ! built_with_use x11-libs/cairo X; then
		eerror "Cairo is not built with X useflag."
		eerror "Please add 'X' to your USE flags, and re-emerge cairo."
		die "Cairo needs X"
	fi

	use mozbranding
	ewarn "Mozilla branding is enabled by default. You should not re-distribute this package."
	use moznopango && warn_mozilla_launcher_stub
}

src_unpack() {

	unpack ${A%bz2*}bz2

#	linguas
#	for X in ${linguas}; do
#		[[ ${X} != "en" ]] && xpi_unpack "${P}-${X}.xpi"
#	done

	cd "${S}"

	# Apply our patches
	#EPATCH_FORCE="yes" epatch "${WORKDIR}"/patch

#	if use filepicker; then
#		epatch ${FILESDIR}/mozilla-filepicker.patch
#	fi
#
	#epatch ${FILESDIR}/firefox-3.0-cairoheaderfixes.patch

	# Fix a compilation issue using the 32-bit userland with 64-bit kernel on
	# PowerPC, because with that configuration, it detects a ppc64 system.
	# -- hansmi, 2005-11-13
	epatch ${FILESDIR}/nidev-typeahead_ext-makefile_fix.patch
	epatch ${FILESDIR}/cairo-failed-patch.patch
	if use ppc && [[ "${PROFILE_ARCH}" == ppc64 ]]; then
		sed -i -e "s#OS_TEST=\`uname -m\`\$#OS_TEST=${ARCH}#" \
			"${S}"/configure
		sed -i -e "s#OS_TEST :=.*uname -m.*\$#OS_TEST:=${ARCH}#" \
			"${S}"/security/coreconf/arch.mk
	fi

	eautoconf
}
src_compile() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	mozconfig_init
	mozconfig_config

	mozconfig_annotate '' --enable-application=browser
	mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss
	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk2
	mozconfig_annotate '' --enable-svg-renderer=cairo
	mozconfig_annotate '' --enable-system-cairo
	mozconfig_annotate '' --with-system-png
	mozconfig_annotate '' --with-x
	mozconfig_annotate '' --disable-glitz

	
	if use xforms; then
		mozconfig_annotate '' --enable-extensions=default,xforms,schema-validation,typeaheadfind
	else
		mozconfig_annotate '' --enable-extensions=default,typeaheadfind
	fi

	if use mozbranding; then
		mozconfig_annotate '' --enable-official-branding
	fi

	# Bug 60668: Galeon doesn't build without oji enabled, so enable it
	# regardless of java setting.
	mozconfig_annotate '' --enable-oji --enable-mathml

	# Other ff-specific settings
	mozconfig_use_enable mozdevelop jsd
	mozconfig_use_enable mozdevelop xpctools
	mozconfig_use_extension mozdevelop venkman
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	# Add build variables
	mozconfig_build_opts

	# Add xulrunner variable
	echo "ac_add_app_options browser --with-libxul-sdk=/usr/$(get_libdir)/xulrunner --enable-libxul" >> ${S}/.mozconfig

	# Finalize and report settings
	mozconfig_final

	# -fstack-protector breaks us
	if gcc-version ge 4 1; then
		gcc-specs-ssp && append-flags -fno-stack-protector
	else
		gcc-specs-ssp && append-flags -fno-stack-protector-all
	fi
		filter-flags -fstack-protector -fstack-protector-all

	####################################
	#
	#  Configure and build
	#
	####################################

	CPPFLAGS="${CPPFLAGS} -DARON_WAS_HERE" \
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die

	# It would be great if we could pass these in via CPPFLAGS or CFLAGS prior
	# to econf, but the quotes cause configure to fail.
	sed -i -e \
		's|-DARON_WAS_HERE|-DGENTOO_NSPLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsplugins\\\" -DGENTOO_NSBROWSER_PLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsbrowser/plugins\\\"|' \
		${S}/config/autoconf.mk \
		${S}/xpfe/global/buildconfig.html

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	emake -j1 || die
}

pkg_preinst() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	einfo "Removing old installs though some really ugly code.  It potentially"
	einfo "eliminates any problems during the install, however suggestions to"
	einfo "replace this are highly welcome.  Send comments and suggestions to"
	einfo "mozilla@gentoo.org."
	rm -rf "${ROOT}"/"${MOZILLA_FIVE_HOME}"
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# Most of the installation happens here
	dodir "${MOZILLA_FIVE_HOME}"
	cp -RL "${S}"/dist/bin/* "${D}"/"${MOZILLA_FIVE_HOME}"/ || die "cp failed"

#	linguas
#	for X in ${linguas}; do
#		[[ ${X} != "en" ]] && xpi_install "${WORKDIR}"/"${P}-${X}"
#	done
#
#	local LANG=${linguas%% *}
#	if [[ -n ${LANG} && ${LANG} != "en" ]]; then
#		einfo "Setting default locale to ${LANG}"
#		dosed -e "s:general.useragent.locale\", \"en-US\":general.useragent.locale\", \"${LANG}\":" \
#			"${MOZILLA_FIVE_HOME}"/defaults/pref/firefox.js \
#			"${MOZILLA_FIVE_HOME}"/defaults/pref/firefox-l10n.js || \
#			die "sed failed to change locale"
#	fi

	# Create /usr/bin/firefox
	install_mozilla_launcher_stub firefox "${MOZILLA_FIVE_HOME}"

	# Install icon and .desktop for menu entry
	if use mozbranding; then
		doicon "${FILESDIR}"/icon/firefox-icon.png
		newmenu "${FILESDIR}"/icon/mozilla-firefox-1.5.desktop \
			mozillafirefox-3.0a.desktop
	else
		doicon "${FILESDIR}"/icon/firefox-icon-unbranded.png
		newmenu "${FILESDIR}"/icon/mozilla-firefox-1.5-unbranded.desktop \
			mozillafirefox-3.0a.desktop
	fi

	# Fix icons to look the same everywhere
	insinto "${MOZILLA_FIVE_HOME}"/icons
	doins "${S}"/dist/branding/mozicon16.xpm
	doins "${S}"/dist/branding/mozicon50.xpm

	# Install pkgconfig files
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${S}"/build/unix/*.pc

	insinto "${MOZILLA_FIVE_HOME}"/greprefs
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js
	insinto "${MOZILLA_FIVE_HOME}"/defaults/pref
	newins "${FILESDIR}"/gentoo-default-prefs.js all-gentoo.js
}

pkg_postinst() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# This should be called in the postinst and postrm of all the
	# mozilla, mozilla-bin, firefox, firefox-bin, thunderbird and
	# thunderbird-bin ebuilds.
	update_mozilla_launcher_symlinks

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update

	elog "Please remember to rebuild any packages that you have built"
	elog "against firefox. Some packages might be broken by the upgrade; if this"
	elog "is the case, please search at http://bugs.gentoo.org and open a new bug"
	elog "if one does not exist. Before filing any bugs, please move or remove ~/.mozilla"
	elog "and test with a clean profile directory."
}

pkg_postrm() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	update_mozilla_launcher_symlinks
}
