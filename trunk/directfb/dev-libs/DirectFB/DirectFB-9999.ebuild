# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: lucianm Exp $

inherit eutils toolchain-funcs git directfb-dev

IUSE="
	debug debug-support extra-warnings fbcon fusion gettid gif jpeg mmx mpeg
	multi network
	osx png	profile sdl sse static sysfs text trace truetype unique v4l v4l2 vnc
	voodoo X zlib"

IUSE_VIDEO_CARDS="
    ati128 cle266 cyber5k i810 i830 mach64 matrox neomagic nsc nvidia radeon
    savage sis315 tdfx unichrome"
    
IUSE_INPUT_DRIVERS="
    dbox2remote dynapro elo-input gunze h3600_ts joystick keyboard dreamboxremote linuxinput
    lirc mutouch penmount ps2mouse serialmouse sonypijogdial tslib wm97xx"

DESCRIPTION="Thin library on top of the Linux framebuffer devices"
HOMEPAGE="http://www.directfb.org/"

EGIT_REPO_URI="git://git.directfb.org/git/directfb/core/${PN}.git"
KEYWORDS=""

LICENSE="LGPL-2.1"
SLOT="0"


DEPEND="
	fusion? ( ~dev-libs/linux-fusion-${PV} )
	sysfs? ( sys-fs/sysfsutils )
	sdl? ( media-libs/libsdl )
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	mpeg? ( media-libs/libmpeg3 )
	truetype? ( >=media-libs/freetype-2.0.1 )"

pkg_setup() {
	if [ -z "${VIDEO_CARDS}" ] ; then
		ewarn ""
		ewarn ""
		ewarn "All video drivers will be built since you did not specify"
		ewarn "via the VIDEO_CARDS variable what video card you use."
		einfo "DirectFB supports: ${IUSE_VIDEO_CARDS} all none"
		ewarn ""
	fi
	if [ -z "${INPUT_DRIVERS}" ] ; then
		ewarn ""
		ewarn ""
		ewarn "All input drivers will be built since you did not specify"
		ewarn "via the INPUT_DRIVERS variable what input drivers you use."
		einfo "DirectFB supports: ${IUSE_INPUT_DRIVERS} all none"
		ewarn ""
	fi
	directfb-dev_pkg_setup
}

src_unpack() {
	git_src_unpack

	apply_local_patches
}

src_compile() {

	local vidcards card
	for card in ${VIDEO_CARDS} ; do
		has ${card} ${IUSE_VIDEO_CARDS} && vidcards="${vidcards},${card}"
	done
	[ -z "${vidcards}" ] \
		&& vidcards="all" \
		|| vidcards="${vidcards:1}"
	local inputdrivers inputdevice
	for inputdevice in ${INPUT_DRIVERS} ; do
		has ${inputdevice} ${IUSE_INPUT_DRIVERS} && inputdrivers="${inputdrivers},${inputdevice}"
	done
	[ -z "${inputdrivers}" ] \
		&& inputdrivers="all" \
		|| inputdrivers="${inputdrivers:1}"		
	local sdlconf="--disable-sdl"
	if use sdl ; then
		# since SDL can link against DirectFB and trigger a
		# dependency loop, only link against SDL if it isn't
		# broken #61592
		echo 'int main(){}' > sdl-test.c
		$(tc-getCC) sdl-test.c -lSDL 2>/dev/null \
			&& sdlconf="--enable-sdl" \
			|| ewarn "Disabling SDL since libSDL.so is broken"
	fi

	use mpeg && export CPPFLAGS="${CPPFLAGS} -I/usr/include/libmpeg3"
	
	local CONFPARAMS="
		$(use_enable fbcon fbdev)
		$(use_enable mmx)
		$(use_enable sse)
		$(use_enable mpeg libmpeg3)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable gif)
		$(use_enable truetype freetype)
		$(use_enable fusion multi)
		$(use_enable debug)
		$(use_enable debug-support)
		$(use_enable static)
		$(use_enable sysfs)
		$(use_enable v4l video4linux)
		$(use_enable v4l2 video4linux2)
		$(use_enable zlib)
		$(use_enable vnc)
		$(use_enable voodoo)
		$(use_enable unique)
		$(use_enable profile profiling)
		$(use_enable trace)
		$(use_enable extra-warnings)
		$(use_enable X x11)
		$(use_enable osx)
		$(use_enable gettid)
		$(use_enable text)
		$(use_enable network)
		$(use_enable multi)
		${sdlconf}
		--with-gfxdrivers="${vidcards}"
		--with-inputdrivers="${inputdrivers}"
		"
	cd ${S}

	./autogen.sh --prefix=/usr ${CONFPARAMS} || die

	emake || die
}

src_install() {
	insinto /etc
	doins fb.modes

	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README* TODO BUGS
	dohtml -r docs/html/*
}

pkg_postinst() {
	ewarn "Each DirectFB update in the 0.9.xx or 1.xx.xx series"
	ewarn "may break DirectFB related applications."
	ewarn "Please run \"revdep-rebuild\" which can be"
	ewarn "found by emerging the package 'gentoolkit'."
	ewarn
	ewarn "If you have an ALPS touchpad, then you might"
	ewarn "get your mouse unexpectedly set in absolute"
	ewarn "mode in all DirectFB applications."
	ewarn "This can be fixed by removing linuxinput from"
	ewarn "INPUT_DEVICES."
}
