#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

KERNEL="$PROJECT_ROOT/phase1/linux-kernel/linux/arch/arm64/boot/Image"
INITRAMFS="$PROJECT_ROOT/phase1/rootfs/initramfs.cpio.gz"

if [[ ! -f "$KERNEL" || ! -f "$INITRAMFS" ]]; then
    echo "Error: Kernel Image or initramfs not found."
    echo "Build the kernel and root filesystem first."
    exit 1
fi

qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 512M \
    -smp 2 \
    -nographic \
    -kernel "$KERNEL" \
    -initrd "$INITRAMFS" \
    -append "console=ttyAMA0 rdinit=/init"
