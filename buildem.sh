#!/bin/sh
rm -f commonde-*.deb
for x in *
do
 [ -d $x ] && fakeroot dpkg-deb --build $x
done
dpkg-name *.deb
