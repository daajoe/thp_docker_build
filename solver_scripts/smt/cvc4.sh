#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds CVC4

# in case something goes wrong, notify!
set -ex

pushd build
build_CVC4()
{
	pushd CVC4

	# build statically linked CVC4, with ABC circuit tool and cadical SAT solver
#	./contrib/get-antlr-3.4
#	./contrib/get-abc
#	./contrib/get-cadical
#	./configure.sh --static --cadical --abc

	cd build
	make -j $(nproc)
	file bin/cvc4
	chmod oug+rwx bin/cvc4
	cp bin/cvc4 ../../cvc4_glibc
	popd
}

# get CVC4 as one SAT solver to show case
get_CVC4()
{
	if [ ! -d CVC4 ]
	then
		git clone https://github.com/CVC4/CVC4.git
	fi
}

get_CVC4
build_CVC4
