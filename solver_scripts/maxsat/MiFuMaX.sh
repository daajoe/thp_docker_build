#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds MaxHS

# in case something goes wrong, notify!
set -ex

pushd build
build_mifumax()
{
    pushd mifumax-0.9
    make clean
    make STATIC=TRUE
    file mifumax
    chmod oug+rwx mifumax
    cp mifumax ../mifumax_glibc
    popd
}

# get minisat as one SAT solver to show case
get_mifumax()
{
    if [ ! -d maxhs ]
    then
	wget http://sat.inesc-id.pt/~mikolas/sw/mifumax/mifumax-0.9.tgz
	tar xf mifumax-0.9.tgz
	rm mifumax-0.9.tgz
    fi
}

get_mifumax
build_mifumax
