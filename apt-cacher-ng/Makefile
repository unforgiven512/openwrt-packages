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
# adduser ?

define Package/apt-cacher-ng
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  MDEPENDS:=@USE_UCLIBC
  DEPENDS:=+bzip2 +zlib
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
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/apt-cacher-ng $(1)/usr/sbin/apt-cacher-ng
	$(INSTALL_DIR) $(1)/etc/apt-cacher-ng
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/acng.conf $(1)/etc/apt-cacher-ng/acng.conf
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/security.conf $(1)/etc/apt-cacher-ng/security.conf
	$(INSTALL_DIR) $(1)/usr/lib/apt-cacher-ng
	$(CP) $(PKG_BUILD_DIR)/conf/archlx_mirrors $(1)/usr/lib/apt-cacher-ng/archlx_mirrors
	$(CP) $(PKG_BUILD_DIR)/conf/cygwin_mirrors $(1)/usr/lib/apt-cacher-ng/cygwin_mirrors
	$(CP) $(PKG_BUILD_DIR)/conf/deb_mirrors.gz $(1)/usr/lib/apt-cacher-ng/deb_mirrors.gz
	$(CP) $(PKG_BUILD_DIR)/conf/debvol_mirrors.gz $(1)/usr/lib/apt-cacher-ng/debvol_mirrors.gz
	$(CP) $(PKG_BUILD_DIR)/conf/delconfirm.html $(1)/usr/lib/apt-cacher-ng/delconfirm.html
	$(CP) $(PKG_BUILD_DIR)/distkill.pk $(1)/usr/lib/apt-cacher-ng/distkill.pl
	$(CP) $(PKG_BUILD_DIR)/conf/epel_mirrors $(1)/usr/lib/apt-cacher-ng/epel_mirrors
	$(CP) $(PKG_BUILD_DIR)/expire-caller.pl $(1)/usr/lib/apt-cacher-ng/expire-caller.pl
	$(CP) $(PKG_BUILD_DIR)/conf/fedora_mirrors $(1)/usr/lib/apt-cacher-ng/fedora_mirrors
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/in.acng $(1)/usr/lib/apt-cacher-ng/in.acng
	$(CP) $(PKG_BUILD_DIR)/conf/maint.html $(1)/usr/lib/apt-cacher-ng/maint.html
	$(CP) $(PKG_BUILD_DIR)/conf/report.html $(1)/usr/lib/apt-cacher-ng/report.html
	$(CP) $(PKG_BUILD_DIR)/conf/sfnet_mirrors $(1)/usr/lib/apt-cacher-ng/sfnet_mirrors
	$(CP) $(PKG_BUILD_DIR)/conf/sl_mirrors $(1)/usr/lib/apt-cacher-ng/sl_mirrors
	$(CP) $(PKG_BUILD_DIR)/conf/style.css $(1)/usr/lib/apt-cacher-ng/style.css
	$(CP) $(PKG_BUILD_DIR)/conf/ubuntu_mirrors $(1)/usr/lib/apt-cacher-ng/ubuntu_mirrors
	$(CP) $(PKG_BUILD_DIR)/urlencode-fixer.pl $(1)/usr/lib/apt-cacher-ng/urlencode-fixer.pl
	$(CP) $(PKG_BUILD_DIR)/conf/userinfo.html $(1)/usr/lib/apt-cacher-ng/userinfo.html
endef

define Package/apt-cacher-ng/conffiles
/etc/apt-cacher-ng/acng.conf
/etc/apt-cacher-ng/security.conf
endef

define Package/apt-cacher-ng/postinst
#!/bin/sh

    # ADDUSER "apt-cacher-ng" --quiet --system --group --no-create-home --home /var/cache/apt-cacher-ng

    ## This may be moved to the init script, for the fact that /var/ is currently a volatile directory
    ## Perhaps we can add a way to detect if /var/ is volatile or not?
    ## Also, $CDIR may need moved to non-volatile storage?
    # CDIR=/var/cache/apt-cacher-ng
    # LDIR=/var/log/apt-cacher-ng
    # for x in $CDIR $LDIR ; do
    #   if [ ! -d "$x" ]; then
    #     mkdir -p "$x"
    #     chown apt-cacher-ng:apt-cacher-ng "$x"
    #     chmod 2755 "$x"
    #   fi
    # done

    # perhaps we should test for ownership and file mode (apt-cacher-ng:apt-cacher-ng; 0600)
    chown apt-cacher-ng:apt-cacher-ng /etc/apt-cacher-ng/security.conf
    chmod 0600 /etc/apt-cacher-ng/security.conf

endef

define Package/apt-cacher-ng/postrm
#!/bin/sh
endef

$(eval $(call BuildPackage,apt-cacher-ng))
