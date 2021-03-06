#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2020
#
# This script builds wasp

# in case something goes wrong, notify!
set -ex

pushd build
build_wasp()
{
	pushd wasp
	make static -j $(nproc)
	file build/release/wasp
        chmod oug+rwx build/release/wasp
	cp build/release/wasp ../wasp_glibc
	popd
}

# get wasp as one SAT/ASP solver to show case
get_wasp()
{
	if [ ! -d wasp ]
	then
		git clone https://github.com/alviano/wasp.git
	fi
}

get_wasp
build_wasp
