#!/usr/bin/env bash
#
# Copyright Johannes Fichte, 2020
#
# This script builds SharpSAT

# in case something goes wrong, notify!
set -ex

pushd build
build_minic2d()
{
    pushd miniC2D-1.0.0
    cat << 'EOF' > Makefile.patch
17,18c17,18
< CFLAGS = -O2 -Wall -Iinclude
< LFLAGS = -L$(LIB) -lsat -lvtree -lnnf -lutil -lgmp
---
> CFLAGS = -O2 -Wall -Iinclude -static
> LFLAGS = -L$(LIB) -lsat -lvtree -lnnf -lutil -lgmp -static
EOF
    patch Makefile Makefile.patch
    make clean
    make
    pushd  bin/linux/
    file miniC2D
    chmod oug+rwx miniC2D
    cp miniC2D ../../../minic2d_glibc
    file hgr2htree
    chmod oug+rwx hgr2htree
    cp hgr2htree ../../../hgr2htree
    popd
}

# get minisat as one SAT solver to show case
get_minic2d()
{
    if [ ! -d minic2d ]
    then
	if [ -f "miniC2D.tar.gz" ]; then
	    tar xf miniC2D.tar.gz
	else
	    echo "You need to MANUALLY download file from http://reasoning.cs.ucla.edu/minic2d/download2.php and place it here."
	    exit 1
	fi
    fi
}

get_minic2d
build_minic2d
