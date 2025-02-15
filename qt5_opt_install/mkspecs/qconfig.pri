!host_build {
    QMAKE_CFLAGS    += --sysroot=$$[QT_SYSROOT]
    QMAKE_CXXFLAGS  += --sysroot=$$[QT_SYSROOT]
    QMAKE_LFLAGS    += --sysroot=$$[QT_SYSROOT]
}
host_build {
    QT_ARCH = x86_64
    QT_BUILDABI = x86_64-little_endian-lp64
    QT_TARGET_ARCH = x86_64
    QT_TARGET_BUILDABI = x86_64-little_endian-lp64
} else {
    QT_ARCH = x86_64
    QT_BUILDABI = x86_64-little_endian-lp64
}
QT.global.enabled_features = shared cross_compile rpath c++11 c++14 c++1z c99 c11 thread future concurrent pkg-config signaling_nan
QT.global.disabled_features = framework appstore-compliant debug_and_release simulator_and_device build_all c++2a force_asserts separate_debug_info static
PKG_CONFIG_SYSROOT_DIR = /
PKG_CONFIG_LIBDIR = //usr/lib/pkgconfig://usr/share/pkgconfig://usr/lib/x86_64-linux-gnu/pkgconfig
QT_CONFIG += shared rpath release c++11 c++14 c++1z concurrent dbus reduce_exports reduce_relocations stl
CONFIG += shared cross_compile release
QT_VERSION = 5.14.0
QT_MAJOR_VERSION = 5
QT_MINOR_VERSION = 14
QT_PATCH_VERSION = 0
QT_GCC_MAJOR_VERSION = 7
QT_GCC_MINOR_VERSION = 4
QT_GCC_PATCH_VERSION = 0
QT_EDITION = OpenSource
