# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.26.0
$(PKG)_CHECKSUM := f38367892a6f243e8b4010e9e3d9714dc848e11b1a3f69c4af514dc6e7aca7f0
$(PKG)_GH_CONF  := libsdl-org/SDL/releases/tag,release-,,
$(PKG)_DEPS     := cc libiconv libsamplerate

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I acinclude && autoconf && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --enable-directx \
        --enable-libsamplerate \
        --enable-libsamplerate-shared=$(if $(BUILD_SHARED),yes,no)
    $(SED) -i 's,defined(__MINGW64_VERSION_MAJOR),defined(__MINGW64_VERSION_MAJOR) \&\& defined(_WIN64),' '$(1)/include/SDL_cpuinfo.h'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j 1 install SHELL=$(SHELL)
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2.exe' \
        `'$(TARGET)-pkg-config' sdl2 --cflags --libs`

endef
