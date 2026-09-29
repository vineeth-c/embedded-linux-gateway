# Booting ARM64 Linux through U-Boot

This guide documents the U-Boot-to-Linux handoff using
QEMU ARM64, a custom Linux kernel and a BusyBox initramfs.

## 1. Prepare the boot files

From the repository root:

```bash
mkdir -p phase1/boot-process/boot-files

cp phase1/linux-kernel/linux/arch/arm64/boot/Image \
   phase1/boot-process/boot-files/

cp phase1/rootfs/initramfs.cpio.gz \
   phase1/boot-process/boot-files/
```

## 2. Launch U-Boot

```bash
./scripts/run-uboot.sh
```

Interrupt autoboot if prompted.

## 3. Detect the virtual disk

At the U-Boot prompt:

```text
virtio scan
fatls virtio 0:1
```

The disk should contain `Image` and `initramfs.cpio.gz`.

## 4. Load the kernel and initramfs

```text
fatload virtio 0:1 0x42000000 Image
fatload virtio 0:1 0x48000000 initramfs.cpio.gz
setenv ramdisk_size $filesize
```

The `filesize` variable contains the size of the most
recently loaded file.

## 5. Prepare the Device Tree

```text
cp.b $fdtcontroladdr 0x49000000 0x100000
fdt addr 0x49000000
fdt header
```

This copies U-Boot's Device Tree into a separate RAM
location for the Linux kernel.

The 1 MiB copy size applies to our tested QEMU/U-Boot
configuration.

## 6. Configure boot arguments

```text
setenv bootargs 'console=ttyAMA0 rdinit=/init'
```

## 7. Boot Linux

```text
booti 0x42000000 0x48000000:$ramdisk_size 0x49000000
```

## 8. Verify the boot

Inside the BusyBox shell:

```sh
uname -m
cat /proc/cmdline
```

Expected results:

```text
aarch64
console=ttyAMA0 rdinit=/init
```

To exit QEMU, press Ctrl+A, release both keys,
then press X.

## Current limitations

This milestone uses manual U-Boot commands and a
QEMU-generated Device Tree. Automatic boot configuration,
persistent storage and production boot management are
not yet implemented.
