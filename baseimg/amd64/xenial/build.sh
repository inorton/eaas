#!/bin/bash
#
# make a very very basic bootable xenial amd64 image
#

function unmount {
  set +e
  umount ./mnt/proc
  umount ./mnt 
}

IMAGE_SIZE=${IMAGE_SIZE:-65535}
DISTRO=xenial
ARCH=amd64
APTSRC=http://archive.ubuntu.com/ubuntu/

echo .. will create a $IMAGE_SIZE Mb sparse image

set -e

mkdir -p mnt

dd if=/dev/zero of=disk.bin bs=1M count=1 seek=$IMAGE_SIZE
mkfs.ext4 -F ./disk.bin
mount ./disk.bin `pwd`/mnt -o loop,rw

trap unmount EXIT

/usr/sbin/debootstrap --arch $ARCH $DISTRO `pwd`/mnt $APTSRC

cp initial.sh ./mnt/.
LANG=C.UTF-8 chroot `pwd`/mnt bash /initial.sh

cp packages.sh ./mnt/.
LANG=C.UTF-8 chroot `pwd`/mnt bash /packages.sh

if [ -f ../../xenian.amd64.packages.sh ]
then
  cp ../../xenian.amd64.packages.sh ./mnt/extra.sh
  LANG=C.UTF-8 chroot `pwd`/mnt bash /extra.sh
fi


umount ./mnt
