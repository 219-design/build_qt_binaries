#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "reading single argument (should be opt or dbg)"
BUILDTYPE="dbg"
#$1

ROOT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# if you are on Ubuntu 16.04 you probably need to also run:
#   sudo add-apt-repository ppa:ubuntu-toolchain-r/test
#   sudo apt-get update
#   sudo apt-get install gcc-7 g++-7
#   sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60
#   sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60

sudo sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list
sudo sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
sudo apt-get update

#sudo apt-get build-dep qt5-default

cd $ROOT_SCRIPT_DIR  # enter this script's directory. (in case called from root of repository)

# 2024-10-21 my qt6 repo was checked out to tag: v6.8.0
qt_srcsdir="MINE_qt6"

cd ../"${qt_srcsdir}"
# if [ -d qt5_sources ]; then
#     echo "no need to clone qt5 sources"
# else
#   git clone git://code.qt.io/qt/qt5.git qt5_sources
# fi
#cd KEEP-qt5_sources

# git checkout v5.15.0
# git submodule update --init --recursive  \
#     qtbase \
#     qtdeclarative \
#     qtgraphicaleffects \
#     qtimageformats \
#     qtmultimedia \
#     qtquickcontrols \
#     qtquickcontrols2 \
#     qtscript \
#     qtsvg \
#     qttools \
#     qtx11extras


cd $ROOT_SCRIPT_DIR  # enter this script's directory. (getting our bearings again)
mkdir -p ../KEEP_qt6_${BUILDTYPE}_install
mkdir -p qt6_${BUILDTYPE}_configuration
cd qt6_${BUILDTYPE}_configuration

if [ ${BUILDTYPE} = "dbg" ]; then
  CONFIG_ARGS=" -debug "
else
  # for the OPT (optimized) default build
  CONFIG_ARGS=""
fi

if [ -f config.status ]; then
    # in a properly-working scenario, we would here
    # try to INVOKE config.status as: ./config.status -recheck-all
    # However this is broken in qt at the moment:
    #   https://bugreports.qt.io/browse/QTBUG-80096
    #   https://bugreports.qt.io/browse/QTBUG-79639
    echo "SKIPPING CONFIGURE. REMOVE PRIOR ARTIFACTS IF YOU WANT TO RECONFIGURE"
else

  # the '-no-pch' is a workaround for a known qt build issue
  ../../"${qt_srcsdir}"/configure \
      -prefix /opt/repositories/KEEP_qt6_${BUILDTYPE}_install \
      -opensource -confirm-license \
      -c++std c++17 \
      ${CONFIG_ARGS} \
      -ssl \
      -sysroot / \
      -no-pch \
      -pkg-config \
      -qt-libpng \
      -qt-zlib \
      -skip qt3d \
      -skip qtactiveqt \
      -skip qtandroidextras \
      -skip qtcanvas3d \
      -skip qtdatavis3d \
      -skip qtdoc \
      -skip qtdocgallery \
      -skip qtfeedback \
      -skip qtgamepad \
      -skip qtlottie \
      -skip qtmacextras \
      -skip qtnetworkauth \
      -skip qtpim \
      -skip qtpurchasing \
      -skip qtqa \
      -skip qtquick3d \
      -skip qtremoteobjects \
      -skip qtrepotools \
      -skip qtscxml \
      -skip qtsensors \
      -skip qtserialbus \
      -skip qtsystems \
      -skip qtwayland \
      -skip qtwebchannel \
      -skip qtwebengine \
      -skip qtwebglplugin \
      -skip qtwebsockets \
      -skip qtwebview \
      -skip qtwinextras \
      -nomake tools \
      -nomake examples \
      |& tee configure_${BUILDTYPE}_output.txt

fi

#      -v \

#       -no-compile-examples \

exit 1

#make -j6
cmake --build . -j 10

#make install
cmake --install .
