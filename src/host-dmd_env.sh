#!/usr/bin/env bash

logfile="../${build_step}.log"

if [ "${2:0:7}" == "Darwin_" -o "${2:0:6}" == "Win_32" ]; then
    BINDIR=bin
else
    BINDIR=bin$COMPILER_MODEL
fi

# expose a prebuilt dmd
DMDVER=2.079.0
HOST_DMD=`ls -1 $top/release-build/dmd-$DMDVER/*/$BINDIR/dmd$EXE`
echo "HOST_DMD=$HOST_DMD" >> "$logfile" 2>&1

if [[ ! -z "$HOST_DMD" && ( "$2" == "Win_32" || "$2" == "Win_32_64" ) ]]; then
    HOST_DMD=`cygpath -w $HOST_DMD`
    echo "HOST_DMD=$HOST_DMD" >> "$logfile" 2>&1
fi

export HOST_DMD
