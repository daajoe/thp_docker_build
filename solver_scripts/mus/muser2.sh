#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds muser2

# in case something goes wrong, notify!
set -ex


pushd build
build_muser2()
{
	pushd muser2
	cd ./src/tools/muser2
	make -j 4
	file muser2
        chmod oug+rwx muser2
	cp muser2 ../../../../muser2_glibc
	popd
}

# get muser2
get_muser2()
{
	if [ ! -d muser2 ]
	then
		git clone https://bitbucket.org/anton_belov/muser2.git
	fi
}

get_muser2
build_muser2
