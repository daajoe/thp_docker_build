#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds mergesat

# in case something goes wrong, notify!
set -ex

pushd build
build_mergesat()
{
	pushd mergesat
	cd minisat/simp
	make rs -j $(nproc)
	file mergesat_static
        chmod oug+rwx mergesat_static
	cp mergesat_static ../../../mergesat_glibc
	popd
}

# get mergesat as one SAT solver to show case
get_mergesat()
{
	if [ ! -d mergesat ]
	then
		git clone https://github.com/conp-solutions/mergesat.git
	fi
}

get_mergesat
build_mergesat
