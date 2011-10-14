#!/bin/sh
rm -f commonde-*.deb
rm -f deflxcfg*.deb
rm -f cde-lxconfig*.deb
rm -f cde-offldiag*.deb
for x in *
do
 [ -d $x ] && fakeroot dpkg-deb --build $x
done
dpkg-name *.deb
