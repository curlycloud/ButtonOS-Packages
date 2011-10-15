#!/bin/sh
# pb = persistent browser
# Keep the browser running and clean between sessions in ~buttonos
# hendry@webconverger.com
#modified for ButtonOS gunnjo@buttonos.org
MYHOME=/home/buttonos

# Stop (ab)users breaking the loop to restart the exited browser
trap "echo Unbreakable!" SIGINT SIGTERM

# Set default homepage if homepage cmdline isn't set
test $1 || set -- "http://www.buttonos.org/start"

grep -qs noxbg /proc/cmdline || {
cp /etc/buttonos/buttonos.png $MYHOME/bg.png
( wget --timeout=5 -q $1/bg.png -O $MYHOME/bg.tmp ; file $MYHOME/bg.tmp | grep -qs PNG\ image && mv $MYHOME/bg.tmp $MYHOME/bg.png ) &
}
# disable bell
xset b 0 0

# set background
xsetroot -solid "#444444"

wm=/usr/bin/dwm.default
[ -x /usr/bin/lxsession ] && wm=/usr/bin/lxsession
$wm &

# hide the cursor by default, showcursor to override
grep -qs showcursor /proc/cmdline || /usr/bin/unclutter &

for x in $(cat /proc/cmdline); do
	case $x in
		homepage=*)
		set -f -- $(/bin/busybox httpd -d ${x#homepage=})
		;;
		kioskresetstation=*) # For killing the browser after a number of minutes of idleness
		/usr/bin/kioskresetstation ${x#kioskresetstation=} &
		;;
	esac
done

grep -qs compose /proc/cmdline && setxkbmap -option "compose:rwin" && logger "Compose key setup"

# if no-x-background is unset, try setup a background from homepage ($1)
grep -qs noxbg /proc/cmdline || {
xloadimage -quiet -onroot -center $MYHOME/bg.png -border "#444444"
}

# No screen blanking (warning: might limit the life span of your screen & world)
grep -qs noblank /proc/cmdline && xset s off && xset -dpms && logger noblank

while true
do

	if test -x /usr/bin/iceweasel
	then
		rm -rf $MYHOME/.mozilla/
		iceweasel $@
		rm -rf $MYHOME/.mozilla/
	fi

	rm -rf $MYHOME/.adobe
	rm -rf $MYHOME/.macromedia
	rm -rf $MYHOME/Downloads

done
