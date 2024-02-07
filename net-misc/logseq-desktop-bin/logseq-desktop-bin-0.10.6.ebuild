# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg-utils
RESTRICT="mirror strip bindist"
DESCRIPTION="A privacy-first, open-source platform for knowledge sharing and management."
HOMEPAGE="https://github.com/logseq/logseq"
SRC_URI="https://github.com/logseq/logseq/releases/download/${PV}/logseq-linux-x64-${PV}.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"
RDEPEND="dev-libs/wayland"

S="${WORKDIR}"
QA_PREBUILT="
	/opt/${PN}/Logseq
	/opt/${PN}/chrome_crashpad_handler
	/opt/${PN}/chrome_sandbox
	/opt/${PN}/libffmpeg.so
	/opt/${PN}/libEGL.so
	/opt/${PN}/libGLESv2.so
	/opt/${PN}/libvk_swiftshader.so
	/opt/${PN}/libvulkan.so*
	/opt/${PN}/resources/app/node_modules/dugite/git/libexec/git-core/*
"

src_configure() {
	mv "${S}/Logseq-linux-x64" "${S}/${PN}"
}

src_install() {
	insinto /opt
	doins -r "${S}/${PN}"
	dosym "../../opt/${PN}/Logseq" "usr/bin/logseq"
	domenu "${FILESDIR}/logseq-desktop.desktop"
	doicon -s 512 "${S}/${PN}/resources/app/icons/logseq.png"
	fperms 0755 "/opt/${PN}" -R
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
