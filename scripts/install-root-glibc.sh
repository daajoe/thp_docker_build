#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script installs glibc.
# Should be run in a container, as it will install another glibc version

# in case something goes wrong, notify!
set -ex

install_libc()
{
    # build mergesat
    pushd /glibc
    mkdir -p build
    cd build
    make install
    popd
}

install_libc
