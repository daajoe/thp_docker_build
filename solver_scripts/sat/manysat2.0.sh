#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds manysat2.0

# in case something goes wrong, notify!
set -ex

pushd build
build_manysat()
{
	pushd manysat2.0
	export MROOT=$(pwd)
	cd core
	make rs -j $(nproc)
	file manysat2.0_static
        chmod oug+rwx manysat2.0_static
	cp manysat2.0_static ../../manysat2.0_glibc
	popd
}

# get manysat as a parallel SAT solver to show case
get_manysat()
{
	if [ ! -d manysat2.0 ]
	then
		wget http://www.cril.univ-artois.fr/~jabbour/manysat2.0.zip
		unzip manysat2.0.zip
		rm manysat2.0.zip
	fi
}

get_manysat
build_manysat
