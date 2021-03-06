#
# Copyright (C) 2012 Gerad Munsch <gmunsch@unforgivendevelopment.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=apt-cacher-ng
PKG_VERSION:=0.7.1
PKG_RELEASE:=1

PKG_SOURCE:=apt-cacher-ng_$(PKG_VERSION).orig.tar.xz
PKG_SOURCE_URL:=http://ftp.us.debian.org/debian/pool/main/a/apt-cacher-ng/
PKG_MD5SUM:=f7ccdea08ca9773c0d429f97f61cc848

PKG_CAT:=xzcat

# Perhaps we should define a minimum-dependency package, as well as a "heavy"
# package with as many features (read: dependencies) as possible
#
# Dependencies for light package:
# bzip2
# zlib
#
# Dependencies for heavy package:
# bzip2
# zlib
# xinetd
# perl (do we need sub-packages??)
# fuse (kmod-fuse, fuse-utils, libfuse)
# libwrap
# liblzma (package not present)

define Package/apt-cacher-ng
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  MDEPENDS:=@USE_UCLIBC
  DEPENDS:=+bzip2 +zlib +libstdcpp
  TITLE:=A caching proxy for Debian-type packages
  MAINTAINER:=Gerad Munsch <gmunsch@unforgivendevelopment.com>
  URL:=http://www.unix-ag.uni-kl.de/~bloch/acng/
endef

define Package/apt-cacher-ng/description
	Apt-Cacher-NG is a caching proxy, specifically designed with Debian-style packages in mind.
endef

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/GNUmakefile
	$(call Build/Configure/Default)
endef

define Package/apt-cacher-ng/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/apt-cacher-ng $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/apt-cacher-ng
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/acng.conf $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/security.conf $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) files/backends_debian $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) files/backends_debian.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) files/backends_debvol $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) files/backends_ubuntu $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) files/backends_ubuntu.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/apt-cacher-ng.init $(1)/etc/init.d/apt-cacher-ng
	$(INSTALL_DIR) $(1)/usr/lib/apt-cacher-ng
	$(CP) $(PKG_BUILD_DIR)/conf/archlx_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/cygwin_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/deb_mirrors.gz $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/debvol_mirrors.gz $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/delconfirm.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/distkill.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/epel_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/expire-caller.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/fedora_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/maint.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/report.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/sfnet_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/sl_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/style.css $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/ubuntu_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/urlencode-fixer.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/userinfo.html $(1)/usr/lib/apt-cacher-ng/
endef

define Package/apt-cacher-ng/conffiles
/etc/apt-cacher-ng/acng.conf
/etc/apt-cacher-ng/security.conf
/etc/apt-cacher-ng/backends_debian
/etc/apt-cacher-ng/backends_debian.default
/etc/apt-cacher-ng/backends_debvol
/etc/apt-cacher-ng/backends_ubuntu
/etc/apt-cacher-ng/backends_ubuntu.default
endef

define Package/apt-cacher-ng/postinst
#!/bin/sh
if [ ! -e "/etc/apt-cacher-ng/.configured" ]; then

	# ADDUSER "apt-cacher-ng" --system --group --no-create-home --home /var/cache/apt-cacher-ng
	echo -e "\033[1m* Adding 'apt-cacher-ng' user and group...\033[0m"

	source /etc/functions.sh

	# check for a free UID in the system user range (300-1000)
	for UID in $$(seq 300 1000)
	do
		grep -q -e "^[^:]*:[^:]:$$UID:" /etc/passwd || break
	done
	[ $$UID -eq 1000 ] && { echo "ERROR: Could not find a suitable UID"; exit 1; }

	# check for a free GID in the system group range (300-1000)
	for GID in $$(seq 300 1000)
	do
		grep -q -e "^[^:]*:[^:]:$$GID:" /etc/group || break
	done
	[ $$GID -eq 1000 ] && { echo "ERROR: Could not find a suitable GID"; exit 1; }

	# add new group entry
	group_exists apt-cacher-ng || group_add apt-cacher-ng $$GID

	# add new user entry
	user_exists apt-cacher-ng || user_add apt-cacher-ng $$UID $$GID apt-cacher-ng /srv/apt-cacher-ng

	# set file mode on security.conf
	chown apt-cacher-ng:apt-cacher-ng /etc/apt-cacher-ng/security.conf
	chmod 0600 /etc/apt-cacher-ng/security.conf

	# TODO: Perhaps, in the future, we can come up with a better way to pick a Debian/Ubuntu mirror,
	# perhaps via a lookup on the current IP address to determine country, or something.
	# For now, we just use the generic mirrors, and they're copied from files/ to /etc/apt-cacher-ng/

	# touch /etc/apt-cacher-ng/.configured to indicate that the package has been configured already
	touch /etc/apt-cacher-ng/.configured

	# Basic setup information
	echo -e "\033[1m* apt-cacher-ng is now installed.\033[0m\n"
	echo -e "Please follow the following instructions to enable it:"
	echo -e "\t- Create the directory /srv/apt-cacher-ng on external storage"
	echo -e "\t- If you're using extroot, it's as easy as:"
	echo -e "\033[1m\t\t# mkdir -p /srv/apt-cacher-ng\033[0m"
	echo -e "\t- If you're not using extroot, you can do something like this:"
	echo -e "\033[1m\t\t# mkdir -p /mnt/sda1/srv/apt-cacher-ng\033[0m"
	echo -e "\033[1m\t\t# mount -o bind /mnt/sda1/srv/apt-cacher-ng /srv/apt-cacher-ng\033[0m\n"
	echo -e "\t- Once this step is complete, you can enable the \033[1mapt-cacher-ng\033[0m service by doing:"
	echo -e "\033[1m\t\t# /etc/init.d/apt-cacher-ng enable\033[0m"
	echo -e "\t- And you can start the service by doing:"
	echo -e "\033[1m\t\t# /etc/init.d/apt-cacher-ng start \033[0m"
	echo -e "\t- You can set your mirrors of choice in \033[1m/etc/apt-cacher-ng/backends_*\033[0m"
	echo -e "\033[1m\t\t- It is recommended to leave /etc/apt-cacher-ng/*.default as-is.\033[0m"
fi
endef

define Package/apt-cacher-ng/postrm
#!/bin/sh
rm -f /etc/apt-cacher-ng/.configured
rm -rf /etc/apt-cacher-ng
endef

$(eval $(call BuildPackage,apt-cacher-ng))
