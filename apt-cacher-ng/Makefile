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

#PKG_BUILD_DIR:=$(BUILD_DIR)/apt-cacher-ng-$(PKG_VERSION)
PKG_SOURCE:=apt-cacher-ng_$(PKG_VERSION).orig.tar.xz
PKG_SOURCE_URL:=http://ftp.us.debian.org/debian/pool/main/a/apt-cacher-ng/
PKG_MD5SUM:=f7ccdea08ca9773c0d429f97f61cc848

# Source package is packed with xz, so use xzcat to unpack
PKG_CAT:=xzcat

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/apt-cacher-ng
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+package_name +package_name_2
  TITLE:=A caching proxy for Debian-type packages
  MAINTAINER:=Gerad Munsch <gmunsch@unforgivendevelopment.com>
  URL:=http://www.unix-ag.uni-kl.de/~bloch/acng/
endef

define Package/apt-cacher-ng/description
    Apt-Cacher-NG is a caching proxy, specifically designed with Debian-style packages in mind.
endef

define Build/Configure
  # redefine to our config script?
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Package/apt-cacher-ng/install
        $(INSTALL_DIR) $(1)/usr/bin
        $(INSTALL_BIN) $(PKG_BUILD_DIR)/apt-cacher-ng/apt-cacher-ng $(1)/usr/bin/
endef

$(eval $(call BuildPackage,apt-cacher-ng))
