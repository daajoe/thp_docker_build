#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds MaxHS

# in case something goes wrong, notify!
set -ex


pushd build
build_picosat()
{
    pushd picosat-965
    ./configure.sh -static
    make clean
    ./configure.sh -static
    make
    file picomus
    chmod oug+rwx picomus
    cp picomus ../picomus_glibc
    file picosat
    chmod oug+rwx picosat
    cp picosat ../picosat_glibc
    popd
}

# get minisat as one SAT solver to show case
get_picosat()
{
    if [ ! -d picosat ]
    then
	wget http://fmv.jku.at/picosat/picosat-965.tar.gz
	tar xf picosat-965.tar.gz
	rm  picosat-965.tar.gz
    fi
}

get_picosat
build_picosat
