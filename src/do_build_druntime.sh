#!/usr/bin/env bash

# set -x

# args:
#    1) directory for build
#    2) os

. src/setup_env.sh "$2"

echo -e "\tbuilding druntime"

cd $1/druntime

DMD_PATH=`ls -1 ../dmd/generated/*/release/$COMPILER_MODEL/dmd$EXE`

$makecmd DMD=$DMD_PATH MODEL=$OUTPUT_MODEL $EXTRA_ARGS -f $makefile auto-tester-build >> ../druntime-build.log 2>&1
if [ $? -ne 0 ]; then
    echo -e "\tdruntime failed to build"
    exit 1
fi

if [ "$2" != "Win_32" -a "$2" != "Win_32_64" ]; then
    $makecmd MODEL=$OUTPUT_MODEL $EXTRA_ARGS -f $makefile install >> ../druntime-build.log 2>&1
    if [ $? -ne 0 ]; then
	echo -e "\tfailed to install $repo"
	exit 1
    fi
fi
