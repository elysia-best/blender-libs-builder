#!/bin/bash

# Stop execution if any command fails
set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <chroot_dir>"
    exit 1
fi

chroot_dir=$1

cd $chroot_dir

echo "Mounting chroot directories"

mount -o rbind /dev dev > /dev/null &
mount -t proc none proc > /dev/null &
mount -o bind /sys sys > /dev/null &
mount -o bind /tmp tmp > /dev/null &

# Fix term into issues
mount --bind -o ro /usr/share/terminfo usr/share/terminfo

# Make network work
cp /etc/resolv.conf etc

chroot . /bin/bash -l
