.PHONY: crosstool crosstool-clean crosstool-sub

CROSSTOOL_DIR := $(abspath .crosstool)
CROSSTOOL_PATCH_MFORCE_L32_PATH := $(CROSSTOOL_DIR)/local-patches/gcc/4.8.5/1000-mforce-l32.patch
CROSSTOOL_CONFIG := xtensa-$(TARGET)-elf
CROSSTOOL_INSTALL_DIR := $(CROSSTOOL_DIR)/builds/$(CROSSTOOL_CONFIG)
CROSSTOOL_REPO := https://github.com/espressif/crosstool-NG.git
CROSSTOOL_BRANCH := xtensa-1.22.x

$(CROSSTOOL_DIR)/.cloned:
	$(QECHO) GIT clone crosstool
	$(Q) git clone --single-branch -b $(CROSSTOOL_BRANCH) $(CROSSTOOL_REPO) $(CROSSTOOL_DIR)
	$(Q) git config -f $(CROSSTOOL_DIR)/.git/config core.abbrev 7
	$(Q) touch $@

$(CROSSTOOL_DIR)/configure: $(CROSSTOOL_DIR)/.cloned
	$(QECHO) BOOTSTRAP ct-ng
	$(Q) cd $(CROSSTOOL_DIR); ./bootstrap

$(CROSSTOOL_DIR)/.patched: $(CROSSTOOL_DIR)/configure
	$(QECHO) PATCH crosstool
	$(Q) cd $(CROSSTOOL_DIR); patch -p 1 -f -i ../crosstool.patch -d $(CROSSTOOL_DIR) || true
	$(Q) touch $@

$(CROSSTOOL_DIR)/ct-ng: $(CROSSTOOL_DIR)/.patched
	$(QECHO) BUILD ct-ng
	$(Q) cd $(CROSSTOOL_DIR); ./configure --prefix=`pwd`
	$(Q) $(MAKE) -C $(CROSSTOOL_DIR) clean install MAKELEVEL=0

CROSSTOOL_CONFFILE := $(CROSSTOOL_DIR)/.config
$(CROSSTOOL_CONFFILE).$(CROSSTOOL_CONFIG): $(CROSSTOOL_DIR)/ct-ng
	$(QECHO) CONFIG crosstool
	$(Q) rm -f $(CROSSTOOL_CONFFILE)*
	$(Q) cd $(CROSSTOOL_DIR); ./ct-ng $(CROSSTOOL_CONFIG)
	$(Q) mv $(CROSSTOOL_CONFFILE) $(CROSSTOOL_CONFFILE).tmp; sed -e 's%^CT_INSTALL_DIR_RO=.*$$%CT_INSTALL_DIR_RO=n%g' $(CROSSTOOL_CONFFILE).tmp > $(CROSSTOOL_CONFFILE)
	$(Q) mv $(CROSSTOOL_CONFFILE) $(CROSSTOOL_CONFFILE).tmp; sed -e 's%^CT_GDB_CROSS_EXTRA_CONFIG_ARRAY=.*$$%CT_GDB_CROSS_EXTRA_CONFIG_ARRAY="--disable-tui"%g' $(CROSSTOOL_CONFFILE).tmp > $(CROSSTOOL_CONFFILE)
	$(Q) mv $(CROSSTOOL_CONFFILE) $(CROSSTOOL_CONFFILE).tmp; sed -e 's%^# CT_LIBC_NEWLIB_IO_FLOAT is not set$$%CT_LIBC_NEWLIB_IO_FLOAT=y%g' $(CROSSTOOL_CONFFILE).tmp > $(CROSSTOOL_CONFFILE)
	$(Q) rm $(CROSSTOOL_CONFFILE).tmp
	$(Q) touch $@

$(CROSSTOOL_PATCH_MFORCE_L32_PATH): $(notdir $(CROSSTOOL_PATCH_MFORCE_L32_PATH))
	$(QECHO) PATCH toolchain-mforce-l32
	$(Q) cp $< $@

$(CROSSTOOL_INSTALL_DIR)/build.log.bz2: $(CROSSTOOL_CONFFILE).$(CROSSTOOL_CONFIG) $(CROSSTOOL_PATCH_MFORCE_L32_PATH)
	$(QECHO) BUILD toolchain
	$(Q) cd $(CROSSTOOL_DIR); ./ct-ng build MAKELEVEL=0

crosstool: $(CROSSTOOL_INSTALL_DIR)/build.log.bz2

crosstool-clean:
	$(Q) rm -rf $(CROSSTOOL_DIR)

crosstool-sub:
	$(Q) $(MAKE) crosstool MAKELEVEL=0

all: crosstool-sub
clean: crosstool-clean
