#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds cbmc

# in case something goes wrong, notify!
set -ex

pushd build
build_cbmc()
{
	mkdir -p bin

	# fake a statically-linking g++
	cat << 'EOF' > bin/g++
/usr/bin/g++ -static "$@"
EOF
	chmod uog+x bin/g++
	export PATH=$(readlink -e bin):$PATH

	pushd cbmc/src
	make minisat2-download
	make cbmc.dir -j 4
	file cbmc/cbmc
        chmod oug+rwx cbmc/cbmc
	cp cbmc/cbmc ../../cbmc_glibc
	popd
}

# get cbmc as one SAT solver to show case
get_cbmc()
{
	if [ ! -d cbmc ]
	then
		git clone https://github.com/diffblue/cbmc.git
	fi
}

get_cbmc
build_cbmc
