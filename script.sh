#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "reading single argument (should be opt or dbg)"
BUILDTYPE=$1

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

sudo apt-get build-dep qt5-default

cd $ROOT_SCRIPT_DIR  # enter this script's directory. (in case called from root of repository)

cd ..
if [ -d qt5_sources ]; then
    echo "no need to clone qt5 sources"
else
  git clone git://code.qt.io/qt/qt5.git qt5_sources
fi
cd qt5_sources

git checkout v5.14.0
git submodule update --init --recursive  \
    qtbase \
    qtcharts \
    qtdeclarative \
    qtgraphicaleffects \
    qtimageformats \
    qtmultimedia \
    qtquickcontrols \
    qtquickcontrols2 \
    qtquicktimeline \
    qtscript \
    qtsvg \
    qttools \
    qttranslations \
    qtvirtualkeyboard \
    qtx11extras \
    qtxmlpatterns


cd $ROOT_SCRIPT_DIR  # enter this script's directory. (getting our bearings again)
mkdir -p ../qt5_${BUILDTYPE}_install
mkdir -p qt5_${BUILDTYPE}_configuration
cd qt5_${BUILDTYPE}_configuration

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
  ../../qt5_sources/configure \
      -prefix "${PWD}/../../qt5_${BUILDTYPE}_install" \
      -opensource -confirm-license \
      -c++std c++17 \
      ${CONFIG_ARGS} \
      -sysroot / \
      -no-pch \
      -pkg-config \
      -qt-libpng \
      -qt-zlib \
      -skip qt3d \
      -skip qtactiveqt \
      -skip qtandroidextras \
      -skip qtcanvas3d \
      -skip qtconnectivity \
      -skip qtdatavis3d \
      -skip qtdoc \
      -skip qtdocgallery \
      -skip qtfeedback \
      -skip qtgamepad \
      -skip qtlocation \
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
      -skip qtserialport \
      -skip qtspeech \
      -skip qtsystems \
      -skip qtwayland \
      -skip qtwebchannel \
      -skip qtwebengine \
      -skip qtwebglplugin \
      -skip qtwebsockets \
      -skip qtwebview \
      -skip qtwinextras \
      -no-compile-examples \
      -nomake tools \
      -nomake examples \
      -v \
      |& tee configure_${BUILDTYPE}_output.txt

fi




make -j6

make install
