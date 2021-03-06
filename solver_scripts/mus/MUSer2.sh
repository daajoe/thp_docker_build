#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds MaxHS

# in case something goes wrong, notify!
set -ex

pushd build
build_muser2()
{
    pushd muser2
    pushd ./src/tools/muser2
    cat << 'EOF' > Makefile.patch
16c16
< CPPFLAGS += 
---
> CPPFLAGS += -static    
EOF
    make allclean
    make
    file muser2
    chmod oug+rwx muser2
    cp muser2 ../../../../muser2_glibc
    popd
}

# get minisat as one SAT solver to show case
get_muser2()
{
    if [ ! -d muser2 ]
    then
	git clone https://bitbucket.org/anton_belov/muser2.git
    fi
}

get_muser2
build_muser2
