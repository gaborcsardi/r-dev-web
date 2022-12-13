# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libarchive
$(PKG)_WEBSITE  := https://www.libarchive.org/
$(PKG)_DESCR    := Libarchive
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.1
$(PKG)_CHECKSUM := c676146577d989189940f1959d9e3980d28513d74eedfbc6b7f15ea45fe54ee2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libarchive.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 libiconv libxml2 nettle openssl xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.libarchive.org/downloads/' | \
    $(SED) -n 's,.*libarchive-\([0-9][^<]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # use nettle instead of bcrypt for CNG(Crypto Next Generation)
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-bsdtar \
        --disable-bsdcpio \
        --disable-bsdcat \
        --without-cng \
        --with-nettle \
        XML2_CONFIG='$(PREFIX)/$(TARGET)'/bin/xml2-config
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' man_MANS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libarchive.exe' \
        `'$(TARGET)-pkg-config' --libs-only-l --cflags libarchive`
endef
