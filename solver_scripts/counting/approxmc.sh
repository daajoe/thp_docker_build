#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds ApproxMC

# in case something goes wrong, notify!
set -ex

pushd build
build_approxmc()
{
    pushd ApproxMC
    cmake -DSTATICCOMPILE:BOOL=1
    make -j 4
    file approxmc
    chmod oug+rwx approxmc
    cp approxmc ../approxmc_glibc
    popd
}

# get minisat as one SAT solver to show case
get_approxmc()
{
    if [ ! -d ApproxMC ]
    then
	git clone https://github.com/meelgroup/ApproxMC.git
    fi
}

# get minisat as one SAT solver to show case
get_cryptominisat()
{
    if [ ! -d cryptominisat ]
    then
	git clone https://github.com/msoos/cryptominisat.git
    fi
}

build_cyptominisat()
{
    pushd cryptominisat
    git submodule update --init
    cmake -DSTATICCOMPILE:BOOL=1 -DUSE_GAUSS=ON
    make -j4
    file cryptominisat5
    chmod oug+rwx cryptominisat5
    cp cryptominisat5 ../cryptominisat5_glibc
    popd
}

get_cryptominisat
build_cyptominisat
get_approxmc
build_approxmc
