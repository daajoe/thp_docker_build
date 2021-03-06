#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2020
#
# This script builds MapleLCMDiscChronoBT-DL-v3, winner of the SAT Race 2019

# in case something goes wrong, notify!
set -ex

pushd build
build_MapleLCMDiscChronoBT_DL_v3()
{
	pushd MapleLCMDiscChronoBT-DL-v3
	cd sources/simp
	make rs -j $(nproc)
	file glucose_static
        chmod oug+rwx glucose_static
	cp glucose_static ../../../MapleLCMDiscChronoBT-DL-v3_glibc
	popd
}

# get MapleLCMDiscChronoBT-DL-v3 as one SAT solver to show case
get_MapleLCMDiscChronoBT_DL_v3()
{
	if [ ! -d MapleLCMDiscChronoBT-DL-v3 ]
	then
		wget http://sat-race-2019.ciirc.cvut.cz/solvers/MapleLCMDiscChronoBT-DL-v3.zip
		unzip MapleLCMDiscChronoBT-DL-v3.zip
	fi
}

get_MapleLCMDiscChronoBT_DL_v3
build_MapleLCMDiscChronoBT_DL_v3
