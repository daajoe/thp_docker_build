#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds monosat

# in case something goes wrong, notify!
set -ex

pushd build
build_monosat()
{
	mkdir -p bin

	# fake a statically-linking g++
	cat << 'EOF' > bin/c++
/usr/bin/c++ "$@" -static
EOF
	chmod uog+x bin/c++
	export PATH=$(readlink -e bin):$PATH

	pushd monosat
	cmake . -DBUILD_STATIC=ON -DBUILD_DYNAMIC=OFF -DCMAKE_CXX_COMPILER=c++
	make -j 1

	# repeat last step of compilation one more time, reorder some parameter to make it actually a statically linked binary
	c++ -DNO_GMP -std=c++11 -Werror=return-type -Wno-unused-variable -Wno-unused-but-set-variable   -Wno-sign-compare  -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -O3 -DNDEBUG -DNDEBUG -O3  -rdynamic CMakeFiles/monosat_static.dir/src/monosat/Main.cc.o  -o monosat  -static libmonosat.a -lz -lgmpxx -lgmp # -L/usr/local/lib -Wl,-rpath,/usr/local/lib: -static-libgcc -static-libstdc++ libmonosat.a -Wl,-Bstatic -lz -lgmpxx -lgmp -Wl,-Bstatic -lrt
	file monosat
        chmod oug+rwx monosat
	cp monosat ../monosat_glibc
	popd
}

# get monosat
get_monosat()
{
	if [ ! -d monosat ]
	then
		git clone https://github.com/sambayless/monosat.git
	fi
}

get_monosat
build_monosat
