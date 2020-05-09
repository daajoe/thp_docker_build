#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019

# Run commands inside container

#set -ex
DOCKERFILE="$1"  # Dockerfile
shift

USER_FLAGS="-e USER="$(id -u)" -u=$(id -u)"

# disable getting the source again
if [ -z "$1" ] || [ "$1" = "sudo" ]
then
    USER_FLAGS=""
    shift
fi

if [ ! -r "$DOCKERFILE" ]
then
    echo "cannot find $DOCKERFILE (in $(readlink -e .)), abort"
    exit 1
fi


DOCKERFILE_DIR=$(dirname "$DOCKERFILE")
CONTAINER="${CONTAINER:-}"
[ -n "$CONTAINER" ] || CONTAINER=$(docker build -q -f "$DOCKERFILE" "$DOCKERFILE_DIR")

echo "running in container: $CONTAINER"
echo "  cmd: $@"

if [ ! -z "$READONLY" ] ; then 
    docker run -a STDOUT \
	   -it \
	   $USER_FLAGS \
	   -v $HOME:$HOME \
	   -v /tmp/thp/build_output:/tmp/thp/build_output \
	   --mount src="$(pwd)/build_inside_docker",target=/tmp/thp/build_input,type=bind \
	   -w $(pwd) \
	   "$CONTAINER" "$@"
else
    docker run \
	   $USER_FLAGS \
	   --mount src="$(pwd)/build",target=/tmp/thp_docker_build/build,type=bind \
	   -w /tmp/thp_docker_build \
	   "$CONTAINER" "$@"
fi
#	   -w $(realpath $(pwd)/../build) \

EXIT_CODE=$?
echo "Container exited with return_code=$EXIT_CODE"
exit $EXIT_CODE
