#!/usr/bin/env bash

# set -x

# args:
#    1) directory for build
#    2) os

. src/setup_env.sh "$2"

echo -e "\tbuilding dmd"

top=$PWD
cd $1/dmd

build_step=dmd-build
. src/host-dmd_env.sh

$makecmd MAKE=$makecmd MODEL=$COMPILER_MODEL $EXTRA_ARGS -f $makefile auto-tester-build >> ../dmd-build.log 2>&1
if [ $? -ne 0 ]; then
    echo -e "\tfailed to build dmd"
    exit 1
fi

if [ "$2" != "Win_32" -a "$2" != "Win_32_64" ]; then
    $makecmd MODEL=$COMPILER_MODEL $EXTRA_ARGS -f $makefile install >> ../dmd-build.log 2>&1
    if [ $? -ne 0 ]; then
	echo -e "\tfailed to install $repo"
	exit 1
    fi
fi
