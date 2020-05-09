#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds MaxHS

# in case something goes wrong, notify!
set -ex

pushd build
build_mosussaka()
{
    pushd MoUsSaka
    cat << 'EOF' > Makefile.patch
2c2
< CCFLAGS=-Iutil -O3 -Wall -fno-strict-aliasing -static -DNDEBUG  
---
> CCFLAGS=-Iutil -O3 -Wall -fno-strict-aliasing -static -DNDEBUG -std=c++98
EOF
    patch Makefile Makefile.patch
    make clean
    make
    file MoUsSaka
    chmod oug+rwx MoUsSaka
    cp MoUsSaka ../moussaka_glibc
    popd
}

# get minisat as one SAT solver to show case
get_mosussaka()
{
    if [ ! -d mosussaka ]
    then
	wget http://www-pr.informatik.uni-tuebingen.de/mitarbeiter/stephankottler/downloads/MoUsSaka2011.tgz
	tar xf MoUsSaka2011.tgz
	rm  MoUsSaka2011.tgz
    fi
}

get_mosussaka
build_mosussaka
