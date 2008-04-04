# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla-firefox/mozilla-firefox-2.0-r2.ebuild,v 1.2 2006/12/03 17:02:55 genstef Exp $

WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-2 mozilla-launcher makeedit multilib fdo-mime mozextension autotools

MPV="3.0b5"
LANGS="af ar be ca cs da de el en-GB es-AR es-ES eu fi fr fy-NL gu-IN he hu id it ja ka ko ku lt mk mn nb-NO nl nn-NO pa-IN pl pt-BR pt-PT ro ru sk sq sr sv-SE tr uk zh-CN zh-TW"
#LANGS="ar be ca cs de es-ES eu fi fr fy-NL ga-IE gu-IN he hu it ja ka ko lt nb-NO nl pa-IN pl pt-BR pt-PT ro ru sk sv-SE tr uk zh-CN zh-TW"

DESCRIPTION="Firefox Web Browser."
HOMEPAGE="http://www.mozilla.org/projects/firefox/"

KEYWORDS="~amd64 ~sparc ~x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"
IUSE="java mozdevelop xforms bindist restrict-javascript startup-notification glitz mozbranding uconv"

#SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/${MPV}-candidates/rc3/firefox-${MPV}-source.tar.bz2"
SRC_URI="http://nidev.kkaul.com/ff_xpis/dists/firefox-3.0b5-source.tar.bz2
http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${MPV}/source/firefox-${MPV}-source.tar.bz2"
# http://dev.gentooexperimental.org/~anarchy/dist/${PATCH}.tar.bz2"


# These are in
#
#  http://releases.mozilla.org/pub/mozilla.org/firefox/releases/${PV}/linux-i686/xpi/
#
# for i in $LANGS $SHORTLANGS; do wget $i.xpi -O ${P}-$i.xpi; done
# path is fixed.
# official -> http://nidev.kkaul.com/ff_xpis/firefox-${MPV}-${X}.xpi
for X in ${LANGS} ; do
	SRC_URI="${SRC_URI}
	linguas_${X/-/_}?(http://nidev.kkaul.com/ff_xpis/firefox-${MPV}-${X}.xpi )"
	IUSE="${IUSE} linguas_${X/-/_}"
	# english is handled internally
	if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
		SRC_URI="${SRC_URI}
			linguas_${X%%-*}?
			(http://nidev.kkaul.com/ff_xpis/firefox-${MPV}-${X}.xpi )"
		IUSE="${IUSE} linguas_${X%%-*}"
	fi
done

RDEPEND="java? ( virtual/jre )
	>=www-client/mozilla-launcher-1.55
	>=sys-devel/binutils-2.18
	>=dev-libs/nss-3.12_beta3
	>=dev-db/sqlite-3.5.0
	>=dev-libs/nspr-4.7.1_beta2"

DEPEND="${RDEPEND}
	java? ( >=dev-java/java-config-0.2.0 )
	startup-notification? ( >=x11-libs/startup-notification-0.2 )"

PDEPEND="restrict-javascript? ( x11-plugins/noscript )"

S="${WORKDIR}/mozilla"

linguas() {
	local LANG SLANG
	for LANG in ${LINGUAS}; do
		if has ${LANG} en en_US; then
			has en ${linguas} || linguas="${linguas:+"${linguas} "}en"
			continue
		elif has ${LANG} ${LANGS//-/_}; then
			has ${LANG//_/-} ${linguas} || linguas="${linguas:+"${linguas} "}${LANG//_/-}"
			continue
		elif [[ " ${LANGS} " == *" ${LANG}-"* ]]; then
			for X in ${LANGS}; do
				if [[ "${X}" == "${LANG}-"* ]] && \
					[[ " ${NOSHORTLANGS} " != *" ${X} "* ]]; then
					has ${X} ${linguas} || linguas="${linguas:+"${linguas} "}${X}"
					continue 2
				fi
			done
		fi
		ewarn "Sorry, but mozilla-firefox does not support the ${LANG} LINGUA"
	done
	einfo "Selected language packs (first will be default): $linguas"
}

pkg_setup(){
	use mozbranding
	if ! built_with_use x11-libs/cairo X; then
		eerror "Cairo is not built with X useflag."
		eerror "Please add 'X' to your USE flags, and re-emerge cairo."
		die "Cairo needs X"
	fi
	if use bindist; then
		ewarn "Mozilla branding is disabled."
	else
		ewarn "Mozilla branding is enabled by default. You should not re-distribute this package."
	fi
	use moznopango && warn_mozilla_launcher_stub
}

src_unpack() {

	unpack ${A%bz2*}bz2

	linguas
	for X in ${linguas}; do
		[[ ${X} != "en" ]] && xpi_unpack "firefox-${MPV}-${X}.xpi"
	done

	cd "${S}"

	# Apply our patches. Export a variable.
	EPATCH_FORCE="yes" #epatch "${WORKDIR}"/patch

	if use filepicker; then
		epatch ${FILESDIR}/mozilla-filepicker.patch
	fi

	#epatch ${FILESDIR}/firefox-3.0-cairoheaderfixes.patch

	# Fix a compilation issue using the 32-bit userland with 64-bit kernel on
	# PowerPC, because with that configuration, it detects a ppc64 system.
	# -- hansmi, 2005-11-13
	einfo "Patching from nidev\'s patches."
	epatch ${FILESDIR}/nidev-typeahead_ext-makefile_fix.patch
	einfo "Patching from mozilla overlay patches."
	epatch ${FILESDIR}/998_install_icon-v2.patch
	ewarn "sqlite3 patch doesn't applied. (maybe merged into main src.)"
	#epatch ${FILESDIR}/101_system_sqlite3.patch
	# It has error?
	# Does not need this patch.
	epatch ${FILESDIR}/068_firefox-nss-gentoo-fix.patch
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
	#mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss
	mozconfig_annotate '' --enable-default-toolkit=cairo-gtk2
	mozconfig_annotate '' --enable-svg-renderer=cairo
	mozconfig_annotate '' --with-system-png
	mozconfig_annotate '' --with-system-jpeg
	mozconfig_annotate '' --with-x
	mozconfig_annotate '' --enable-system-cairo
	# changed 195639
	mozconfig_annotate '' --enable-image-decoders=default
	#mozconfig_annotate '' --enable-image-encoders=default
	# added sqlite3
	mozconfig_annotate '' --enable-system-sqlite3
	# safe browsing features
	mozconfig_annotate '' --enable-safe-browsing
	# javascript optimizer(?)
	mozconfig_annotate '' --enable-js-ultrasparc
	mozconfig_annotate '' --enable-necko-small-buffers
	# --enable-optimize=[OPT] Specify compiler optimization flags [OPT=-O]
	mozconfig_annotate '' --enable-optimize=-O2

	# iconv support, ㅄ
	if use uconv; then
		mozconfig_annotate '' --enable-native-uconv
		ewarn "Uconv feature has critical problem at CJK Langauge."
		ewarn "It is not recommended. If you are using multibyte charset,"
		ewarn "You MUST remove this flag."
	fi
	# url classifier module
	mozconfig_annotate '' --enable-url-classifier
	# Garbage collector
	# mozconfig_annotate '' --enable-boehm
	# Corel/Eazel profiler support
	#mozconfig_annotate '' --enable-eazel-profiler-support
	mozconfig_annotate '' --enable-jemalloc
	# From official overlay.
	mozconfig_annotate 'places' --enable-storage --enable-places --enable-places_bookmarks


	if use startup-notification; then
		mozconfig_annotate '' --enable-startup-notification
	fi

	if use glitz; then
		ewarn "For testing, we can't support cairo-glitz any more. sorry."
		mozconfig_annotate '' --enable-glitz
	fi

	if use java; then
		mozconfig_annotate '' --enable-javaxpcom
	fi
	
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

	linguas
	for X in ${linguas}; do
		[[ ${X} != "en" ]] && xpi_install "${WORKDIR}"/"firefox-${MPV}-${X}"
	done

	local LANG=${linguas%% *}
	if [[ -n ${LANG} && ${LANG} != "en" ]]; then
		einfo "Setting default locale to ${LANG}"
		dosed -e "s:general.useragent.locale\", \"en-US\":general.useragent.locale\", \"${LANG}\":" \
			"${MOZILLA_FIVE_HOME}"/defaults/pref/firefox.js \
			"${MOZILLA_FIVE_HOME}"/defaults/pref/firefox-l10n.js || \
			die "sed failed to change locale"
	fi

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

	# Install files for some package.
	einfo "Installing includes and idl files..."
	cp -LfR "${S}"/dist/include "${D}"/"${MOZILLA_FIVE_HOME}" || die "cp failed"
	cp -LfR "${S}"/dist/idl "${D}"/"${MOZILLA_FIVE_HOME}" || die "cp failed"

	# Dirty hack to get some applications using this header running
	dosym "${MOZILLA_FIVE_HOME}"/include/necko/nsIURI.h \
		"${MOZILLA_FIVE_HOME}"/include/nsIURI.h

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

	elog "Please rebuild packages related with Firefox."
	elog "================== LOOK AT ME =================="
	elog "Nilay's Firefox 3 Beta ebuilds are not following standard versioning."
	elog "Because of this reason, Nilay will remove all Firefox ebuilds after"
	elog "Portage's offical release."
	elog "You HAVE BEEN WARNED."
	elog "(Beta 5 would be end of firefox beta, I assume.)"
}

pkg_postrm() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	update_mozilla_launcher_symlinks
}



