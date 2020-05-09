#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
# Modified Johannes Fichte, TU Dresden, 2020
#
# This script prepares the directory to build a MiniSat based PoC

# in case something goes wrong, notify!
#set -xe

# get glibc upstream, and jump to tag 2.23, in case it's not there already
if [ ! -d glibc ] ; then
    echo "  Downloading glibc..."
    git clone git://sourceware.org/git/glibc.git || exit 1
    pushd glibc/
    git checkout glibc-2.23 || exit 1
    popd
else
    echo "  glibc found at $(pwd)/glibc."
fi

if [ ! -f glibc/thp_patched ] ; then
    pushd glibc
    echo "  Applying patches..."
    # apply patches in order
    for p in $(ls ../../thp/ubuntu16.04-thp-env-2.23/*.patch | sort -V)
    do
	echo "  Patching $p"
	git apply "$p" || (echo "Patch not applicable" && exit 1)
    done
    touch thp_patched
    
    popd
    echo "  Done."
    exit 10
else
    echo "  Already patched. Remove build/thp_patched if you need to apply it again."
    exit 20
fi
