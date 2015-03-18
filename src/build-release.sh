#!/usr/bin/env bash

# set -x

builddir=release-build

if [ -f configs/`hostname` ]; then
    . configs/`hostname`
fi

if [ -d $builddir ]; then
    rm -rf $builddir
fi

if [ ! -d $builddir ]; then
    mkdir $builddir
fi

function abort
{
    echo "step failed, aborting"
    exit 1
}

top=$PWD

owner="D-Programming-Language"
branch="auto-tester-testing"

isWindows=0
if [ "${platforms[0]:0:4}" == "Win_" ]; then
    isWindows=1
    platforms=(Win_32)
fi

for platform in ${platforms[@]}; do
    echo "platform: $platform"
    export OS=$platform
    for repo in "dmd" "druntime" "phobos"; do
        if [ -d $top/$builddir/$repo ]; then
            rm -r $top/$builddir/$repo
        fi
        rm -f $top/$builddir/*$repo*.log

        src/do_checkout.sh "$builddir" "$platform" "$owner" "$repo" "$branch"
        if [ "$?" -ne 0 ]; then
            abort
        fi
    done

    src/do_fixup.sh "$builddir" "$platform" "1"

    for repo in "dmd" "druntime" "phobos"; do
        src/do_build_$repo.sh "$builddir" "$platform" 
        if [ "$?" != 0 ]; then
            abort
        fi
    done

    if [ $isWindows -eq 1 ]; then
	mkdir $builddir/$platform
	for repo in "dmd" "druntime" "phobos"; do
	    mv $builddir/$repo $builddir/$platform
	done
	mv $builddir/*.log $builddir/$platform
    fi
done

if [ $isWindows -eq 1 ]; then
    cp -r release-build-extras/install release-build/install

    cp release-build/Win_32/dmd/src/dmd.exe release-build/install/windows/bin32/
    cp release-build/Win_32/phobos/phobos.lib release-build/install/windows/lib32/
    cp release-build/Win_32/druntime/lib/gcstub.obj release-build/install/windows/lib32/

    cp -r release-build/Win_32/druntime/{benchmark,changelog.dd,HACKING.md,import,LICENSE,mak,posix.mak,project.ddoc,README.md,src,test,win32.mak,win64.mak} release-build/install/src/druntime/
    cp -r release-build/Win_32/phobos/{changelog.dd,etc,LICENSE_1_0.txt,posix.mak,README.md,unittest.d,win64.mak,CONTRIBUTING.md,index.d,phobos.json,project.ddoc,std,win32.mak} release-build/install/src/phobos/
    cp -r release-build/Win_32/dmd/{changelog.dd,dmd.xcodeproj,docs,ini,posix.mak,README.md,samples,src,test,VERSION} release-build/install/src/dmd/
fi
