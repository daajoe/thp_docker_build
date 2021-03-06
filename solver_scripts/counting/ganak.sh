#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds Ganak

# in case something goes wrong, notify!
set -ex

pushd build
build_ganak()
{
    pushd ganak
    if [ ! -d build ] ; then
	mkdir build
    fi
    cp ../mis/{mis.py,togmus,muser2} build
    cd build
    cmake -DSTATICCOMPILE:BOOL=1 ..
    make -j 4
    file ganak
    chmod oug+rwx ganak
    cp ganak ../../ganak_glibc
    popd
}

# get minisat as one SAT solver to show case
get_ganak()
{
    if [ ! -d ganak ]
    then
	git clone https://github.com/meelgroup/ganak.git
    fi
}

# get minisat as one SAT solver to show case
get_mis()
{
    if [ ! -d mis ]
    then
	git clone https://github.com/meelgroup/mis.git
    fi
}

build_mis()
{
    pushd mis
    git submodule update --init
    make static -j4
    file togmus
    chmod oug+rwx togmus
    pushd muser2-dir/src/tools/muser2
    file muser2
    chmod oug+rwx muser2
    cp muser2 ../../../..
    popd
    popd
}

get_mis
build_mis
get_ganak
build_ganak
