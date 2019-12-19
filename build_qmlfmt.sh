#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $THISDIR/qmlfmt
git submodule update --init --recursive

cd $THISDIR
mkdir -p qmlfmt_build

if [ -f "$THISDIR/qmlfmt_build/CMakeCache.txt" ]; then
      echo "Refusing to build qmlfmt because it seems built. Clean out the dir to rebuild."
      return 1
fi

cd qmlfmt_build

# if Qt creator build wants GL/gl.h and you don't have it, then
# refer to: https://askubuntu.com/questions/306703/compile-opengl-program-missing-gl-gl-h
#
# you may also need:
#  libdouble-conversion-dev
cmake -DQT_CREATOR_SRC=$THISDIR/qmlfmt/qt-creator/ -DCMAKE_PREFIX_PATH=$THISDIR/qt5_opt_install/ -DCMAKE_BUILD_TYPE=Debug $THISDIR/qmlfmt

make VERBOSE=1 -j4

cd $THISDIR
mkdir -p qmlfmt_install

# the exe should be standalone, so "install" is just copying it
cp qmlfmt_build/qmlfmt qmlfmt_install/
