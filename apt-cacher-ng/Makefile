#
# Copyright (C) 2012 Gerad Munsch <gmunsch@unforgivendevelopment.com> original author
# Updates are done by Vassilis Virvilis vasvir2@gmail.com
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=apt-cacher-ng
PKG_VERSION:=3.6.3
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION).orig.tar.xz
PKG_SOURCE_URL:=http://ftp.us.debian.org/debian/pool/main/a/apt-cacher-ng/
PKG_HASH:=3f802b5a9c633a3062f44883a7fa2b775ec67d4385c29893286bd212e6658c60
PKG_MAINTAINER:=Vassilis Virvilis <vasvir2@gmail.com>
#PKG_MAINTAINER:=Gerad Munsch <gmunsch@unforgivendevelopment.com>
PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=COPYING

PKG_CAT:=xzcat
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# Possible extra dependencies for an even heavier package
# xinetd
# perl (do we need sub-packages??)
# fuse (kmod-fuse, fuse-utils, libfuse)
# libwrap

define Package/apt-cacher-ng
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=A caching proxy for Debian-type packages
  DEPENDS:=+bzip2 +zlib +libstdcpp +libopenssl +liblzma +libevent2 +libevent2-pthreads +libatomic
  URL:=http://www.unix-ag.uni-kl.de/~bloch/acng/
  MENU:=1
  USERID:=apt-cacher-ng:apt-cacher-ng
  FILE_MODES:=/etc/apt-cacher-ng/security.conf:apt-cacher-ng:apt-cacher-ng:0600
endef

define Package/apt-cacher-ng/description
	Apt-Cacher-NG is a caching proxy, specifically designed with Debian-style packages in mind.
endef

define Package/apt-cacher-ng/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/apt-cacher-ng $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/apt-cacher-ng
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/acng.conf $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/security.conf $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/backends_debian $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/backends_debian.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/backends_ubuntu.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/backends_kali.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/backends_gentoo.default $(1)/etc/apt-cacher-ng/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/apt-cacher-ng.init $(1)/etc/init.d/apt-cacher-ng
	$(INSTALL_DIR) $(1)/usr/lib/apt-cacher-ng
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libsupacng.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/conf/archlx_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/cygwin_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/deb_mirrors.gz $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/debvol_mirrors.gz $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/delconfirm.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/scripts/distkill.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/epel_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/scripts/expire-caller.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/fedora_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/maint.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/report.html $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/sfnet_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/sl_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/style.css $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/ubuntu_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/kali_mirrors $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/gentoo_mirrors.gz $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/scripts/urlencode-fixer.pl $(1)/usr/lib/apt-cacher-ng/
	$(CP) $(PKG_BUILD_DIR)/conf/userinfo.html $(1)/usr/lib/apt-cacher-ng/
endef

define Package/apt-cacher-ng/conffiles
/etc/apt-cacher-ng/acng.conf
/etc/apt-cacher-ng/security.conf
/etc/apt-cacher-ng/backends_debian
/etc/apt-cacher-ng/backends_debian.default
/etc/apt-cacher-ng/backends_ubuntu.default
/etc/apt-cacher-ng/backends_kali.default
/etc/apt-cacher-ng/backends_gentoo.default
endef

define Package/apt-cacher-ng/postinst
#!/bin/sh
	# Basic setup information
	echo -e "\033[1m* apt-cacher-ng is now installed.\033[0m\n"
	echo -e "Please follow the following instructions to enable it:"
	echo -e "\t- Edit the /etc/apt-cacher-ng/acng.conf and assign proper values to \033[1mCacheDir\033[0m and \033[1mLogDir\033[0m on external storage."
	echo -e "\t- Once this step is complete, you can enable the \033[1mapt-cacher-ng\033[0m service by doing:"
	echo -e "\033[1m\t\t# /etc/init.d/apt-cacher-ng enable\033[0m"
	echo -e "\t- And you can start the service by doing:"
	echo -e "\033[1m\t\t# /etc/init.d/apt-cacher-ng start \033[0m"
	echo -e "\t- You can set your mirrors of choice in \033[1m/etc/apt-cacher-ng/backends_*\033[0m"
	echo -e "\033[1m\t\t- It is recommended to leave /etc/apt-cacher-ng/*.default as-is.\033[0m"
endef

$(eval $(call BuildPackage,apt-cacher-ng))
