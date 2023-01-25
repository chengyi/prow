# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="force any tcp connections to flow through a proxy (or proxy chain)"
HOMEPAGE="https://github.com/rofl0r/proxychains-ng/"
EGIT_REPO_URI="https://github.com/rofl0r/proxychains-ng"
EGIT_BRANCH="master"
inherit git-r3
SLOT="0"

S=${WORKDIR}/${P}

src_prepare() {
	default
	sed -i "s/^\(LDSO_SUFFIX\).*/\1 = so.${PV}/" Makefile || die
	tc-export CC
}

src_configure() {
	# not autotools
	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--sysconfdir="${EPREFIX}"/etc \
		|| die
}

src_install() {
	dobin ${PN}4
	dobin ${PN}4-daemon
	dodoc AUTHORS README TODO

	dolib.so lib${PN}4.so.${PV}
	dosym lib${PN}4.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
	dosym lib${PN}4.so.${PV} /usr/$(get_libdir)/lib${PN}.so

	insinto /etc
	doins src/${PN}.conf
	insinto /usr/share/zsh/site-functions
	doins completions/_proxychains4
}
