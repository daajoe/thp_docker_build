#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds open-wbo

# in case something goes wrong, notify!
set -ex

pushd build
build_open-wbo()
{
	pushd open-wbo
	make clean
	make rs -j 4
	file open-wbo_static
        chmod oug+rwx open-wbo_static
	cp open-wbo_static ../open-wbo_static_glibc
	popd
}

# get open-wbo
get_open-wbo()
{
	if [ ! -d open-wbo ]
	then
		git clone https://github.com/sat-group/open-wbo.git
	fi
}

get_open-wbo
build_open-wbo
