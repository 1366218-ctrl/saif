# Building and Testing SAIF

## Current prototype target

The first executable product prototype is an x86_64 Linux-based SAIF image built with Buildroot and boot-tested in QEMU. This is a minimal console foundation, not yet a desktop environment and not an Android/Windows compatibility release.

Buildroot is pinned to the 2025.02 LTS line, currently selected at 2025.02.19. The LTS line is chosen for its longer maintenance window. The version is deliberately pinned so that CI is reproducible; updates must be reviewed and tested rather than silently tracking a moving release.

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

The build creates a Linux kernel image, an ext2 root filesystem, the resolved Buildroot configuration, version metadata, and SHA-256 checksums. The source archive is downloaded from the official Buildroot HTTPS download host. Before production release engineering, CI must additionally verify upstream release signatures and record the complete source/toolchain provenance.

## Boot test

Install `qemu-system-x86_64`, then run:

```bash
./scripts/test-qemu-boot.sh
```

The test starts QEMU with a serial console and requires the SAIF login banner to appear. QEMU is expected to keep running at the login prompt; the test stops it after the timeout and succeeds only if the banner was observed.

## CI evidence

The `qemu-image` GitHub Actions job builds the image, boots it, checks the serial banner, and uploads the image plus configuration, checksums, and serial log as a 14-day artifact. A successful Rust-core job alone is not evidence that the operating-system image boots.

## Current limitations

- Console-only image. No graphical desktop, installer, or mobile shell yet.
- No Windows application runtime or Android userspace/runtime integrated yet.
- No physical-device compatibility is claimed.
- The prototype is a Buildroot-generated Linux system with SAIF identity/overlay; it is not a custom SAIF kernel.
- Buildroot release signature verification and a complete SBOM pipeline remain release-engineering tasks.
