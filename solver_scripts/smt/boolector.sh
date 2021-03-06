#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds Boolector

# In case something goes wrong, notify!
set -ex

pushd build
build_boolector()
{
	pushd boolector

	# clean
	rm -rf build/*

	# get tools required to build boolector
	./contrib/setup-lingeling.sh
	./contrib/setup-cadical.sh
	./contrib/setup-btor2tools.sh

	# configure
	"$ONE_LINE_SCAN" -j $(nproc) \
		--extra-cflags -static \
		--no-gotocc \
		--plain -o PLAIN --use-existing -- \
		./configure.sh

	# build
	cd build
	"$ONE_LINE_SCAN" -j $(nproc) \
		--extra-cflags -static \
		--no-gotocc \
		--plain -o PLAIN --use-existing -- \
		make -j $(nproc)

	popd
}

# get minisat as one SAT solver to show case
get_boolector()
{
	if [ ! -d boolector ]
	then
		git clone https://github.com/Boolector/boolector.git
	fi
}

# get one line scan
[ -d one-line-scan ] || git clone https://github.com/awslabs/one-line-scan.git
ONE_LINE_SCAN=$(readlink -e one-line-scan/one-line-scan)

get_boolector
build_boolector
