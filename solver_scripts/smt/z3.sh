#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds z3

# in case something goes wrong, notify!
set -ex

pushd build
build_z3()
{
	# build z3, using modified compiler
	pushd z3
	python scripts/mk_make.py --staticbin CXX=g++
	cd build/
	make -j $(nproc)
	file z3
        chmod oug+rwx z3
	cp z3 ../../z3_glibc
	popd
}

# get z3
get_z3()
{
	if [ ! -d z3 ]
	then
		git clone https://github.com/Z3Prover/z3.git
	fi
}

get_z3
build_z3
