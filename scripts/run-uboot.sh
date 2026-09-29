#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

UBOOT="$PROJECT_ROOT/phase1/boot-process/u-boot/u-boot.bin"
BOOT_FILES="$PROJECT_ROOT/phase1/boot-process/boot-files"

if [[ ! -f "$UBOOT" ]]; then
    echo "Error: U-Boot binary not found."
    exit 1
fi

if [[ ! -f "$BOOT_FILES/Image" ||
      ! -f "$BOOT_FILES/initramfs.cpio.gz" ]]; then
    echo "Error: Kernel or initramfs missing from boot-files."
    exit 1
fi

qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 512M \
    -smp 2 \
    -nographic \
    -bios "$UBOOT" \
    -drive if=none,id=bootdisk,format=raw,file="fat:rw:$BOOT_FILES" \
    -device virtio-blk-device,drive=bootdisk
