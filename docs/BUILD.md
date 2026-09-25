# Building the Embedded Linux Gateway

This guide documents the first working milestone: booting a
custom ARM64 Linux kernel with a BusyBox initramfs in QEMU.

## Environment

- Host: Ubuntu on WSL2
- Target: ARM64 (AArch64)
- Emulator: QEMU, Cortex-A53, 2 CPUs, 512 MB RAM
- Linux kernel: 6.12
- BusyBox: 1.36.1
- Boot method: Direct kernel boot using QEMU

## 1. Install dependencies

```bash
sudo apt update

sudo apt install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    qemu-system-arm \
    bc bison flex libssl-dev libelf-dev \
    libncurses-dev \
    cpio gzip bzip2 wget fakeroot
```

## 2. Build the Linux kernel

Download Linux kernel 6.12 and extract it into:

`phase1/linux-kernel/linux/`

From that directory:

```bash
cp ../../../configs/linux/arm64.config .config

make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    olddefconfig

make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    -j2 Image
```

The resulting kernel is:

`arch/arm64/boot/Image`

## 3. Build BusyBox

Download BusyBox 1.36.1 and extract it into:

`phase1/rootfs/busybox-1.36.1/`

From that directory:

```bash
cp ../../../configs/busybox/busybox.config .config

make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    olddefconfig

make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    -j2

make ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CONFIG_PREFIX=../rootfs-image install
```

BusyBox is configured for static linking.

The optional `tc` utility is disabled due to a compatibility
issue with the host toolchain's kernel headers.

## 4. Create the initramfs

From the repository root:

```bash
cd phase1/rootfs/rootfs-image

mkdir -p dev proc sys tmp etc
chmod 1777 tmp

cp ../../../rootfs/init ./init
chmod +x init
```

Create the archive:

```bash
fakeroot sh -c '
    mknod -m 600 dev/console c 5 1
    mknod -m 666 dev/null c 1 3
    find . -print0 | cpio --null -ov --format=newc
' | gzip -9 > ../initramfs.cpio.gz
```

## 5. Boot with QEMU

Return to the repository root:

```bash
cd ../../..
./scripts/run-qemu.sh
```

The system should boot into a BusyBox shell.

Verify the architecture:

```sh
uname -m
```

Expected output:

```text
aarch64
```

Verify that the shell is PID 1:

```sh
ps
```

To exit QEMU, press Ctrl+A, release both keys,
then press X.

## Current limitations

This is an initial development, not a
production-ready embedded Linux distribution.

The system currently uses a minimal BusyBox initramfs,
an interactive shell as PID 1 and QEMU virtual hardware.
