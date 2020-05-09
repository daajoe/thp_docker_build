#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds MiniSat

# in case something goes wrong, notify!
set -ex

pushd build
build_minisat()
{
	pushd minisat
	make clean
	make r -j 4 RELEASE_LDFLAGS=-static
	file build/release/bin/minisat
        chmod oug+rwx build/release/bin/minisat
	cp build/release/bin/minisat ../minisat_glibc
	popd
}

# get minisat as one SAT solver to show case
get_minisat()
{
	if [ ! -d minisat ]
	then
		git clone https://github.com/niklasso/minisat.git
	fi
}

get_minisat
build_minisat
