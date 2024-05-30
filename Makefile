#
# Copyright 2023-2024 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

RELEASE ?= 2024.02-1
EXTRA_RELEASE ?=
PREFIX ?= /srv/ftp

# All built architectures
# See https://toolchains.bootlin.com/toolchains.html
ifeq ($(ARCH),)
ARCH += aarch64
ARCH += aarch64be
ARCH += arcle-750d
ARCH += arcle-hs38
ARCH += armebv7-eabihf
ARCH += armv5-eabi
ARCH += armv6-eabihf
ARCH += armv7-eabihf
ARCH += armv7m
ARCH += bfin
ARCH += m68k-68xxx
ARCH += m68k-coldfire
ARCH += microblazebe
ARCH += microblazeel
ARCH += mips32
ARCH += mips32el
ARCH += mips32r5el
ARCH += mips32r6el
ARCH += mips64-n32
ARCH += mips64el-n32
ARCH += mips64r6el-n32
ARCH += nios2
ARCH += openrisc
ARCH += powerpc-440fp
ARCH += powerpc-e300c3
ARCH += powerpc-e500mc
ARCH += powerpc64-e5500
ARCH += powerpc64-e6500
ARCH += powerpc64-power8
ARCH += powerpc64le-power8
ARCH += riscv32-ilp32d
ARCH += riscv64-lp64d
ARCH += s390x-z13
ARCH += sh-sh4
ARCH += sh-sh4aeb
ARCH += sparc64
ARCH += sparcv8
ARCH += x86-64
ARCH += x86-64-core-i7
ARCH += x86-64-v2
ARCH += x86-64-v3
ARCH += x86-64-v4
ARCH += x86-core2
ARCH += x86-i686
ARCH += xtensa-lx60
endif

# Unbuilt libc/version variants
arcle-750d_glibc = 0
arcle-750d_musl = 0
arcle-hs38_musl = 0
armv7m_glibc = 0
armv7m_musl = 0
bfin = 0
m68k-coldfire_glibc = 0
m68k-coldfire_musl = 0
nios2_musl = 0
nios2_uclibc = 0
powerpc64-e5500_musl = 0
powerpc64-e5500_uclibc = 0
powerpc64-e6500_uclibc = 0
powerpc64-power8_uclibc = 0
powerpc64le-power8_uclibc = 0
powerpc64le-power8_uclibc = 0
riscv32-ilp32d_glibc_stable = 0
riscv32-ilp32d_uclibc = 0
s390x-z13_musl = 0
s390x-z13_uclibc = 0
sh-sh4aeb_uclibc = 0
sparc64_musl = 0
sparc64_uclibc = 0
sparcv8 = 0
xtensa-lx60_glibc = 0
xtensa-lx60_musl = 0

.PHONY: all
all:

.PHONY: repo
repo: bootlin-toolchains.db.tar.gz

.PRECIOUS: bootlin-toolchains.db.tar.gz
bootlin-toolchains.db.tar.gz:
	repo-add $@ $^

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(PREFIX)/archlinux/bootlin-toolchains/os/x86_64/
	cp -v *-x86_64.pkg.tar.zst $(DESTDIR)$(PREFIX)/archlinux/bootlin-toolchains/os/x86_64/
	cp -v bootlin-toolchains* $(DESTDIR)$(PREFIX)/archlinux/bootlin-toolchains/os/x86_64/

.PHONY: makepkg
makepkg:

.PHONY: log
log:

.PHONY: status
status:

.PHONY: commit
commit:

.PHONY: clean
clean:

.PHONY: cleanall
cleanall:

.PHONY: copy-source
copy-source:

.PHONY: rm-work
rm-work:

define PKGBUILD_in
ifneq ($($(1)),0)
ifneq ($($(1)_$(2)),0)
ifneq ($($(1)_$(2)_$(3)),0)
bootlin-toolchains.db.tar.gz: $(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst

.PRECIOUS: $(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst
$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst: $(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst
	cp -al $$< $$@

makepkg: $(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst

.PRECIOUS: $(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst
$(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst: $(1)-$(2)-$(3)-toolchain/hooks.install-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst: $(1)-$(2)-$(3)-toolchain/profile.sh-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst: $(1)-$(2)-$(3)-toolchain/PKGBUILD
	( cd $(1)-$(2)-$(3)-toolchain && makepkg --force --clean --cleanbuild )

log: log-$(1)-$(2)-$(3)

.PHONY: log-$(1)-$(2)-$(3)
log-$(1)-$(2)-$(3):
	( cd $(1)-$(2)-$(3)-toolchain && git log --patch -1 )

status: status-$(1)-$(2)-$(3)

.PHONY: status-$(1)-$(2)-$(3)
status-$(1)-$(2)-$(3):
	( cd $(1)-$(2)-$(3)-toolchain && git status --short )

commit: commit-$(1)-$(2)-$(3)

.PHONY: commit-$(1)-$(2)-$(3)
commit-$(1)-$(2)-$(3): $(1)-$(2)-$(3)-toolchain/.SRCINFO
commit-$(1)-$(2)-$(3): $(1)-$(2)-$(3)-toolchain/PKGBUILD 
commit-$(1)-$(2)-$(3): $(1)-$(2)-$(3)-toolchain/hooks.install-$(1)-$(2)-$(3)-toolchain
commit-$(1)-$(2)-$(3): $(1)-$(2)-$(3)-toolchain/profile.sh-$(1)-$(2)-$(3)-toolchain
	( cd $(1)-$(2)-$(3)-toolchain && git add $$(^F) && git commit -m "$$$${GIT_COMMIT_MESSAGE:-v$$(RELEASE)$$(EXTRA_RELEASE)}" )

.PRECIOUS: $(1)-$(2)-$(3)-toolchain/.SRCINFO
$(1)-$(2)-$(3)-toolchain/.SRCINFO: $(1)-$(2)-$(3)-toolchain/hooks.install-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/.SRCINFO: $(1)-$(2)-$(3)-toolchain/profile.sh-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/.SRCINFO: $(1)-$(2)-$(3)-toolchain/PKGBUILD
$(1)-$(2)-$(3)-toolchain/.SRCINFO: | $(1)-$(2)-$(3)-toolchain
	( cd $(1)-$(2)-$(3)-toolchain && makepkg --printsrcinfo >$$(@F) )

.PRECIOUS: $(1)-$(2)-$(3)-toolchain/PKGBUILD
$(1)-$(2)-$(3)-toolchain/PKGBUILD: PKGBUILD-$(1)-$(2)-$(3)-toolchain | $(1)-$(2)-$(3)-toolchain
	cp -alf $$< $$@

.PRECIOUS: $(1)-$(2)-$(3)-toolchain/hooks.install-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/hooks.install-$(1)-$(2)-$(3)-toolchain: hooks.install-$(1)-$(2)-$(3)-toolchain | $(1)-$(2)-$(3)-toolchain
	cp -alf $$< $$@

.PRECIOUS: $(1)-$(2)-$(3)-toolchain/profile.sh-$(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain/profile.sh-$(1)-$(2)-$(3)-toolchain: profile.sh-$(1)-$(2)-$(3)-toolchain | $(1)-$(2)-$(3)-toolchain
	cp -alf $$< $$@

.PRECIOUS: $(1)-$(2)-$(3)-toolchain
$(1)-$(2)-$(3)-toolchain:
	git init $$@

all: PKGBUILD-$(1)-$(2)-$(3)-toolchain

PKGBUILD-$(1)-$(2)-$(3)-toolchain: hooks.install-$(1)-$(2)-$(3)-toolchain
PKGBUILD-$(1)-$(2)-$(3)-toolchain: profile.sh-$(1)-$(2)-$(3)-toolchain
PKGBUILD-$(1)-$(2)-$(3)-toolchain: PKGBUILD.in
	sed -e 's,@@ARCH@@,$(1),g' \
	    -e 's,@@LIBC@@,$(2),g' \
	    -e 's,@@VERSION@@,$(3),g' \
	    -e 's,@@RELEASE@@,$$(RELEASE),g' \
	    -e 's,@@PACKAGE_VERSION@@,$$(word 1,$$(subst -, ,$$(RELEASE))),g' \
	    -e 's,@@PACKAGE_RELEASE@@,$$(word 2,$$(subst -, ,$$(RELEASE)))$$(EXTRA_RELEASE),g' \
	       $$< >$$@.tmp
	updpkgsums $$@.tmp
	mv $$@.tmp $$@

all: hooks.install-$(1)-$(2)-$(3)-toolchain

hooks.install-$(1)-$(2)-$(3)-toolchain: hooks.install.in
	sed -e 's,@@ARCH@@,$(1),g' \
	    -e 's,@@LIBC@@,$(2),g' \
	    -e 's,@@VERSION@@,$(3),g' \
	    -e 's,@@RELEASE@@,$$(RELEASE),g' \
	    -e 's,@@PACKAGE_VERSION@@,$$(word 1,$$(subst -, ,$$(RELEASE))),g' \
	    -e 's,@@PACKAGE_RELEASE@@,$$(word 2,$$(subst -, ,$$(RELEASE)))$$(EXTRA_RELEASE),g' \
	       $$< >$$@

all: profile.sh-$(1)-$(2)-$(3)-toolchain

profile.sh-$(1)-$(2)-$(3)-toolchain: profile.sh.in
	sed -e 's,@@ARCH@@,$(1),g' \
	    -e 's,@@LIBC@@,$(2),g' \
	    -e 's,@@VERSION@@,$(3),g' \
	    -e 's,@@RELEASE@@,$$(RELEASE),g' \
	    -e 's,@@PACKAGE_VERSION@@,$$(word 1,$$(subst -, ,$$(RELEASE))),g' \
	    -e 's,@@PACKAGE_RELEASE@@,$$(word 2,$$(subst -, ,$$(RELEASE)))$$(EXTRA_RELEASE),g' \
	       $$< >$$@

clean: clean-$(1)-$(2)-$(3)

.PHONY: clean-$(1)-$(2)-$(3)
clean-$(1)-$(2)-$(3):
	rm -f PKGBUILD-$(1)-$(2)-$(3)-toolchain
	rm -f hooks.install-$(1)-$(2)-$(3)-toolchain
	rm -f profile.sh-$(1)-$(2)-$(3)-toolchain

cleanall: cleanall-$(1)-$(2)-$(3)

.PHONY: cleanall-$(1)-$(2)-$(3)
cleanall-$(1)-$(2)-$(3):
	rm -f $(1)-$(2)-$(3)-toolchain/$(1)-$(2)-$(3)-toolchain-$$(RELEASE)$$(EXTRA_RELEASE)-x86_64.pkg.tar.zst

copy-source: copy-source-$(1)-$(2)-$(3)

.PHONY: copy-source-$(1)-$(2)-$(3)
copy-source-$(1)-$(2)-$(3):
	cp -al $(1)--$(2)--$(3)-$$(RELEASE).tar.bz2 $(1)-$(2)-$(3)-toolchain/

rm-work: rm-work-$(1)-$(2)-$(3)

.PHONY: rm-work-$(1)-$(2)-$(3)
rm-work-$(1)-$(2)-$(3):
	rm -Rf $(1)-$(2)-$(3)-toolchain/src $(1)-$(2)-$(3)-toolchain/pkg
endif
endif
endif
endef

define do_version
$(foreach version,stable bleeding-edge,$(eval $(call PKGBUILD_in,$(1),$(2),$(version))))
endef

define do_libc
$(foreach libc,glibc musl uclibc,$(eval $(call do_version,$(1),$(libc))))
endef

$(foreach arch,$(ARCH),$(eval $(call do_libc,$(arch))))
