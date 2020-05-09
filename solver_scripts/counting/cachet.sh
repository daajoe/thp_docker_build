#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds SharpSAT

# in case something goes wrong, notify!
set -ex

pushd build
build_cachet()
{
    pushd cachet-wmc-1-21
    cat << 'EOF' > hash_h.patch
8c8
< //#include <sys/sysinfo.h>
---
> #include <sys/sysinfo.h>
EOF
    patch hash.h hash_h.patch
    make clean
    make
    file cachet
    chmod oug+rwx cachet
    cp cachet ../cachet_glibc
    popd
}

# get minisat as one SAT solver to show case
get_cachet()
{
    if [ ! -d cachet ]
    then
	wget https://www.cs.rochester.edu/u/kautz/Cachet/cachet-wmc-1-21.zip
	unzip cachet-wmc-1-21.zip
	rm cachet-wmc-1-21.zip
    fi
}

get_cachet
build_cachet
