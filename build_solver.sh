#!/usr/bin/env bash
#
# Copyright Norbert Manthey, 2019
# Modified Johannes Fichte, TU Dresden, 2020
#

#set -xe

SOLVER=$1

declare -i OVERALL_STATUS=0
mkdir -p build/logs

function output_exists() {
    filename=$(basename -- "$1")
    filename="build/${filename%.*}_glibc"
    if [ -f $filename ] ; then
	return 0
    else
	return 1
    fi
    return 55
}

if [[ -z $SOLVER ]] ; then
    echo "No specific solver build-script given."
    echo "Building all solvers in the folder \"solver_scripts\" using their *.sh script files."
    list=$(find solver_scripts -name \*.sh)
    echo "Scripts: $list"
    
    # build all targets that we have
    for NEXT in $list; do
	echo -e "\e[3mBuilding the next solver $NEXT \e[0m"
	# only execute execuatble scripts
	[ -x "$NEXT" ] || (echo "Script is not executable. Ignoring.." && continue)
        output_exists $SOLVER && (echo -e "\e[1mSolver outputs exists in 'build' for $NEXT. Continuing without building...\e[0m" && continue)
	
	# build the next target, if we did not select one
	echo "[$SECONDS] start building $NEXT"
	declare -i STATUS=0
	echo $(pwd)
	OUTPUT="build/logs/$(basename $NEXT).build.log"
	echo $OUTPUT
	scripts/run_in_container.sh DockerfileInstall "$NEXT" &> $OUTPUT &
	PID=$!
	tail -f $OUTPUT &
	wait $PID
	STATUS=$?
	[ "$STATUS" -eq 0 ] || OVERALL_STATUS=$STATUS
	echo "\e[3m[$SECONDS] finished building $NEXT with status $STATUS\e[0m"
    done
else
    output_exists $SOLVER
    res=$?
    if [[ $res == 0 ]] ; then
	echo "There is already a corresponding outputfile in 'build/' for $SOLVER. Pls remove the file if you intend to rebuild."
	echo "Continuing without building..."
	exit 0
    fi
    echo -e "\e[3mBuilding the solver \"$SOLVER\" \e[0m"
    if [[ ! -f $SOLVER ]]; then
	echo "The file $SOLVER does not exist. Exiting..."
	exit 2
    fi
    scripts/run_in_container.sh DockerfileInstall "$SOLVER" || exit $?
    echo "Solver build finished successfully"
fi
# exit with the collected exit code
exit $OVERALL_STATUS
