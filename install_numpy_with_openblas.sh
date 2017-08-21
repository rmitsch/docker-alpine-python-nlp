#!/bin/sh
# Source: https://hub.docker.com/r/o76923/alpine-numpy-stack/~/dockerfile/

# 1. Add repositories.
echo "http://alpine.gliderlabs.com/alpine/v3.5/main" > /etc/apk/repositories
echo "http://alpine.gliderlabs.com/alpine/v3.5/community" >> /etc/apk/repositories
echo "@edge http://alpine.gliderlabs.com/alpine/edge/community" >> /etc/apk/repositories

apk update
apk --no-cache add openblas-dev
apk add ca-certificates
update-ca-certificates
# Add openssl for fetching from https-URLs.
apk add openssl=1.0.2k-r0

# 2. Install openblas.
export NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
apk --no-cache add --virtual build-deps \
    musl-dev \
    linux-headers \
    zlib-dev \
    jpeg-dev=8-r6 \
    g++ \
    gcc
cd /tmp 
ln -s /usr/include/locale.h /usr/include/xlocale.h
pip install cython
cd /tmp
wget https://github.com/numpy/numpy/releases/download/v$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz
tar -xzf numpy-$NUMPY_VERSION.tar.gz
rm numpy-$NUMPY_VERSION.tar.gz
cd numpy-$NUMPY_VERSION/
cp site.cfg.example site.cfg
echo -en "\n[openblas]\nlibraries = openblas\nlibrary_dirs = /usr/lib\ninclude_dirs = /usr/include\n" >> site.cfg
python -q setup.py build -j ${NPROC} --fcompiler=gfortran install
cd /tmp
rm -r numpy-$NUMPY_VERSION