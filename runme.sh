#!/bin/sh

set -ex

WORKSPACE=$(pwd)

NETDATA_URL="https://github.com/firehol/netdata/releases/download/v1.1.0/netdata-1.1.0.tar.xz"

wget --progress=dot -e dotbytes=2M \
  ${NETDATA_URL}
tar -xf netdata-*.tar.xz

. ~/bin/asustor-build-env

cd ${WORKSPACE}/netdata-*/
[ -x configure ] && ./configure \
  --host=${ARCH}-asustor-linux-gnu \
  --target=${ARCH}-asustor-linux-gnu \
  --build=x86_64-pc-linux-gnu \
  --prefix=${PREFIX}/netdata \
  --libexecdir=${PREFIX}/netdata/lib \
  --with-webdir=${PREFIX}/netdata/www \
  --with-user=admin \
  --with-zlib \
  --with-math
make -j$(getconf _NPROCESSORS_ONLN)
sudo make install

cd ${WORKSPACE}

cp -a /usr/local/AppCentral/netdata/etc/* \
  netdata/etc/
cp -a /usr/local/AppCentral/netdata/lib/* \
  netdata/lib/
cp -a /usr/local/AppCentral/netdata/sbin/* \
  netdata/sbin/
cp -a /usr/local/AppCentral/netdata/var/* \
  netdata/var/
cp -a /usr/local/AppCentral/netdata/www/* \
  netdata/www/
cp -a netdata-*/system/netdata.conf netdata/etc/netdata/

rm -rf netdata-*

yaml-to-json.py config.yaml > netdata/CONTROL/config.json
apkg-tool create netdata
