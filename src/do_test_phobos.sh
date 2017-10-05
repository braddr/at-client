#!/usr/bin/env bash

#set -x

# args:
#    1) directory for build
#    2) os

. src/setup_env.sh "$2"

echo -e "\ttesting phobos"

cd $1/phobos

# TODO: are those two copies needed for the new windows hosts?
case "$2" in
    stub)
        exit 0
        ;;
esac

$makecmd MODEL=$OUTPUT_MODEL $EXTRA_ARGS -f $makefile auto-tester-test >> ../phobos-unittest.log 2>&1
if [ $? -ne 0 ]; then
    echo -e "\tphobos tests failed"
    exit 1
fi

