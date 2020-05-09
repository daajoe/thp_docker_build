#!/usr/bin/env bash
#
# Based on sources by Norbert Manthey, 2019
# Created by Johannes Fichte, TU Dresden, 2020
#

echo -e "\e[1mYou might have to run the script with docker permissions or sudo.\e[0m"

# get the sources
echo "Preparing glibc sources"
mkdir build
pushd build
../scripts/prepare-build.sh || PREPARE=$?
case $PREPARE in
    10|20)
    ;;
    *)
	echo "Could not prepare the glibc directory."
	exit 1
esac
popd

# prepare and use a new container for this
declare -i PREPARE=0
echo "Preparing Container (for errors check prepare.log)"
scripts/run_in_container.sh DockerfileBuild ls 2>&1 > build/prepare.log || BUILD_GLIBC=$?

echo "[$SECONDS] end prepare with $PREPARE"
if [ $PREPARE != 0 ] ; then
    echo "Prepare failed with exit code $PREPARE"
    exit $PREPARE
fi

CONTAINER_ID=$(awk '/^running in container:/ {print $4}' build/prepare.log)
if [ -z "$CONTAINER_ID" ]
then
    echo "failed to obtain container ID, abort"
    exit 1
fi

# make sure we run in the same image
export CONTAINER="$CONTAINER_ID"

# build glibc
declare -i BUILD_GLIBC=0
./scripts/run_in_container.sh DockerfileBuild scripts/build-glibc.sh || BUILD_GLIBC=$?
echo "[$SECONDS] end build glibc with $BUILD_GLIBC"
[ "$BUILD_GLIBC" -eq 0 ] || exit $BUILD_GLIBC

unset CONTAINER
echo "Just a placeholder to avoid make rebuilding already build glibc" > glibc
exit 0
