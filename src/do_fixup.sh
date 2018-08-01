#!/usr/bin/env bash

# set -x

# args:
#    1) directory for build
#    2) os
#    3) project

. src/setup_env.sh "$2"

echo -e "\tapplying fixups to checked out source"

# fixups for DMD related build types

# allows to gradually remove the patching
# If at some point a new diff needs to be introduced, `diffVersion` can be bumped
# for the respective repository
tryFixup()
{
    local repo=$1
    local patchFile=$2
    local diffVersion=$3
    local repoBase=$(basename $repo | tr /a-z/ /A-Z/)

    pushd $repo

    if ! grep -q "NO_AUTOTESTER_PATCHING_V${diffVersion}_${repoBase}" $repo/win64.mak ; then
        patch -p1 < $patchFile
    fi
    popd
}

if [ "x$3" == "x1" -a "x${2:0:4}" == "xWin_" ]; then
    # move minit.obj to be newer than minit.asm
    touch $1/druntime/src/rt/minit.obj

    # fix VC path issues
    tryFixup $1/dmd ../../src/diff-dmd-win64.diff 1
    tryFixup $1/druntime ../../src/diff-druntime-win64.diff 1
    tryFixup $1/phobos ../../src/diff-phobos-win64.diff 1
fi

