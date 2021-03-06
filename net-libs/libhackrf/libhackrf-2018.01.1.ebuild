# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev

DESCRIPTION="library for communicating with HackRF SDR platform"
HOMEPAGE="http://greatscottgadgets.com/hackrf/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mossmann/hackrf.git"
	inherit git-r3
	KEYWORDS=""
	EGIT_CHECKOUT_DIR="${WORKDIR}/hackrf"
	S="${WORKDIR}/hackrf/host/libhackrf"
else
	S="${WORKDIR}/hackrf-${PV}/host/libhackrf"
	SRC_URI="https://github.com/mossmann/hackrf/releases/download/v${PV}/hackrf-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="+udev"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DENABLE_INSTALL_UDEV_RULES="$(usex udev)"
	)
	if use udev; then
		mycmakeargs+=(
			-DUDEV_RULES_GROUP=usb
			-DUDEV_RULES_PATH="$(get_udevdir)/rules.d"
		)
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	use udev && einfo "Users in the usb group can use hackrf."
}
