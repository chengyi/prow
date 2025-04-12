# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..12} )
inherit python-r1 desktop unpacker xdg-utils
DESCRIPTION="a cloud service that lets you sync and share files anywhere."
HOMEPAGE="https://www.jianguoyun.com/"
SRC_URI="https://pkg-cdn.jianguoyun.com/static/exe/ex/${PV}/nutstore_client-${PV}-linux-x86_64-public.tar.gz"
LICENSE="custom"
S="${WORKDIR}"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-libs/libappindicator
x11-libs/libnotify
dev-python/pygobject[${PYTHON_USEDEP}]
net-libs/webkit-gtk
${PYTHON_DEPS}"

src_prepare() {
	cd "${S}"/gnome-config
	sed -i '/Exec=/s|~/\.nutstore/dist/bin/nutstore-pydaemon.py|/usr/bin/nutstore|' menu/nutstore-menu.desktop
	sed -i '/Exec=/s|~/\.nutstore/dist|/opt/nutstore|' autostart/nutstore-daemon.desktop
	cd "${S}"/bin
	sed -i '/gvfs-set-attribute/s|gvfs-set-attribute|gio set|' nutstore-pydaemon.py
	eapply_user
}

src_compile() {
	cd "${S}"/bin
	python_foreach_impl python -m compileall .
}

src_install() {
	cd "${S}"
	exeinto /usr/bin
	doexe "${FILESDIR}"/nutstore
	diropts -m 755
	insinto /usr/share/licenses/"${PN}"
	doins "${FILESDIR}"/license
	insinto /opt/"${PN}"
	doins -r "${S}"/*
	domenu gnome-config/menu/nutstore-menu.desktop
	doicon -s 64 app-icon/nutstore.png
	fperms 0755 "/opt/${PN}" -R
}

pkg_postinst() {
	xdg_icon_cache_update
}
