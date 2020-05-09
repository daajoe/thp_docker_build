#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
#
# This script builds plingeling as a statically linked binary

# in case something goes wrong, notify!
set -ex

# name of the tool we build
declare -r TOOL="plingeling"
declare -r TOOL_URL="https://github.com/arminbiere/lingeling.git"


# declare a suffix for the binary
declare -r BUILD_SUFFIX="_glibc"

# the final binary should be moved here
SCRIPT_DIR=$(dirname "$0")
declare -r BINARY_DIRECTORY="$(readlink -e "$SCRIPT_DIR")"

# commit we might want to build, defaults to empty, if none is specified
declare -r COMMIT=${PLINGELING_COMMIT:-}

pushd build

# specific instructions to build the tool: plingeling
# this function is called in the source directory of the tool
build_tool ()
{
	# fake a statically-linking g++
	mkdir -p bin
	cat << 'EOF' > bin/gcc
/usr/bin/gcc "$@" -static
EOF
	chmod uog+x bin/gcc
	export PATH=$(readlink -e bin):$PATH

	# enter simp directory and build
	./configure.sh --no-aiger --no-yalsat --no-druplig
	make plingeling lingeling -j $(nproc)

	# check file properties
	file plingeling
	# make executable for everybody
        chmod oug+rwx plingeling
	# store created binary in destination directory, with given suffix
	cp plingeling "$BINARY_DIRECTORY"/"${TOOL}${BUILD_SUFFIX}"

	# check file properties
	file lingeling
	# make executable for everybody
        chmod oug+rwx lingeling
	# store created binary in destination directory, with given suffix
	cp lingeling "$BINARY_DIRECTORY"/"lingeling${BUILD_SUFFIX}"
}

#
# this part of the script should be rather independent of the actual tool
#

# build the tool
build()
{
	pushd "$TOOL"
	build_tool
	popd
}

# get the tool via the given URL
get()
{
	# get the solver, store in directory "$TOOL"
	if [ ! -d "$TOOL" ]
	then
		git clone "$TOOL_URL" "$TOOL"
	fi

	# in case there is a specific commit, jump to this commit
	if [ -n "$COMMIT" ]
	then
		pushd "$TOOL"
		git fetch origin
		git reset --hard "$COMMIT"
		# no submodules are used in plingeling
		popd
	fi
}


mkdir -p "$BINARY_DIRECTORY"
get
build
