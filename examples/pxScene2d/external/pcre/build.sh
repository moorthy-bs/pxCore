#!/bin/bash -e

EXT_INSTALL_PATH=$PWD/extlibs

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

pushd $DIRECTORY
    if [[ "$#" -eq "1" && "$1" == "--clean" ]]; then
        quilt pop -afq || test $? = 2
        make distclean
    elif [[ "$#" -eq "1" && "$1" == "--force-clean" ]]; then
        git clean -fdx .
        git checkout .
    else
        tar --strip-components=1 -xjf pcre-8.39.tar.bz2
        PKG_CONFIG_PATH=$EXT_INSTALL_PATH/lib/pkgconfig:$PKG_CONFIG_PATH ./configure --prefix=$EXT_INSTALL_PATH --enable-newline-is-lf \
        --enable-rebuild-chartables --enable-utf8 --with-link-size=2 \
        --with-match-limit=10000000 --enable-pcre16 \
        --disable-pcretest-libreadline --enable-unicode-properties
        make -j$(getconf _NPROCESSORS_ONLN)
        make install
    fi
popd
