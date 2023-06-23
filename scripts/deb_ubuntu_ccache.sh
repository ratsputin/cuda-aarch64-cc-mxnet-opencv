#!/usr/bin/env bash

set -ex

pushd .

apt update || true
apt install -y \
    libxslt1-dev \
    docbook-xsl \
    xsltproc \
    libxml2-utils

apt install -y --no-install-recommends \
    autoconf \
    asciidoc \
    xsltproc

mkdir -p /work/deps
cd /work/deps

git clone --recursive -b v4.8.2 https://github.com/ccache/ccache.git

cd ccache

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
make install

rm -rf /work/deps/ccache

popd

