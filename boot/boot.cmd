echo "Starting Embedded Linux Gateway..."

virtio scan

fatload virtio 0:1 0x42000000 Image
fatload virtio 0:1 0x48000000 initramfs.cpio.gz

setenv ramdisk_size ${filesize}

cp.b ${fdtcontroladdr} 0x49000000 0x100000

fdt addr 0x49000000

setenv bootargs 'console=ttyAMA0 rdinit=/init'

booti 0x42000000 0x48000000:${ramdisk_size} 0x49000000
