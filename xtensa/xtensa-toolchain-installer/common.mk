VERBOSE ?= $(V)
ifeq ($(filter $(VERBOSE),1 y yes true),)
	Q := @
	QECHO := @ echo
else
	Q := 
	QECHO := @ true
endif

TARGET ?= lx106
ifeq ($(filter $(TARGET),lx106 esp32),)
$(error Target $(TARGET) not supported (use one of: lx106 esp32))
endif
