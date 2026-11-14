# Building and Testing SAIF

## Current prototype target

The first executable product prototype is an x86_64 Linux-based SAIF image built with Buildroot. The build produces both the existing direct-kernel QEMU diagnostic pair and a GPT disk image intended to boot through UEFI firmware, GRUB, and a serial console. This remains a minimal console foundation, not yet a desktop environment, graphical live session, installer, or Windows/Android compatibility release.

Buildroot is pinned to 2025.02.19. The version is deliberately pinned so CI is reproducible; updates must be reviewed and tested rather than silently tracking a moving release.

## Host requirements

- Linux x86_64 build host (CI uses Ubuntu)
- Bash, curl, tar, make, GCC/G++, Perl, Python 3
- Buildroot host dependencies: bc, cpio, file, git, ncurses development headers, patch, rsync, unzip, wget, xz
- QEMU x86_64 system emulator and GNU core utilities for boot validation

## Build

From the repository root:

```bash
./scripts/build-qemu-image.sh
```

Optional environment variables:

- `BUILDROOT_VERSION`: pinned Buildroot release (default: `2025.02.19`)
- `SAIF_JOBS`: parallel build jobs (default: `2`)
- `SAIF_DL_DIR`: persistent Buildroot source-download cache
- `SAIF_OUTPUT_DIR`: output directory (default: `build-output/saif-qemu`)
- `SAIF_WORK_ROOT`: keep and use a caller-provided work directory instead of a temporary directory

The build enables GRUB2 x86_64 EFI, EDK2 OVMF firmware, a GPT partition table, a FAT EFI System Partition, and an ext4 root filesystem image. It produces:

- `saif-uefi-disk.img`: GPT disk image with EFI System Partition and SAIF root partition
- `OVMF_CODE.fd` and `OVMF_VARS.fd`: matching QEMU UEFI firmware files
- `saif-qemu-bzImage` and `saif-qemu-rootfs.ext2`: retained direct-kernel diagnostic artifacts
- Buildroot configuration, version metadata, and SHA-256 checksums

The EFI test uses a disposable copy of `OVMF_VARS.fd`; it does not modify the checked-in build artifact.

## Boot tests

The legacy diagnostic test:

```bash
./scripts/test-qemu-boot.sh
```

The UEFI disk test:

```bash
./scripts/test-qemu-uefi-boot.sh
```

The UEFI test starts QEMU with OVMF, attaches the GPT disk as a virtio block device and a user-mode virtio network device, and requires the kernel command-line marker `saif.boot=uefi`, the SAIF serial login banner, and evidence that the guest detected `eth0`. This validates the UEFI-to-GRUB-to-kernel path in QEMU only. It does not validate physical USB boot, Secure Boot, physical hardware, Wi-Fi, internet connectivity, disk installation, dual boot, or recovery.

## CI evidence

The `qemu-image` GitHub Actions job builds both image paths, runs the direct-kernel and OVMF UEFI boot tests, and uploads the disk image plus firmware, configuration, checksums, and serial logs as a 14-day artifact. A successful Rust-core job alone is not evidence that the operating-system image boots.

## Current limitations

- Console-only image. No graphical desktop, live desktop, installer, or mobile shell yet.
- No Windows application runtime or Android userspace/runtime integrated yet.
- No physical-device compatibility is claimed.
- The prototype is a Buildroot-generated Linux system with SAIF identity/overlay; it is not a custom SAIF kernel.
- Physical USB boot, secure boot/signing, disk installation, Windows dual boot, recovery, upstream source signature verification, SBOM, and complete source/toolchain provenance remain open work.
