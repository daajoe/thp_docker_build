#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds clasp

# in case something goes wrong, notify!
set -ex

pushd build
build_clasp()
{
	pushd clasp
	cmake -H. -Bbuild -DCLASP_BUILD_STATIC=ON
	cmake --build build
	file build/bin/clasp
        chmod oug+rwx build/bin/clasp
	cp build/bin/clasp ../clasp_glibc
	popd
}

# get clasp as one SAT solver to show case
get_clasp()
{
	if [ ! -d clasp ]
	then
		git clone https://github.com/potassco/clasp.git
	fi
}

get_clasp
build_clasp
