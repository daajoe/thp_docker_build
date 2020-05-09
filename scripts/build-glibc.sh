#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# Build glibc

# in case something goes wrong, notify!
set -ex

pushd build
build_glibc()
{
	# build mergesat
	pushd glibc
	mkdir -p build
	cd build
	../configure --host=x86_64-linux-gnu --prefix=/usr/lib/x86_64-linux-gnu --libdir=/usr/lib/x86_64-linux-gnu --enable-add-ons=libidn,"" --without-selinux --enable-stackguard-randomization --enable-obsolete-rpc --with-pkgversion="Ubuntu GLIBC 2.23-0ubuntu11-thp" --enable-kernel=2.6.32 --enable-systemtap --enable-multi-arch
#	../configure --host=x86_64-linux-gnu --prefix=/usr/lib/x86_64-linux-gnu --enable-add-ons=libidn,"" --without-selinux --enable-stackguard-randomization --enable-obsolete-rpc --with-pkgversion="Ubuntu GLIBC 2.23-0ubuntu11-thp" --enable-kernel=2.6.32 --enable-systemtap --enable-multi-arch
	make -j $(nproc)
	popd
}

build_glibc
