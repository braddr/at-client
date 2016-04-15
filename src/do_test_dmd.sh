#!/usr/bin/env bash

# set -x

# args:
#    1) directory for build
#    2) os
#    3) runmode (master, pull)

. src/setup_env.sh "$2"

echo -e "\ttesting dmd"

case "$2" in
    stub)
        exit 0
        ;;
    Win_32)
        export PARALLELISM
        ;;
    Win_32_64)
        makefile=win32.mak
        export PARALLELISM
        ;;
esac

if [ "$3" == "pull" ]; then
    ARGS="-O -inline -release"
fi

cd $1/dmd

if [ ! -z "$ARGS" ]; then
    $makecmd MODEL=$OUTPUT_MODEL $EXTRA_ARGS RESULTS_DIR=generated ARGS="$ARGS" -f $makefile auto-tester-test >> ../dmd-unittest.log 2>&1
else
    $makecmd MODEL=$OUTPUT_MODEL $EXTRA_ARGS RESULTS_DIR=generated -f $makefile auto-tester-test >> ../dmd-unittest.log 2>&1
fi

if [ $? -ne 0 ]; then
    echo -e "\tdmd tests had failures"
    exit 1
fi

