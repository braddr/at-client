#!/usr/bin/env bash

set -x

if [ $# -ne 2 ]; then
    echo "usage: $0 DMDVER OSTYPE"
    exit 1
fi

DMDVER=$1
OSTYPE=$2

if [ -d release-build/dmd-$DMDVER ]; then
    # cached dir already exists, assume correct and move on
    exit 0
else
    mkdir -p release-build/dmd-$DMDVER
fi

if [ ! -d zips ]; then
    mkdir zips
fi

if [ "$OSTYPE" == "windows" ]; then
    FILENAME=dmd.$DMDVER.$OSTYPE.zip
    curl --silent -f -L -o zips/$FILENAME http://downloads.dlang.org/releases/2.x/$DMDVER/$FILENAME
    unzip zips/$FILENAME -d release-build/dmd-$DMDVER
    mv release-build/dmd-$DMDVER/dmd2/windows release-build/dmd-$DMDVER/
    mv release-build/dmd-$DMDVER/dmd2/src     release-build/dmd-$DMDVER/
    rm -rf release-build/dmd-$DMDVER/dmd2
    chmod u+x release-build/dmd-$DMDVER/windows/bin*/*.{exe,dll}
elif [ "$OSTYPE" == "freebsd" ]; then
    FILENAME=dmd.$DMDVER.$OSTYPE-32.tar.xz
    curl --silent -f -L -o zips/$FILENAME http://downloads.dlang.org/releases/2.x/$DMDVER/$FILENAME
    tar -C release-build/dmd-$DMDVER --strip-components=1 -Jxf zips/$FILENAME dmd2/$OSTYPE dmd2/src

    FILENAME=dmd.$DMDVER.$OSTYPE-64.tar.xz
    curl --silent -f -L -o zips/$FILENAME http://downloads.dlang.org/releases/2.x/$DMDVER/$FILENAME
    tar -C release-build/dmd-$DMDVER --strip-components=1 -Jxf zips/$FILENAME dmd2/$OSTYPE dmd2/src
else
    FILENAME=dmd.$DMDVER.$OSTYPE.tar.xz
    curl --silent -f -L -o zips/$FILENAME http://downloads.dlang.org/releases/2.x/$DMDVER/$FILENAME
    tar -C release-build/dmd-$DMDVER --strip-components=1 -Jxf zips/$FILENAME dmd2/$OSTYPE dmd2/src
fi
