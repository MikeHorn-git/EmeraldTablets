# --------------------
# Variables
# --------------------

AWK        := awk
AWK_SRC    := tablet.awk

CC         := gcc
CFLAGS     := -Wall -Werror=format-security -Wcast-align -Wcast-qual -Wconversion \
			  -Wextra -Wformat=2 -Wfloat-equal -Wimplicit-fallthrough -Winit-self \
              -Wpointer-arith -Wredundant-decls -Wshadow -Wstrict-aliasing        \
              -Wstrict-prototypes -Wswitch-enum  -Wundef -O2        \
              -ftrivial-auto-var-init=zero -fstack-clash-protection \
              -fstrict-flex-arrays=3 -fstack-protector-strong       \
              -D_FORTIFY_SOURCE=3 -D_GLIBCXX_ASSERTIONS \

LDFLAGS    := -pie -fPIE -Wl,-z,nodlopen -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now \
              -Wl,--as-needed -Wl,--no-copy-dt-needed-entries

SRC        := tablet.c
TARGET := $(basename $(notdir $(SRC)))
SRC_DIR    := src
INC_DIR    := $(SRC_DIR)/include
CFLAGS     += -I$(SRC_DIR) -I$(INC_DIR)

TBL_FILES  := $(wildcard tbl/*/*.tbl)
TABLE_HDRS := $(patsubst tbl/%/%.tbl,$(SRC_DIR)/%/%.h,$(TBL_FILES))
ARCHES     := $(sort $(notdir $(wildcard tbl/*)))

ARCH ?= x86_64

# --------------------
# Help Menu
# --------------------

.DEFAULT_GOAL := help

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@printf "  %-15s %s\n" "help"  "Show this help message"
	@printf "  %-15s %s\n" "all"   "Builds all headers"
	@printf "  %-15s %s\n" "$(TARGET)" "Build $(TARGET) sample"
	@for a in $(ARCHES); do \
	  printf "  %-15s %s\n" "$$a" "Build only $$a headers"; \
	done
	@printf "  %-15s %s\n" "clean" "Delete generated headers"

# --------------------
# Phony targets
# --------------------

.PHONY: help all $(ARCHES) tablet clean test

all: $(ARCHES)

# --------------------
# Header generation
# --------------------

$(ARCHES):
	@echo "Generating headers for $@"
	@for tbl in $(wildcard tbl/$@/*.tbl); do \
	   name=$$(basename $$tbl .tbl); \
	   hdr=$(SRC_DIR)/$@/$$name.h; \
	   mkdir -p $$(dirname $$hdr); \
	   echo "  $$hdr"; \
	   $(AWK) -f $(AWK_SRC) $$tbl > $$hdr; \
	done

# --------------------
# Build tablet
# --------------------

# Set architecture macro
ifeq ($(ARCH),arm)
  ARCH_FLAG := -D TARGET_ARCH_ARM
endif
ifeq ($(ARCH),arm64_32)
  ARCH_FLAG := -D TARGET_ARCH_ARM64_32
endif
ifeq ($(ARCH),arm64_64)
  ARCH_FLAG := -D TARGET_ARCH_ARM64_64
  CFLAGS += -mbranch-protection=standard
endif
ifeq ($(ARCH),x86_32)
  ARCH_FLAG := -D TARGET_ARCH_X86_32
endif
ifeq ($(ARCH),x86_64)
  ARCH_FLAG := -D TARGET_ARCH_X86_64
  CFLAGS += -fcf-protection=full
endif
ifeq ($(ARCH),)
  $(error ARCH is not set! Default is x86_64. Use: make tablet ARCH=<arch>)
endif

tablet: $(SRC) $(TABLE_HDRS)
	$(CC) $(CFLAGS) $(ARCH_FLAG) $(LDFLAGS) -o $@ $<
	strip $@

# --------------------
# Clean generated headers
# --------------------

clean:
	find $(SRC_DIR) -type f -name '*.h' ! -path '$(INC_DIR)/syscall.h' -delete
