# Embedded Linux Gateway

An ARM64 Embedded Linux gateway developed
using QEMU, U-Boot, the Linux kernel, and C++.

The goal is to build complete embedded Linux
system, from bootloader initialization to application-level
communication, testing, and fault recovery.

## Development Environment

- Host: Ubuntu on WSL2
- Target: ARM64 QEMU virtual machine
- Cross-compiler: aarch64-linux-gnu
- Bootloader: U-Boot
- Kernel: Linux

## Project Roadmap

- [x] Set up ARM64 cross-compilation
- [x] Build and run U-Boot in QEMU
- [x] Configure the ARM64 Linux kernel
- [ ] Build and boot the Linux kernel
- [ ] Create a root filesystem
- [ ] Explore Device Tree and Linux drivers
- [ ] Build a custom Yocto image
- [ ] Develop a C++ gateway application
- [ ] Implement simulated CAN communication
- [ ] Add fault recovery, testing, and OTA updates

## Current Project Structure

- `phase1/cross-compilation/` — Native and ARM64 compilation exercises
- `phase1/boot-process/` — U-Boot development workspace
- `phase1/linux-kernel/` — Linux kernel development workspace

Downloaded upstream source trees and generated build
artifacts are excluded from this repository.

## Build Documentation

Detailed setup, build, testing, and debugging instructions
will be added as we progress.
