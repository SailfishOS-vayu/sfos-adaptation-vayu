#!/bin/bash
# Verbose script for mounting custom partitions
 
# Custom Partitions mounted
modem_part=/data/.stowaways/firmware/modem.img
dsp_part=/data/.stowaways/firmware/dsp.img
bluetooth_part=/data/.stowaways/firmware/bluetooth.img
vendor_part=/data/.stowaways/firmware/vendor.img
system_part=/data/.stowaways/firmware/system.img
system_ext_part=/data/.stowaways/firmware/system_ext.img
odm_part=/data/.stowaways/firmware/odm.img
product_part=/data/.stowaways/firmware/product.img
metadata_part=/data/.stowaways/firmware/metadata.img
 
dmesg_info() {
    echo "[mount-partitions.sh] $@" > /dev/kmsg
}
 
dmesg_info "Mount dynamic partitions"
mkdir -p /system_root /system_ext /vendor /odm2 /product /mnt /metadata
 
dmesg_info "$(mount -v -o loop,ro,barrier=1,discard -t ext4 $system_part /system_root)"
dmesg_info "$(mount --bind /system_root/system /system)"
dmesg_info "$(mount -v -o loop,ro,barrier=1,discard -t ext4 $system_ext_part /system_ext)"
dmesg_info "$(mount -v -o loop,ro,barrier=1,discard -t ext4 $vendor_part /vendor)"
dmesg_info "$(mount --bind /etc/mixer_paths_overlay_static.xml /vendor/etc/mixer_paths_overlay_static.xml)"
dmesg_info "$(mount -v -o ro,ro,barrier=1,discard -t ext4 $odm_part /odm2)"
dmesg_info "$(mount -v -o loop,ro,barrier=1,discard -t ext4 $product_part /product)"
dmesg_info "$(mount -v -o loop,ro,shortname=lower,uid=1000,gid=1000,dmask=227,fmask=337 -t vfat $modem_part  /vendor/firmware_mnt)"
dmesg_info "$(mount -v -o loop,ro,nosuid,nodev,barrier=1 -t ext4 $dsp_part /vendor/dsp)"
dmesg_info "$(mount -v -o loop,ro,shortname=lower,uid=1002,gid=3002,dmask=227,fmask=337 -t vfat $bluetooth_part /vendor/bt_firmware)"
dmesg_info "$(mount -v -o loop,ro,noatime,nosuid,nodev,discard -t ext4 $metadata_part /metadata)"
 
# comment out when everything works
dmesg_info "$(findmnt)"
