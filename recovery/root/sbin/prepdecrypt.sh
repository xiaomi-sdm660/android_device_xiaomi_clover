#!/sbin/sh

if [ ! -d /tmp/system ]; then
    mkdir /tmp/system
fi
mount -t ext4 -o ro "/dev/block/bootdevice/by-name/system" /tmp/system
ret=$?
if [ $ret != 0 ]; then
    echo "Could not read build properties from /system"
    setprop crypto.ready 1
    exit 0
fi

system_build_prop="/tmp/system/build.prop"
if [ -r $system_build_prop ]; then
    osver=$(grep 'ro.build.version.release' $system_build_prop  | cut -d'=' -f2)
    system_patchlevel=$(grep 'ro.build.version.security_patch' $system_build_prop  | cut -d'=' -f2)

    if [ "x$osver" != "x" ]; then
        resetprop ro.build.version.release "$osver"
    fi
    if [ "x$system_patchlevel" != "x" ]; then
        resetprop ro.build.version.security_patch "$system_patchlevel"
    fi
fi

umount /tmp/system

setprop crypto.ready 1
exit 0
