#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds MaxHS

# in case something goes wrong, notify!
set -ex

pushd build
build_maxhs()
{
    pushd MaxHS
    make clean
    make
    file maxhs
    chmod oug+rwx maxhs
    cp maxhs ../maxhs_glibc
    popd
}

# get minisat as one SAT solver to show case
get_maxhs()
{
    if [ ! -d maxhs ]
    then
	git clone https://github.com/fbacchus/MaxHS.git
    fi
}

get_maxhs
build_maxhs
