#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2020
#
# This script builds glucose_421

# in case something goes wrong, notify!
set -ex

pushd build
build_glucose_421()
{
	pushd glucose-4.2.1
	cd sources/simp
	make rs -j $(nproc)
	file glucose_static
        chmod oug+rwx glucose_static
	cp glucose_static ../../../glucose-4.2.1_glibc
	popd
}

# get glucose_421 as one SAT solver to show case
get_glucose_421()
{
	if [ ! -d glucose-4.2.1 ]
	then
		wget http://sat-race-2019.ciirc.cvut.cz/solvers/glucose-4.2.1.zip
		unzip glucose-4.2.1.zip 
	fi
}

get_glucose_421
build_glucose_421
