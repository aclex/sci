# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit fortran-2 multilib

DESCRIPTION="A program for optimizing Lipari-Szabo model free parameters to heteronuclear relaxation data"
HOMEPAGE="http://www.palmer.hs.columbia.edu/software/modelfree.html"
SRC_URI="http://www.palmer.hs.columbia.edu/software/modelfree4_linux.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	sci-libs/blas-reference
	sys-devel/gcc:4.1"
DEPEND="dev-util/patchelf"

S="${WORKDIR}"

QA_PREBUILT="opt/bin/.*"

src_install() {
	local _exe
	dosym ../../usr/$(get_libdir)/librefblas.so /opt/${PN}/libblas.so.3
	dosym ../../usr/$(get_libdir)/libreflapack.so /opt/${PN}/liblapack.so.3

	exeinto /opt/bin
	if use x86; then
		_exe=./linux_32/${PN}4
	elif use amd64; then
		_exe=./linux_64/${PN}4
	fi

	patchelf --set-rpath "${EPREFIX}/opt/${PN}:${EPREFIX}/usr/$(get_libdir)/gcc/x86_64-pc-linux-gnu/4.1.2/" ${_exe}

	doexe ${_exe}
	dosym ${PN} "${EPREFIX}"/opt/bin/${PN}4

	use doc && dodoc docs/{modelfree_manual.pdf,VERSIONS.README}
	use examples && insinto /usr/share/${PN} && doins -r testing
}
