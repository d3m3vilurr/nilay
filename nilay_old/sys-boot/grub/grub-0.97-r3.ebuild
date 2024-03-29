# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-0.97-r3.ebuild,v 1.6 2007/01/02 04:22:46 ticho Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
inherit mount-boot eutils flag-o-matic toolchain-funcs autotools

PATCHVER="1.5-ext"
DESCRIPTION="GNU GRUB Legacy boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="static netboot custom-cflags"

DEPEND=">=sys-libs/ncurses-5.2-r5"
PROVIDE="virtual/bootloader"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patch breaks booting for some people #111885
	rm "${WORKDIR}"/patch/400_*

	if [[ -n ${PATCHVER} ]] ; then
		EPATCH_SUFFIX="patch"
		epatch "${WORKDIR}"/patch
		eautoreconf
	fi
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86

	unset BLOCK_SIZE #73499

	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.

	# grub-0.95 added -fno-stack-protector detection, to disable ssp for stage2,
	# but the objcopy's (faulty) test fails if -fstack-protector is default.
	# create a cache telling configure that objcopy is ok, and add -C to econf
	# to make use of the cache.
	#
	# CFLAGS has to be undefined running econf, else -fno-stack-protector detection fails.
	# STAGE2_CFLAGS is not allowed to be used on emake command-line, it overwrites
	# -fno-stack-protector detected by configure, removed from netboot's emake.
	use custom-cflags || unset CFLAGS

	export grub_cv_prog_objcopy_absolute=yes #79734
	use static && append-ldflags -static

	# build the net-bootable grub first, but only if "netboot" is set
	if use netboot ; then
		econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		--enable-diskless \
		--enable-{3c{5{03,07,09,29,95},90x},cs89x0,davicom,depca,eepro{,100}} \
		--enable-{epic100,exos205,ni5210,lance,ne2100,ni{50,65}10,natsemi} \
		--enable-{ne,ns8390,wd,otulip,rtl8139,sis900,sk-g16,smc9000,tiara} \
		--enable-{tulip,via-rhine,w89c840} || die "netboot econf failed"

		emake w89c840_o_CFLAGS="-O" || die "making netboot stuff"

		mv -f stage2/{nbgrub,pxegrub} "${S}"/
		mv -f stage2/stage2 stage2/stage2.netboot

		make clean || die "make clean failed"
	fi

	# Now build the regular grub
	# Note that FFS and UFS2 support are broken for now - stage1_5 files too big
	econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt || die "econf failed"
	emake || die "making regular stuff"
}

src_test() {
	# non-default block size also give false pass/fails.
	unset BLOCK_SIZE
	make check || die "make check failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	if use netboot ; then
		exeinto /usr/lib/grub/${CHOST}
		doexe nbgrub pxegrub stage2/stage2.netboot || die "netboot install"
	fi

	insinto /boot/grub
	doins "${DISTDIR}"/splash.xpm.gz
	newins docs/menu.lst grub.conf.sample

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
}

setup_boot_dir() {
	local dir="${1}"

	[[ ! -e ${dir} ]] && die "${dir} does not exist!"
	[[ ! -e ${dir}/grub ]] && mkdir "${dir}/grub"

	# change menu.lst to grub.conf
	if [[ ! -e ${dir}/grub/grub.conf ]] && [[ -e ${dir}/grub/menu.lst ]] ; then
		mv -f "${dir}"/grub/menu.lst "${dir}"/grub/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi

	if [[ ! -e ${dir}/grub/menu.lst ]]; then
	einfo "Linking from new grub.conf name to menu.lst"
		ln -snf grub.conf "${dir}"/grub/menu.lst
	fi

	[[ -e ${dir}/grub/stage2 ]] && mv "${dir}"/grub/stage2{,.old}

	einfo "Copying files from /lib/grub and /usr/lib/grub to "${dir}""
	for x in /lib*/grub/* /usr/lib*/grub/* ; do
		[[ -f ${x} ]] && cp -p ${x} "${dir}"/grub/
	done

	if [[ -e ${dir}/grub/grub.conf ]] ; then
		egrep \
			-v '^[[:space:]]*(#|$|default|fallback|initrd|password|splashimage|timeout|title)' \
			"${dir}"/grub/grub.conf | \
		/sbin/grub --batch \
			--device-map="${dir}"/grub/device.map \
			> /dev/null
	fi
}

pkg_postinst() {
	[[ ${ROOT} != "/" ]] && return 0
	setup_boot_dir /boot
	einfo "To install grub files to another device (like a usb stick), just run:"
	einfo "   emerge --config =${PF}"

	ewarn
	ewarn "*** IMPORTANT NOTE: don't forget to reinstall grub using grub-install or grub"
	ewarn
}

pkg_config() {
	local dir
	einfo "Enter the directory where you want to setup grub:"
	read dir
	setup_boot_dir ${dir}
}
