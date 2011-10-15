#!/bin/sh
rm -f buttonos-*.deb
rm -f deflxcfg*.deb
rm -f bos-lxconfig*.deb
rm -f bos-offldiag*.deb
for x in *
do
 [ -d $x ] && fakeroot dpkg-deb --build $x
done
dpkg-name *.deb
