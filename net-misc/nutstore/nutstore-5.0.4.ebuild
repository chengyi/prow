# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit python-r1 desktop
DESCRIPTION="a cloud service that lets you sync and share files anywhere."
HOMEPAGE="https://www.jianguoyun.com/"
SRC_URI="https://www.jianguoyun.com/static/exe/st/${PV}/nutstore_client-${PV}-linux-x64-public.tar.gz"
LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S="${WORKDIR}"

DEPEND="dev-libs/libappindicator
x11-libs/libnotify
dev-python/pygobject[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="${RDEPEND}"

src_prepare() {
	cd ${S}/gnome-config
	sed -i '/Exec=/s|~/\.nutstore/dist/bin/nutstore-pydaemon.py|/usr/bin/nutstore|' menu/nutstore-menu.desktop
	sed -i '/Categories=Network;/s/Application;//' menu/nutstore-menu.desktop
	sed -i '/Exec=/s|~/\.nutstore/dist|/opt/nutstore|' autostart/nutstore-daemon.desktop
	eapply_user
}

src_compile() {
	cd ${S}/bin
	python_foreach_impl python -m compileall .
}

src_install() {
	cd ${S}
	exeinto /usr/bin
	doexe ${FILESDIR}/nutstore
	diropts -m 755
	dodir /usr/share/licenses/${PN}
	insinto /usr/share/licenses/${PN}
	doins ${FILESDIR}/license
	dodir /opt/${PN}
	cp -aR ./ ${D}/opt/${PN}
	domenu gnome-config/menu/nutstore-menu.desktop
	doicon -s 64 app-icon/nutstore.png
}
