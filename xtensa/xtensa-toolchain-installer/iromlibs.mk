.PHONY: iromlibs iromlibs-sub libcirom libmirom

CROSSLIB_DIR := $(CROSSTOOL_INSTALL_DIR)/$(CROSSTOOL_CONFIG)/sysroot/lib
CROSSTOOL_OC := $(CROSSTOOL_INSTALL_DIR)/bin/$(CROSSTOOL_CONFIG)-objcopy

$(CROSSLIB_DIR)/%irom.a: $(CROSSLIB_DIR)/%.a
	$(QECHO) OC $(notdir $@)
	$(Q) $(CROSSTOOL_OC) --rename-section .text=.irom0.text --rename-section .literal=.irom0.literal $< $@

libcirom: $(CROSSLIB_DIR)/libcirom.a
libmirom: $(CROSSLIB_DIR)/libmirom.a

iromlibs: libcirom libmirom

iromlibs-sub:
	@ $(MAKE) iromlibs MAKELEVEL=0

ifeq ($(TARGET),lx106)
all: iromlibs-sub
endif
