# aur-bootlin-toolchains

[Bootlin] provides a large number of X86_64 Linux's [toolchains] targeting a
large number of architectures for the [glibc], [musl] and [uClibc-ng].

Unfortunatly, [Arch Linux] is very limited in offering cross compiler binary
packages.

aur-bootlin-toolchains is a repository to generate and maintain the `PKGBUILD`
files of the [toolchains] provided by [Bootlin] for the [AUR] repository.

_Note_: The toolchains exists in two versions (stable and bleeding edge), for
three libc's ([glibc], [musl] and [uClibc-ng]) and for not less 45 differents
architectures. There are 207 toolchains to maintain as of version 2023.08-1.
It is too many of them to spam the [AUR] repository with toolchains that would
be used by no more than 5 developers. Therefore, the more relevant pre-built
toolchains are going to be hosted on [AUR]; the others live somewhere on my
laptop. It is not decided yet if the stable or the bleeding edge versions and
which couples of libc/architecture will be pushed to [AUR].

## BUILD A TOOLCHAIN PACKAGE

First, fetch the sources:

	$ git clone git@github.com:gportay/aur-bootlin-toolchains.git

And go into the source tree:

	$ cd aur-bootlin-toolchains/

Then, make the package for your favourite toolchain (`aarch64-glibc-stable` for
example):

	$ makepkg -p PKGBUILD-aarch64-glibc-stable-toolchain
	==> Making package: aarch64-glibc-stable-toolchain 2023.08-1 (Tue 03 Oct 2023 03:53:32 AM CEST)
	==> Checking runtime dependencies...
	==> Checking buildtime dependencies...
	==> Retrieving sources...
	  -> Downloading aarch64--glibc--stable-2023.08-1.tar.bz2...
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  145M  100  145M    0     0  21.5M      0  0:00:06  0:00:06 --:--:-- 22.4M
	==> Validating source files with sha256sums...
	    aarch64--glibc--stable-2023.08-1.tar.bz2 ... Passed
	    profile.sh-aarch64-glibc-stable-toolchain ... Passed
	==> Extracting sources...
	  -> Extracting aarch64--glibc--stable-2023.08-1.tar.bz2 with bsdtar
	==> Starting build()...
	Relocating the buildroot SDK from /builds/buildroot.org/toolchains-builder/build/aarch64--glibc--stable-2023.08-1 to /opt/aarch64-glibc-stable ...
	==> Entering fakeroot environment...
	==> Starting package()...
	==> Tidying install...
	  -> Removing libtool files...
	  -> Purging unwanted files...
	  -> Removing static library files...
	  -> Compressing man and info pages...
	==> Checking for packaging issues...
	==> Creating package "aarch64-glibc-stable-toolchain"...
	  -> Generating .PKGINFO file...
	  -> Generating .BUILDINFO file...
	  -> Adding install file...
	  -> Generating .MTREE file...
	  -> Compressing package...
	==> Leaving fakeroot environment.
	==> Finished making: aarch64-glibc-stable-toolchain 2023.08-1 (Tue 03 Oct 2023 03:53:56 AM CEST)

Finally, install the toolchain:

	$ sudo pacman -U aarch64-glibc-stable-toolchain-2023.08-1-x86_64.pkg.tar.zst
	[sudo] password for gportay: 
	loading packages...
	resolving dependencies...
	looking for conflicting packages...
	
	Packages (1) aarch64-glibc-stable-toolchain-2023.08-1
	
	Total Installed Size:  469.47 MiB
	
	:: Proceed with installation? [Y/n] y
	(1/1) checking keys in keyring                                                           [###################################################] 100%
	(1/1) checking package integrity                                                         [###################################################] 100%
	(1/1) loading package files                                                              [###################################################] 100%
	(1/1) checking for file conflicts                                                        [###################################################] 100%
	(1/1) checking available disk space                                                      [###################################################] 100%
	:: Processing package changes...
	(1/1) installing aarch64-glibc-stable-toolchain                                          [###################################################] 100%	
	bootlin toolchain installed to /opt/aarch64-glibc-stable
	The PATH variable will be updated on re-login. To immediately load it:
	
		source /etc/profile.d/aarch64-glibc-stable-toolchain.sh

_Important_: Re-login to your user session, or source the profile script in
every terminal to run the toolchain binaries without its absolute path:

	$ source /etc/profile.d/aarch64-glibc-stable-toolchain.sh

Run the compiler:

	$ aarch64-buildroot-linux-gnu-gcc --version
	aarch64-buildroot-linux-gnu-gcc.br_real (Buildroot 2021.11-8547-g7e65a1a) 12.3.0
	Copyright (C) 2022 Free Software Foundation, Inc.
	This is free software; see the source for copying conditions.  There is NO
	warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## BUMP

First, update `RELEASE` to the new release, reset `EXTRA_RELEASE` to empty, and
`touch *.in` files.

Then, update `ARCH` list of architecture to add (or remove) new toolchains, and
eventually set `<arch>_<libc>` or `<arch>_<libc>_<version>` to `0` to disable
variant if it is part of the new release.

Finally, add the changes `git add PKGBUILD-* hooks.install-* profile.sh-*`,
commit them `git commit -m "Bump 2023.11"` and tag it `git tag "v2023.11-1"`.

## CREATE AND MAINTAIN AUR

Before doing anything else, the existing [AUR] repositories are submodules and
they **SHOULD** be cloned:

	$ git submodule update --init

After a bump, run:

	$ make commit

Note: The git repository is created locally if it does not exist yet and it is
not an existing [AUR] repository.

Eventually, make the packages:

	$ make makepkg

Or, for [AUR] packages only:

	$ git submodule foreach makepkg --force --clean --cleanbuild

In the very end, push the changes to [AUR]:

	$ git submodule foreach git push

And commit the submodules changes:

	$ git commit -m "Update submodules"

## BUGS

Report bugs at *https://github.com/gportay/aur-bootlin-toolchains/issues*

# AUTHOR

Written by Gaël PORTAY *gael.portay@gmail.com*

## COPYRIGHT

Copyright (c) 2023-2024 Gaël PORTAY

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation, either version 2.1 of the License, or (at your option) any
later version.

[AUR]: https://aur.archlinux.org/
[Arch Linux]: https://archlinux.org/
[Bootlin]: https://bootlin.com/
[glibc]: https://www.gnu.org/software/libc/
[musl]: https://www.musl-libc.org/
[toolchains]: https://toolchains.bootlin.com/
[uClibc-ng]: https://uclibc-ng.org/
