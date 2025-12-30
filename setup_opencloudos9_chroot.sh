#!/usr/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <chroot_dir>"
    exit 1
fi

if [ `id -u` -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi


chroot_dir=$1


if [ ! -d "$chroot_dir" ]; then
    echo "Chroot directory $chroot_dir does not exist."
    exit 1
fi

DIST_URL="https://mirrors.tencent.com/opencloudos/9/images/qcow2/loongarch64/OpenCloudOS-GenericCloud-9.4-20250820.0.loongarch64.qcow2"
TEMP_MOUNT_DIR="/mnt/OpenCloudOS9_mnt"

mkdir -p "$chroot_dir"
mkdir -p "$TEMP_MOUNT_DIR"

wget -q "$DIST_URL"

qemu-nbd --connect=/dev/nbd10 OpenCloudOS-GenericCloud-9.4-20250820.0.loongarch64.qcow2 
mount /dev/nbd10p3 "$TEMP_MOUNT_DIR"

rsync -auv $TEMP_MOUNT_DIR/* $chroot_dir

umount -l "$TEMP_MOUNT_DIR"
qemu-nbd -d /dev/nbd10

rm -f OpenCloudOS-GenericCloud-9.4-20250820.0.loongarch64.qcow2

