#targets
TARGETS:=

#subdirs
SUBDIRS = fpga
SUBDIRS_CLEAN = $(patsubst %,%.clean,$(SUBDIRS))

#rules
.PHONY: all
all: $(SUBDIRS) $(TARGETS)

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	cd $@ && $(MAKE)

.PHONY: $(SUBDIRS_CLEAN)
$(SUBDIRS_CLEAN):
	cd $(@:.clean=) && $(MAKE) clean

.PHONY: clean
clean: $(SUBDIRS_CLEAN)
	-rm .rf $(TARGETS)

