#!/system/bin/sh
#script by Da_G to set up su and busybox adapted for i927(utkanos) adapted to i110(PlayfulGod)
mount -o rw,remount /dev/block/mmcblk0p8 /system
/busybox cp /su /system/xbin/su
/busybox chmod 06755 /system/xbin/su
/busybox cp /busybox /system/xbin/busybox
/system/xbin/busybox --install -s /system/xbin
/system/xbin/busybox chmod 4755 /system/xbin/su
# fix busybox DNS while system is read-write
if [ ! -f "/system/etc/resolv.conf" ]; then
  echo "nameserver 8.8.8.8" >> /system/etc/resolv.conf
  echo "nameserver 8.8.8.4" >> /system/etc/resolv.conf
fi
# setup proper passwd and group files for 3rd party root access
if [ ! -f "/system/etc/passwd" ]; then
  echo "root::0:0:root:/data/local:/system/bin/sh" > /system/etc/passwd
  chmod 0666 /system/etc/passwd
fi
if [ ! -f "/system/etc/group" ]; then
  echo "root::0:" > /system/etc/group
  chmod 0666 /system/etc/group
fi
# Enable init.d support
if [ -d /system/etc/init.d ]
then
  logwrapper busybox run-parts /system/etc/init.d
fi
sync
mount -o ro,remount /dev/block/mmcblk0p8 /system