# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MYP=wxMaxima-${PV}

DESCRIPTION="A Graphical frontend to Maxima, using the wxWidgets toolkit."
HOMEPAGE="http://wxmaxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc"

DEPEND=">=dev-libs/libxml2-2.5.0
	>=x11-libs/wxGTK-2.6"
RDEPEND=">=sci-mathematics/maxima-5.9.2"

S=${WORKDIR}/${MYP}

src_unpack () {
	unpack ${A}
	
	sed 's|#PF#|'${PF}'|g' ${FILESDIR}/${PN}-docfiles.patch > ${PN}-docfiles.patch
		
	epatch ${PN}-docfiles.patch

	cd ${S}
	einfo "Regenerating autotools files..."
	automake || die "automake failed"
}	


src_compile () {
	econf $(use_enable static static-wx) || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	insinto /usr/share/pixmaps/
	doins maxima-new.png 
	make_desktop_entry wxmaxima wxMaxima maxima-new
	
	cd ${S}/data
	
	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins docs.zip intro.zip
	fi
}
