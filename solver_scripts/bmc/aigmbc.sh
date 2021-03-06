#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds aigbmc

# in case something goes wrong, notify!
set -ex

pushd build

build_aigbmc()
{
	pushd aiger

	# build picosat
	pushd picosat
	./configure.sh
	make -j $(nproc)
	popd

	# build lingeling
	pushd lingeling
	./configure.sh
	make -j $(nproc)
	popd

	# build aiger-1.9.9
	pushd aiger-1.9.9
	./configure.sh
	make aigbmc -j $(nproc) CFLAGS=-static
	cp aigbmc ../../aigbmc_glibc
	popd

	popd
}

# get aigbmc
get_aigbmc()
{
	if [ ! -d aiger ]
	then
		mkdir -p aiger
		pushd aiger

		# get actual aiger package
		wget http://fmv.jku.at/aiger/aiger-1.9.9.tar.gz
		tar xzf aiger-1.9.9.tar.gz
		rm -rf aiger-1.9.9.tar.gz

		# get SAT backends
		git clone https://github.com/arminbiere/lingeling.git  # we will use lingeling as SAT backend
		wget http://fmv.jku.at/picosat/picosat-965.tar.gz  # picosat is required to build successfully
		tar xzf picosat-965.tar.gz
		rm -f picosat-965.tar.gz
		ln -sf picosat-965 picosat
		popd
	fi
}

get_aigbmc
build_aigbmc
