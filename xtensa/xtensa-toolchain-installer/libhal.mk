.PHONY: libhal libhal-sub libhal-clean

LIBHAL_DIR := $(abspath .libhal)
LIBHAL_REPO := https://github.com/tommie/lx106-hal.git

CROSSLIB_DIR := $(CROSSTOOL_INSTALL_DIR)/$(CROSSTOOL_CONFIG)/sysroot/lib
CROSSINC_DIR := $(CROSSTOOL_INSTALL_DIR)/$(CROSSTOOL_CONFIG)/sysroot/usr/include
CROSSBIN_PRF := $(CROSSTOOL_INSTALL_DIR)/bin/$(CROSSTOOL_CONFIG)-

$(LIBHAL_DIR)/.cloned:
	$(QECHO) GIT clone libhal
	$(Q) git clone $(LIBHAL_REPO) $(LIBHAL_DIR)
	$(Q) touch $@

$(LIBHAL_DIR)/configure: $(LIBHAL_DIR)/.cloned
	$(QECHO) ARC libhal
	$(Q) cd $(LIBHAL_DIR); autoreconf -i

$(LIBHAL_DIR)/Makefile: $(LIBHAL_DIR)/configure
	$(QECHO) CONFIG libhal
	$(Q) cd $(LIBHAL_DIR); ./configure --host=xtensa-lx106-elf --prefix=`pwd` \
	  CC=$(CROSSBIN_PRF)gcc AR=$(CROSSBIN_PRF)ar LD=$(CROSSBIN_PRF)ld RANLIB=$(CROSSBIN_PRF)ranlib

$(LIBHAL_DIR)/src/libhal.a: $(LIBHAL_DIR)/Makefile
	$(QECHO) MAKE libhal
	$(Q) $(MAKE) -C $(LIBHAL_DIR) MAKELEVEL=0

$(CROSSLIB_DIR)/libhal.a: $(LIBHAL_DIR)/src/libhal.a
	$(QECHO) COPYLIB libhal
	$(Q) cp $< $@

$(CROSSINC_DIR)/xtensa/hal.h:
	$(QECHO) COPYINC libhal
	$(Q) cp -r $(LIBHAL_DIR)/include/xtensa/*.h $(LIBHAL_DIR)/include/xtensa/config $(CROSSINC_DIR)/xtensa

libhal: $(CROSSLIB_DIR)/libhal.a $(CROSSINC_DIR)/xtensa/hal.h

libhal-clean:
	$(Q) rm -rf $(LIBHAL_DIR)

libhal-sub:
	$(Q) $(MAKE) libhal MAKELEVEL=0

ifeq ($(TARGET),lx106)
all: libhal-sub
endif
clean: libhal-clean
