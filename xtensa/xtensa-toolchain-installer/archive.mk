.PHONY: archive archive-sub archive-clean

$(CROSSTOOL_CONFIG).tbz2: $(CROSSTOOL_INSTALL_DIR)/build.log.bz2
	$(QECHO) TAR $@
	$(Q) tar cjf $@ -C $(dir $<) bin include lib libexec share $(CROSSTOOL_CONFIG)

archive: $(CROSSTOOL_CONFIG).tbz2

archive-sub:
	$(Q) $(MAKE) archive MAKELEVEL=0

archive-clean:
	$(Q) rm -f $(CROSSTOOL_CONFIG).tbz2

all: archive-sub
clean: archive-clean
