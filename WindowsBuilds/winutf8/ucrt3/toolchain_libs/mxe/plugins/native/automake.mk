# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := automake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.2
$(PKG)_CHECKSUM := b2f361094b410b4acbf4efba7337bdb786335ca09eb2518635a09fb7319ca5c1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/automake/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/automake/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/automake
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := autoconf

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/automake/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="automake-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
