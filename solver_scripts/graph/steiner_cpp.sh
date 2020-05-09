#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds clasp

# in case something goes wrong, notify!
set -ex

pushd build
build_steiner()
{
	pushd steiner_cpp
	cmake -H. -Bbuild -DSTEINER_BUILD_STATIC=ON
	cmake --build build
	file build/steiner
        chmod oug+rwx build/steiner
	cp build/steiner ../steiner_glibc
	popd
}

# get clasp as one SAT solver to show case
get_steiner()
{
	if [ ! -d steiner_cpp ]
	then
		git clone git@github.com:ASchidler/steiner_cpp.git
	fi
}

get_steiner
build_steiner
