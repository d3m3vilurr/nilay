# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-2.8.4-r3.ebuild,v 1.1 2007/11/20 18:12:34 armin76 Exp $

inherit eutils versionator gnome2 cvs

DESCRIPTION="Graphical IRC client (LIVE cvs version)"
SRC_URI=""
HOMEPAGE="http://www.xchat.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="perl dbus tcl python ssl mmx ipv6 libnotify nls spell xchatnogtk transparency cvs_pass"

RDEPEND=">=dev-libs/glib-2.6.0
	dev-libs/pth
	!xchatnogtk? ( >=x11-libs/gtk+-2.10.0 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.6.1 )
	python? ( >=dev-lang/python-2.2 )
	tcl? ( dev-lang/tcl )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	spell? ( app-text/enchant )
	libnotify? ( x11-libs/libnotify )
	!<net-irc/xchat-gnome-0.9"
# add pth dependency
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/xchat2/"

src_unpack() {
	ECVS_PASS=""
	ECVS_UP_OPT="-dPC"
	ECVS_CO_OPT="-P"
	ECVS_CVS_COMMAND="cvs -z3"
	ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/xchat"
	ECVS_MODULE="xchat2"
	ECVS_SERVER="xchat.cvs.sourceforge.net:/cvsroot/xchat"
	#cvs -d:pserver:anonymous@xchat.cvs.sourceforge.net:/cvsroot/xchat login
	if ! use cvs_pass; then
		cvs_src_unpack || die "cvs failed"
	fi
	#unpack ${A}
	cd "${S}" || die "cd failed"
	#cd "xchat"

	#use xchatdccserver && epatch "${DISTDIR}"/xchat-dccserver-0.6.patch.bz2

	# use libdir/xchat/plugins as the plugin directory
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:${prefix}/lib/xchat:${libdir}/xchat:' \
			"${S}"/configure{,.in} || die
	fi

	# not work
	#epatch "${FILESDIR}"/xc284-scrollbmkdir.diff
	#epatch "${FILESDIR}"/xc284-improvescrollback.diff
	#epatch "${FILESDIR}"/xc284-fix-scrollbfdleak.diff
	ewarn "all patches are not available in xchat cvs version."
	if use transparency; then
		ewarn "transparency patch passed and not applied."
	fi
}

src_compile() {
	# Added for to fix a sparc seg fault issue by Jason Wever <weeve@gentoo.org>
	if [[ ${ARCH} = sparc ]] ; then
		replace-flags "-O[3-9]" "-O2"
	fi

	# xchat's configure script uses sys.path to find library path
	# instead of python-config (#25943)
	unset PYTHONPATH
	einfo "running autogen.sh"
	./autogen.sh

	econf \
		--enable-maintianer-mode \
		--enable-shm \
		--enable-threads=pth \
		$(use_enable ssl openssl) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcl) \
		$(use_enable mmx) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable dbus) \
		$(use_enable spell spell static) \
		$(use_enable !xchatnogtk gtkfe) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	USE_DESTDIR=1 gnome2_src_install || die "make install failed"

	# install plugin development header
	insinto /usr/include/xchat
	doins src/common/xchat-plugin.h || die "doins failed"

	dodoc ChangeLog README* || die "dodoc failed"
}

pkg_postinst() {
	elog
	elog "XChat binary has been renamed from xchat-2 to xchat."
	elog
	ewarn "This is LIVE CVS Ebuild for Xchat2."
	ewarn "USE AT OWN RISK!"

	if has_version net-irc/xchat-systray
	then
		elog "XChat now includes it's own systray icon, you may want to remove net-irc/xchat-systray."
		elog
	fi
}
