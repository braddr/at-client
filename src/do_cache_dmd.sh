#!/bin/bash

set -x

if [ $# -ne 2 ]; then
    echo "usage: $0 DMDVER OSTYPE"
    exit 1
fi

DMDVER=$1
OSTYPE=$2
FILENAME=dmd.$DMDVER.$OSTYPE.tar.xz

if [ -d release-build/dmd-$DMDVER ]; then
    # cached dir already exists, assume correct and move on
    exit 0
fi

if [ ! -f zips/$FILENAME ]; then
    curl --silent -f -L -o zips/$FILENAME http://downloads.dlang.org/releases/2.x/$DMDVER/$FILENAME
    if [ $? -ne 0 ]; then
        echo "failed to download $FILENAME"
        exit 1
    fi
fi

mkdir -p release-build/dmd-$DMDVER
tar -C release-build/dmd-$DMDVER --strip-components=1 -Jxf zips/$FILENAME dmd2/$OSTYPE dmd2/src

