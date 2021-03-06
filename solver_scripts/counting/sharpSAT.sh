#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds SharpSAT

# in case something goes wrong, notify!
set -ex

pushd build
build_sharpsat()
{
    pushd sharpSAT
    cat << 'EOF' > CMakeLists.txt.patch
5d4
< set(CMAKE_EXE_LINKER_FLAGS "-static-libgcc -static-libstdc++")
EOF
    patch CMakeLists.txt CMakeLists.txt.patch 

    ./setupdev.sh
    cd build/Release
    make clean
    make -j 4
    file sharpSAT
    chmod oug+rwx sharpSAT
    cp sharpSAT ../../../sharpsat_glibc
    popd
}

# get minisat as one SAT solver to show case
get_sharpsat()
{
    if [ ! -d sharpSAT ]
    then
	git clone https://github.com/marcthurley/sharpSAT.git
    fi
}

get_sharpsat
build_sharpsat
