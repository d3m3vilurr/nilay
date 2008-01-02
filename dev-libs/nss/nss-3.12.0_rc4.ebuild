# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic multilib cvs

NSPR_VER="4.7.0_rc3"
RTM_NAME="NSS_${PV//./_}_RTM"
DESCRIPTION="Mozilla's Netscape Security Services Library that implements PKI support"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/nss/"
SRC_URI=""

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="offline cvs_pkg"

DEPEND="app-arch/zip
	>=dev-libs/nspr-${NSPR_VER}
	>=dev-db/sqlite-3.4.1"
S="${WORKDIR}"
src_unpack() {

	#basis settings
	ECVS_PASS="anonymous"
	ECVS_UP_OPT="-dPAC"
	ECVS_CO_OPT="-PA"
	ECVS_CVS_COMMAND="cvs -f -z3"
	ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/nss"

	#selecting on|off-line mode
	if use offline && [[ -d "${ECVS_TOP_DIR}" ]]; then
		ECVS_OFFLINE_nss="1"
	else
		ECVS_SERVER="cvs-mirror.mozilla.org:/cvsroot"
	fi

	#nss/nspr hack to actually pull older code
	ECVS_BRANCH="NSS_3_12_ALPHA_2B"

	modules="mozilla/dbm \
			mozilla/security/nss \
			mozilla/security/coreconf \
			mozilla/security/dbm"

	for module in ${modules}; do
		ECVS_MODULE=${module}
		cvs_src_unpack || die "cvs failed"
	done
	cd ${S} || die "could not change to ${S}"
	# hack nspr paths
	echo 'INCLUDES += -I/usr/include/nspr -I$(DIST)/include/dbm' \
		>> ${S}/mozilla/security/coreconf/headers.mk || die "failed to append include"

	# cope with nspr being in /usr/$(get_libdir)/nspr
	sed -e 's:$(DIST)/lib:/usr/'"$(get_libdir)"/nspr':' \
		-i ${S}/mozilla/security/coreconf/location.mk

	# modify install path
	sed -e 's:SOURCE_PREFIX = $(CORE_DEPTH)/\.\./dist:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i ${S}/mozilla/security/coreconf/source.mk

	cd ${S}
	epatch ${FILESDIR}/01_rpath.patch
	epatch ${FILESDIR}/25_entropy.patch
	epatch ${FILESDIR}/38_mips64_build.patch
	epatch ${FILESDIR}/80_security_tools.patch
	epatch ${FILESDIR}/82_old_sonames.patch
}

src_compile() {
	strip-flags
	if use amd64 || use ppc64 || use ia64 || use s390; then
		export USE_64=1
	fi
	export NSDISTMODE=copy
	export NSS_USE_SYSTEM_SQLITE=1
	cd ${S}/mozilla/security/coreconf
	emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" || die "coreconf make failed"
	cd ${S}/mozilla/security/dbm
	emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" || die "dbm make failed"
	cd ${S}/mozilla/security/nss
	emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" || die "nss make failed"
}

src_install () {
	MINOR_VERSION=12
	cd ${S}/mozilla/security/dist

	# put all *.a files in /usr/lib/nss (because some have conflicting names
	# with existing libraries)
	dodir /usr/$(get_libdir)/nss
	cp -L */lib/*.so ${D}/usr/$(get_libdir)/nss || die "copying shared libs failed"
	cp -L */lib/*.chk ${D}/usr/$(get_libdir)/nss || die "copying chk files failed"
	cp -L */lib/*.a ${D}/usr/$(get_libdir)/nss || die "copying libs failed"

	# all the include files
	insinto /usr/include/nss
	doins private/nss/*.h
	doins public/nss/*.h
	cd ${D}/usr/$(get_libdir)/nss
	for file in *.so; do
		mv ${file} ${file}.${MINOR_VERSION}
		ln -s ${file}.${MINOR_VERSION} ${file}
	done

	# coping with nss being in a different path. We move up priority to
	# ensure that nss/nspr are used specifically before searching elsewhere.
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/nss" > ${D}/etc/env.d/08nss

	dodir /usr/bin
	dodir /usr/$(get_libdir)/pkgconfig
	cp ${FILESDIR}/nss-config.in ${D}/usr/bin/nss-config
	cp ${FILESDIR}/nss.pc.in ${D}/usr/$(get_libdir)/pkgconfig/nss.pc
	NSS_VMAJOR=`cat ${S}/mozilla/security/nss/lib/nss/nss.h | grep "#define.*NSS_VMAJOR" | awk '{print $3}'`
	NSS_VMINOR=`cat ${S}/mozilla/security/nss/lib/nss/nss.h | grep "#define.*NSS_VMINOR" | awk '{print $3}'`
	NSS_VPATCH=`cat ${S}/mozilla/security/nss/lib/nss/nss.h | grep "#define.*NSS_VPATCH" | awk '{print $3}'`

	sed -e "s,@libdir@,/usr/"$(get_libdir)"/nss,g" \
		-e "s,@prefix@,/usr,g" \
		-e "s,@exec_prefix@,\$\{prefix},g" \
		-e "s,@includedir@,\$\{prefix}/include/nss,g" \
		-e "s,@MOD_MAJOR_VERSION@,$NSS_VMAJOR,g" \
		-e "s,@MOD_MINOR_VERSION@,$NSS_VMINOR,g" \
		-e "s,@MOD_PATCH_VERSION@,$NSS_VPATCH,g" \
		-i ${D}/usr/bin/nss-config
	chmod 755 ${D}/usr/bin/nss-config

	sed -e "s,@libdir@,/usr/"$(get_libdir)"/nss,g" \
	      -e "s,@prefix@,/usr,g" \
	      -e "s,@exec_prefix@,\$\{prefix},g" \
	      -e "s,@includedir@,\$\{prefix}/include/nss," \
	      -e "s,@NSPR_VERSION@,`nspr-config --version`,g" \
	      -e "s,@NSS_VERSION@,$NSS_VMAJOR.$NSS_VMINOR.$NSS_VPATCH,g" \
	      -i ${D}/usr/$(get_libdir)/pkgconfig/nss.pc
	chmod 644 ${D}/usr/$(get_libdir)/pkgconfig/nss.pc
}
